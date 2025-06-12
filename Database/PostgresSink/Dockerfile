FROM postgres:15-alpine

# Environment variables for the sink database
ENV POSTGRES_DB=sink_db
ENV POSTGRES_USER=sink_user
ENV POSTGRES_PASSWORD=sink_password

# Install additional extensions if needed
RUN apk add --no-cache postgresql-contrib

# Copy initialization scripts
COPY init/ /docker-entrypoint-initdb.d/

# Copy custom postgresql.conf and pg_hba.conf
COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg_hba.conf /etc/postgresql/pg_hba.conf

# Expose the default PostgreSQL port
EXPOSE 5432

# Custom healthcheck
HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB

# Use the default entrypoint from the base image 