# Data Warehouse (DWH) Project

## Project Overview
This project implements a real-time data transfer system between databases using Kafka Connect and Debezium. The initial implementation focuses on PostgreSQL to PostgreSQL data transfer, with plans to expand to other database types and file system monitoring.

## Architecture
The system consists of the following components:
- Source PostgreSQL Database
- Sink PostgreSQL Database
- Kafka Broker (with KRaft mode)
- Kafka Connect
- Schema Registry
- Kafka UI for management
- Data Generator (for testing)

## Features
- Real-time data synchronization between databases
- Schema evolution support through Schema Registry
- Dead Letter Queue implementation for error handling
- Monitoring and alerting system for Kafka Connect status
- Data validation mechanisms

## Project Phases
1. Phase 1: PostgreSQL → PostgreSQL data transfer
2. Phase 2: Support for additional databases (MySQL, MongoDB, etc.)
3. Phase 3: File/Directory watching (real-time file processing)

## Technical Stack
- Docker & Docker Compose for containerization
- Apache Kafka for event streaming
- Debezium for CDC (Change Data Capture)
- Confluent Schema Registry for schema management
- Kafka Connect for data pipeline management

## Setup Instructions

### Prerequisites
- Docker
- Docker Compose

### Starting the Services
```bash
# Start all services
docker compose up -d

# Check service status
docker compose ps
```

### Managing Kafka Connectors
```bash
# Create source connector
curl -X POST -H "Content-Type: application/json" --data-binary @config/source-connector.json http://localhost:8083/connectors

# Create sink connector
curl -X POST -H "Content-Type: application/json" --data-binary @config/sink-connector.json http://localhost:8083/connectors

# List all connectors
curl http://localhost:8083/connectors

# Check connector status
curl http://localhost:8083/connectors/postgres-source-connector/status

# List Kafka topics
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --list

# Delete connectors if needed
curl -X DELETE http://localhost:8083/connectors/postgres-source-connector
curl -X DELETE http://localhost:8083/connectors/postgres-sink-connector
```

## Access Points
- Kafka UI: http://localhost:8080
- Kafka Connect: http://localhost:8083
- Schema Registry: http://localhost:8081
- Source PostgreSQL: localhost:5432
- Sink PostgreSQL: localhost:5435

## Monitoring
- Kafka UI provides a web interface for monitoring topics, connectors, and messages
- Health checks are implemented for all services
- Connector status can be monitored through Kafka Connect REST API

## Future Enhancements
- Support for additional database types
- File system monitoring capabilities
- Enhanced error handling and retry mechanisms
- Advanced monitoring and alerting
- Data validation and quality checks

SELECT rolname, rolpassword FROM pg_authid WHERE rolname = 'dwh_sink_user';"

