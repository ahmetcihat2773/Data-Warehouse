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

# Copy configuration files to Strimzi's expected locations
COPY config/server.properties /opt/kafka/config/kraft/server.properties
COPY config/log4j.properties /opt/kafka/config/log4j.properties

# Copy startup script
COPY --chmod=755 scripts/init-kraft.sh /usr/local/bin/init-kraft.sh

# Expose ports
EXPOSE 9092 29092 29093 9101

# Health check temporarily disabled to allow services to start
# HEALTHCHECK --interval=15s --timeout=10s --retries=5 \
#   CMD curl -f --connect-timeout 5 telnet://localhost:9092 || exit 1

# Use KRaft initialization script
CMD ["/usr/local/bin/init-kraft.sh"] 