FROM confluentinc/cp-kafka-connect:7.4.0

# Set environment variables
ENV CONNECT_BOOTSTRAP_SERVERS=kafka:29092
ENV CONNECT_REST_ADVERTISED_HOST_NAME=kafka-connect
ENV CONNECT_REST_PORT=8083
ENV CONNECT_GROUP_ID=compose-connect-group
ENV CONNECT_CONFIG_STORAGE_TOPIC=docker-connect-configs
ENV CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR=1
ENV CONNECT_OFFSET_STORAGE_TOPIC=docker-connect-offsets
ENV CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR=1
ENV CONNECT_STATUS_STORAGE_TOPIC=docker-connect-status
ENV CONNECT_STATUS_STORAGE_REPLICATION_FACTOR=1

# Converter configuration
ENV CONNECT_KEY_CONVERTER=org.apache.kafka.connect.storage.StringConverter
ENV CONNECT_VALUE_CONVERTER=io.confluent.connect.avro.AvroConverter
ENV CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL=http://schema-registry:8081

# Plugin path
ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components,/etc/kafka-connect/jars"

# Logging configuration
ENV CONNECT_LOG4J_LOGGERS="org.apache.zookeeper=ERROR,org.I0Itec.zkclient=ERROR,org.reflections=ERROR"

# Performance settings
ENV CONNECT_OFFSET_FLUSH_INTERVAL_MS=10000
ENV CONNECT_TASK_SHUTDOWN_GRACEFUL_TIMEOUT_MS=30000
ENV CONNECT_OFFSET_FLUSH_TIMEOUT_MS=5000

# Create connector directories
RUN mkdir -p /usr/share/java/kafka-connect-jdbc && \
    mkdir -p /usr/share/java/debezium-connector-postgresql

# Download PostgreSQL JDBC driver (needed for both source and sink)
RUN curl -L -o /usr/share/java/kafka-connect-jdbc/postgresql-42.6.0.jar \
    https://repo1.maven.org/maven2/org/postgresql/postgresql/42.6.0/postgresql-42.6.0.jar

# Note: Debezium and JDBC connectors will be installed via startup script if available
# This allows the container to start even if specific connectors aren't available

# Copy connector configurations (keep this for later use)
COPY workers/ /etc/kafka-connect/connector-configs/

# Configuration will be set via environment variables

# Copy any additional connector JARs (if they exist)
# COPY connectors/ /etc/kafka-connect/jars/
# Uncomment above line and create connectors/ directory if you have custom connector JARs

# Create necessary directories in user space
RUN mkdir -p /tmp/logs/kafka-connect

# Expose the Connect REST port
EXPOSE 8083

# Health check
HEALTHCHECK --interval=15s --timeout=10s --retries=10 \
  CMD curl -f http://localhost:8083/connectors || exit 1

# Use standard Confluent startup
CMD ["/etc/confluent/docker/run"] 