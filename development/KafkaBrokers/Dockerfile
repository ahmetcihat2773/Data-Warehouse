FROM quay.io/strimzi/kafka:latest-kafka-2.8.1

# Use Strimzi's default log directory for KRaft
ENV KAFKA_LOG_DIRS=/tmp/kraft-combined-logs

# Performance and reliability settings
ENV KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1
ENV KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0
ENV KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1
ENV KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1
ENV KAFKA_AUTO_CREATE_TOPICS_ENABLE=true

# JMX settings for monitoring
ENV KAFKA_JMX_PORT=9101
ENV KAFKA_JMX_HOSTNAME=host.docker.internal

# Copy configuration files
COPY config/server.properties /opt/kafka/config/server.properties
COPY config/log4j.properties /opt/kafka/config/log4j.properties

# Create necessary directories and set permissions
USER root
RUN mkdir -p /opt/kafka/logs /tmp/kafka-logs && \
    chmod -R 777 /opt/kafka/logs /tmp/kafka-logs

# Expose ports
EXPOSE 9092 29092 29093 9101

# Health check - simple port check
HEALTHCHECK --interval=15s --timeout=10s --retries=5 \
  CMD nc -z localhost 9092 || exit 1

# Start Kafka with Zookeeper-based configuration
CMD ["/opt/kafka/bin/kafka-server-start.sh", "/opt/kafka/config/server.properties"] 