FROM postgres:15-alpine

# Environment variables for the sink database
ENV POSTGRES_DB=sinkdb
ENV POSTGRES_USER=sinkuser
ENV POSTGRES_PASSWORD=sinkpass

# Install additional extensions if needed
RUN apk add --no-cache postgresql-contrib

# Copy initialization scripts
COPY init/01-create-sink-tables.sql /docker-entrypoint-initdb.d/

# Expose the default PostgreSQL port
EXPOSE 5432

# Custom healthcheck
HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB

# Use the default entrypoint from the base image 