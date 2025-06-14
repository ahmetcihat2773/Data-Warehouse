FROM provectuslabs/kafka-ui:latest

# Environment variables for KafkaUI
ENV DYNAMIC_CONFIG_ENABLED=true
ENV KAFKA_CLUSTERS_0_NAME=local
ENV KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka:29092
ENV KAFKA_CLUSTERS_0_SCHEMAREGISTRY=http://schema-registry:8081
ENV KAFKA_CLUSTERS_0_KAFKACONNECT_0_NAME=main
ENV KAFKA_CLUSTERS_0_KAFKACONNECT_0_ADDRESS=http://kafka-connect:8083

# Additional configuration
ENV LOGGING_LEVEL_ROOT=INFO

# Expose the default port
EXPOSE 8080

# Health check temporarily disabled
# HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
#   CMD wget --no-verbose --tries=1 --spider http://localhost:8080 || exit 1

# Use the default entrypoint from the base image 