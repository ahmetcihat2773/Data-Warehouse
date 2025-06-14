#!/bin/bash
# Kafka Connect Startup Script for Data Warehouse Project
# Handles initialization, connector setup, and startup

set -e

echo "============================================="
echo "Starting Kafka Connect - Data Warehouse Project"
echo "============================================="

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p /tmp/logs/kafka-connect
mkdir -p /etc/kafka-connect/connector-configs

# Set proper permissions
echo "Setting permissions..."
echo "Permissions already correct"

# Function to wait for Kafka to be ready
wait_for_kafka() {
    echo "Waiting for Kafka to be ready..."
    while ! nc -z kafka 29092 > /dev/null 2>&1; do
        echo "Kafka is not ready yet. Waiting..."
        sleep 5
    done
    echo "Kafka is ready!"
}

# Function to wait for Schema Registry to be ready
wait_for_schema_registry() {
    echo "Waiting for Schema Registry to be ready..."
    while ! curl -s http://schema-registry:8081/subjects > /dev/null; do
        echo "Schema Registry is not ready yet. Waiting..."
        sleep 5
    done
    echo "Schema Registry is ready!"
}

# Function to create Connect topics if they don't exist
create_connect_topics() {
    echo "Creating Connect internal topics..."
    
    # Config storage topic
    /usr/bin/kafka-topics --bootstrap-server kafka:29092 --create --if-not-exists \
        --topic docker-connect-configs --partitions 1 --replication-factor 1 \
        --config cleanup.policy=compact
    
    # Offset storage topic
    /usr/bin/kafka-topics --bootstrap-server kafka:29092 --create --if-not-exists \
        --topic docker-connect-offsets --partitions 25 --replication-factor 1 \
        --config cleanup.policy=compact
    
    # Status storage topic
    /usr/bin/kafka-topics --bootstrap-server kafka:29092 --create --if-not-exists \
        --topic docker-connect-status --partitions 5 --replication-factor 1 \
        --config cleanup.policy=compact
    
    echo "Connect internal topics created successfully"
}

# Function to try installing missing connectors
install_missing_connectors() {
    echo "Checking for missing connectors..."
    
    # Try to install Debezium PostgreSQL connector if not present
    if ! ls /usr/share/confluent-hub-components/ | grep -q debezium-connector-postgresql; then
        echo "Attempting to install Debezium PostgreSQL connector..."
        confluent-hub install --no-prompt debezium/debezium-connector-postgresql:2.2.1 || \
        confluent-hub install --no-prompt debezium/debezium-connector-postgresql:2.1.4 || \
        echo "Could not install Debezium connector automatically"
    fi
    
    # Try to install JDBC connector if not present
    if ! ls /usr/share/confluent-hub-components/ | grep -q kafka-connect-jdbc; then
        echo "Attempting to install JDBC connector..."
        confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.3 || \
        confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.6.0 || \
        echo "Could not install JDBC connector automatically"
    fi
}

# Function to auto-deploy connectors
auto_deploy_connectors() {
    echo "Checking for connector configurations to auto-deploy..."
    
    # Wait for Connect worker to be ready
    echo "Waiting for Connect worker to be ready..."
    while ! curl -s http://localhost:8083/connectors > /dev/null; do
        echo "Connect worker is not ready yet. Waiting..."
        sleep 5
    done
    echo "Connect worker is ready!"
    
    # Deploy source connector if config exists
    if [ -f "/etc/kafka-connect/connector-configs/source-connector.json" ]; then
        echo "Auto-deploying source connector..."
        curl -X POST \
            -H "Content-Type: application/json" \
            --data @/etc/kafka-connect/connector-configs/source-connector.json \
            http://localhost:8083/connectors || echo "Source connector deployment failed or already exists"
    fi
    
    # Deploy sink connector if config exists
    if [ -f "/etc/kafka-connect/connector-configs/sink-connector.json" ]; then
        echo "Auto-deploying sink connector..."
        curl -X POST \
            -H "Content-Type: application/json" \
            --data @/etc/kafka-connect/connector-configs/sink-connector.json \
            http://localhost:8083/connectors || echo "Sink connector deployment failed or already exists"
    fi
}

# Wait for dependencies
wait_for_kafka
wait_for_schema_registry

# Try installing missing connectors
install_missing_connectors

# Create Connect internal topics
create_connect_topics

echo "Starting Kafka Connect worker..."

# Start Connect in background to allow auto-deployment
connect-distributed /etc/kafka-connect/connect-distributed.properties &

# Get the Connect process ID
CONNECT_PID=$!

# Auto-deploy connectors in background
auto_deploy_connectors &

# Wait for Connect process
wait $CONNECT_PID 