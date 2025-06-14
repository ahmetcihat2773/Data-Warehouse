#!/bin/bash

# Customer Information
export CUSTOMER_NAME="customer1"
export CUSTOMER_ID="CUST001"
export CUSTOMER_ENV="production"

# Source Database Configuration
export SOURCE_DB_HOST="source-db.customer1.local"
export SOURCE_DB_PORT="5432"
export SOURCE_DB_NAME="customer1_source"
export SOURCE_DB_USER="customer1_source_user"
export SOURCE_DB_PASSWORD="customer1_source_pass"

# Sink Database Configuration
export SINK_DB_HOST="sink-db.customer1.local"
export SINK_DB_PORT="5432"
export SINK_DB_NAME="customer1_sink"
export SINK_DB_USER="customer1_sink_user"
export SINK_DB_PASSWORD="customer1_sink_pass"

# Kafka Configuration
export KAFKA_BOOTSTRAP_SERVERS="kafka.customer1.local:9092"
export KAFKA_SCHEMA_REGISTRY_URL="http://schema-registry.customer1.local:8081"

# Connector Names
export SOURCE_CONNECTOR_NAME="${CUSTOMER_NAME}-source-connector"
export SINK_CONNECTOR_NAME="${CUSTOMER_NAME}-sink-connector"

# Topic Prefixes
export TOPIC_PREFIX="${CUSTOMER_NAME}"
export SCHEMA_CHANGE_TOPIC="${TOPIC_PREFIX}.schema-changes"
export DB_HISTORY_TOPIC="${TOPIC_PREFIX}.db-history" 