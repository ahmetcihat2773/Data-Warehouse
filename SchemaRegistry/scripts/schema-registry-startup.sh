#!/bin/bash
# Schema Registry Startup Script for Data Warehouse Project
# Handles initialization, dependency waiting, and startup

set -e

echo "================================================="
echo "Starting Schema Registry - Data Warehouse Project"
echo "================================================="

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p /tmp/logs/schema-registry

# Set proper permissions
echo "Setting permissions..."
echo "Using default permissions for Schema Registry"

# Function to wait for Kafka to be ready
wait_for_kafka() {
    echo "Waiting for Kafka to be ready..."
    while ! nc -z kafka 29092 > /dev/null 2>&1; do
        echo "Kafka is not ready yet. Waiting..."
        sleep 5
    done
    echo "Kafka is ready!"
}

# Function to create schema topic if it doesn't exist
create_schema_topic() {
    echo "Creating _schemas topic if it doesn't exist..."
    echo "Topic _schemas will be created automatically by Schema Registry"
    echo "Schema topic setup completed"
}

# Function to validate schema registry configuration
validate_config() {
    echo "Validating Schema Registry configuration..."
    
    # Check if required environment variables are set
    if [ -z "$SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS" ]; then
        echo "ERROR: SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS is not set"
        exit 1
    fi
    
    if [ -z "$SCHEMA_REGISTRY_HOST_NAME" ]; then
        echo "ERROR: SCHEMA_REGISTRY_HOST_NAME is not set"
        exit 1
    fi
    
    echo "Configuration validation completed"
}

# Function to setup initial schemas (if needed)
setup_initial_schemas() {
    echo "Setting up initial schemas if needed..."
    
    # Wait for Schema Registry to be ready
    sleep 10
    
    # Check if Schema Registry is responding
    while ! curl -s http://localhost:8081/subjects > /dev/null; do
        echo "Schema Registry is not ready yet. Waiting..."
        sleep 5
    done
    
    echo "Schema Registry is responding to API calls"
    
    # Optional: Register initial schemas here
    # Example:
    # curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
    #   --data '{"schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"id\", \"type\": \"int\"}, {\"name\": \"name\", \"type\": \"string\"}]}"}' \
    #   http://localhost:8081/subjects/user-value/versions
    
    echo "Initial schema setup completed"
}

# Function to configure compatibility levels
configure_compatibility() {
    echo "Configuring global compatibility level..."
    
    # Wait a bit more for Schema Registry to be fully ready
    sleep 5
    
    # Set global compatibility level
    curl -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" \
        --data '{"compatibility": "BACKWARD"}' \
        http://localhost:8081/config || echo "Failed to set global compatibility level"
    
    echo "Compatibility configuration completed"
}

# Wait for dependencies
wait_for_kafka

# Validate configuration
validate_config

# Create schema topic
create_schema_topic

echo "Starting Schema Registry..."

# Start Schema Registry in background to allow post-startup configuration
schema-registry-start /etc/schema-registry/schema-registry.properties &

# Get the Schema Registry process ID
SCHEMA_REGISTRY_PID=$!

# Setup initial configurations in background
{
    setup_initial_schemas
    configure_compatibility
} &

# Wait for Schema Registry process
wait $SCHEMA_REGISTRY_PID 