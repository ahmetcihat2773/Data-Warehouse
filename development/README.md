# Development Environment

This directory contains all Docker Compose related files for local development and testing.

## Structure

- `docker-compose.yaml` - Main Docker Compose configuration
- `avro-source-connector.json` - Avro source connector configuration
- `connectors/` - Connector configuration files
- `SchemaRegistry/` - Schema Registry Docker configuration
- `KafkaUI/` - Kafka UI Docker configuration  
- `KafkaBrokers/` - Kafka Brokers Docker configuration
- `Database/` - PostgreSQL databases Docker configuration
- `DataGenerator/` - Data generator Docker configuration
- `ConnectPostgres/` - Kafka Connect PostgreSQL Docker configuration

## Usage

### Starting the Development Environment

```bash
# Navigate to development directory
cd development

# Start all services
docker compose up -d

# Check service status
docker compose ps

# View logs
docker compose logs -f
```

### Stopping the Development Environment

```bash
# Stop all services
docker compose down

# Stop and remove volumes (clean slate)
docker compose down -v
```

### Managing Individual Services

```bash
# Start specific service
docker compose up -d kafka

# Restart specific service
docker compose restart kafka-connect

# View logs for specific service
docker compose logs -f kafka-ui
```

## Access Points

- Kafka UI: http://localhost:8080
- Kafka Connect: http://localhost:8083
- Schema Registry: http://localhost:8081
- Source PostgreSQL: localhost:5432
- Sink PostgreSQL: localhost:5435

## Development Workflow

1. Start the development environment
2. Create and test connectors using the provided JSON configurations
3. Monitor data flow through Kafka UI
4. Test schema evolution with Schema Registry
5. Validate data in sink databases 