FROM postgres:15-alpine

# Environment variables for the source database
ENV POSTGRES_DB=source_db
ENV POSTGRES_USER=source_user
ENV POSTGRES_PASSWORD=source_password
# Using default PostgreSQL authentication

# Install additional extensions if needed
RUN apk add --no-cache postgresql-contrib

# Copy initialization scripts
COPY init/ /docker-entrypoint-initdb.d/

# Copy custom postgresql.conf if needed
COPY postgresql.conf /etc/postgresql/postgresql.conf

# Expose the default PostgreSQL port
EXPOSE 5432

# Custom healthcheck
HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB

# Use the default entrypoint from the base image 