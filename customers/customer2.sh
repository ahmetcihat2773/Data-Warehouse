#!/bin/bash

# Customer Information
export CUSTOMER_NAME="customer2"
export CUSTOMER_ID="CUST002"
export CUSTOMER_ENV="staging"

# Source Database Configuration
export SOURCE_DB_HOST="source-db.customer2.local"
export SOURCE_DB_PORT="5432"
export SOURCE_DB_NAME="customer2_source"
export SOURCE_DB_USER="customer2_source_user"
export SOURCE_DB_PASSWORD="customer2_source_pass"

# Sink Database Configuration
export SINK_DB_HOST="sink-db.customer2.local"
export SINK_DB_PORT="5432"
export SINK_DB_NAME="customer2_sink"
export SINK_DB_USER="customer2_sink_user"
export SINK_DB_PASSWORD="customer2_sink_pass"

# Kafka Configuration
export KAFKA_BOOTSTRAP_SERVERS="kafka.customer2.local:9092"
export KAFKA_SCHEMA_REGISTRY_URL="http://schema-registry.customer2.local:8081"

# Connector Names
export SOURCE_CONNECTOR_NAME="${CUSTOMER_NAME}-source-connector"
export SINK_CONNECTOR_NAME="${CUSTOMER_NAME}-sink-connector"

# Topic Prefixes
export TOPIC_PREFIX="${CUSTOMER_NAME}"
export SCHEMA_CHANGE_TOPIC="${TOPIC_PREFIX}.schema-changes"
export DB_HISTORY_TOPIC="${TOPIC_PREFIX}.db-history" 