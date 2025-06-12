#!/bin/bash
set -e

echo "Starting Kafka KRaft Broker initialization..."

# Set default cluster ID if not provided
KAFKA_CLUSTER_ID=${KAFKA_CLUSTER_ID:-MkU3OEVBNTcwNTJENDM2Qk}

# Create log directory if it doesn't exist
mkdir -p /tmp/kraft-combined-logs

# Check if storage is already formatted
if [ ! -f "/tmp/kraft-combined-logs/meta.properties" ]; then
    echo "Formatting KRaft storage with cluster ID: $KAFKA_CLUSTER_ID"
    /opt/kafka/bin/kafka-storage.sh format \
        --config /opt/kafka/config/kraft/server.properties \
        --cluster-id $KAFKA_CLUSTER_ID
else
    echo "Storage already formatted, skipping format step"
fi

# Wait a moment for filesystem to settle
sleep 2

echo "Starting Kafka server with KRaft configuration..."

# Export JMX settings
export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote \
-Dcom.sun.management.jmxremote.authenticate=false \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.local.only=false \
-Dcom.sun.management.jmxremote.port=9101 \
-Dcom.sun.management.jmxremote.rmi.port=9101 \
-Djava.rmi.server.hostname=host.docker.internal"

# Start Kafka server
exec /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties 