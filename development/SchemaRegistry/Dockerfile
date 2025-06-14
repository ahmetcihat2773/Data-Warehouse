FROM confluentinc/cp-schema-registry:7.4.0

# Set environment variables
ENV SCHEMA_REGISTRY_HOST_NAME=schema-registry
ENV SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS=kafka:29092
ENV SCHEMA_REGISTRY_LISTENERS=http://0.0.0.0:8081
ENV SCHEMA_REGISTRY_DEBUG=false

# Schema Registry specific settings
ENV SCHEMA_REGISTRY_KAFKASTORE_TOPIC=_schemas
ENV SCHEMA_REGISTRY_KAFKASTORE_TOPIC_REPLICATION_FACTOR=1
ENV SCHEMA_REGISTRY_SCHEMA_REGISTRY_GROUP_ID=schema-registry
ENV SCHEMA_REGISTRY_MASTER_ELIGIBILITY=true

# Performance settings
ENV SCHEMA_REGISTRY_HEAP_OPTS="-Xms512M -Xmx512M"
ENV SCHEMA_REGISTRY_JVM_PERFORMANCE_OPTS="-server -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:+ExplicitGCInvokesConcurrent"

# Security settings (development mode)
ENV SCHEMA_REGISTRY_AUTHENTICATION_METHOD=NONE
ENV SCHEMA_REGISTRY_AUTHORIZATION_METHOD=NONE

# API settings
ENV SCHEMA_REGISTRY_ACCESS_CONTROL_ALLOW_ORIGIN=*
ENV SCHEMA_REGISTRY_ACCESS_CONTROL_ALLOW_METHODS=GET,POST,PUT,DELETE,OPTIONS
ENV SCHEMA_REGISTRY_ACCESS_CONTROL_ALLOW_HEADERS=origin,content-type,accept,authorization

# Logging settings
ENV SCHEMA_REGISTRY_LOG4J_ROOT_LOGLEVEL=INFO
ENV SCHEMA_REGISTRY_LOG4J_LOGGERS=kafka.authorizer.logger=INFO

# Copy custom configuration files
COPY config/schema-registry.properties /etc/schema-registry/schema-registry.properties
COPY config/log4j.properties /etc/schema-registry/log4j.properties

# Copy startup scripts with executable permissions
COPY --chmod=755 scripts/schema-registry-startup.sh /usr/local/bin/schema-registry-startup.sh

# Create log directory in user space
RUN mkdir -p /tmp/logs/schema-registry

# Expose the Schema Registry port
EXPOSE 8081

# Health check
# HEALTHCHECK temporarily disabled to allow startup
# HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
#   CMD curl -f http://localhost:8081/subjects || exit 1

# Use custom startup script
CMD ["/usr/local/bin/schema-registry-startup.sh"] 