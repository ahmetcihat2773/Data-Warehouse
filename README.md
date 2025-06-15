# Data Warehouse (DWH) Project

## Project Overview
This project implements a real-time data transfer system between databases using Kafka Connect and Debezium. The initial implementation focuses on PostgreSQL to PostgreSQL data transfer, with plans to expand to other database types and file system monitoring.

## Project Structure

```
dwh/
├── frontend/             # Modern web interface (Next.js + TypeScript + Tailwind)
├── development/          # Docker Compose setup for local development
│   ├── docker-compose.yaml
│   ├── connectors/
│   ├── Database/
│   ├── KafkaBrokers/
│   ├── KafkaUI/
│   ├── SchemaRegistry/
│   ├── DataGenerator/
│   └── ConnectPostgres/
├── deployment/           # Helm charts for Kubernetes deployment
│   ├── infrastructure/   # Shared infrastructure components
│   └── connect-postgres/ # Customer-specific Kafka Connect
├── customers/            # Customer configuration files
│   ├── customer1.sh
│   ├── customer2.sh
│   └── load_customer.sh
├── .devcontainer/        # Development container configuration
├── .github/              # GitHub workflows and configurations
└── README.md
```

## Architecture
The system consists of the following components:
- Source PostgreSQL Database
- Sink PostgreSQL Database
- Kafka Broker (with KRaft mode)
- Kafka Connect
- Schema Registry
- Kafka UI for management
- Data Generator (for testing)
- Modern Web Interface

## Features
- Real-time data synchronization between databases
- Schema evolution support through Schema Registry
- Dead Letter Queue implementation for error handling
- Monitoring and alerting system for Kafka Connect status
- Data validation mechanisms
- Multi-tenant support with customer-specific configurations
- Modern web interface for management and monitoring

## Project Phases
1. Phase 1: PostgreSQL → PostgreSQL data transfer
2. Phase 2: Support for additional databases (MySQL, MongoDB, etc.)
3. Phase 3: File/Directory watching (real-time file processing)
4. Phase 4: Advanced web interface with real-time monitoring

## Technical Stack
- Docker & Docker Compose for containerization
- Apache Kafka for event streaming
- Debezium for CDC (Change Data Capture)
- Confluent Schema Registry for schema management
- Kafka Connect for data pipeline management
- Kubernetes & Helm for production deployment
- Next.js, TypeScript & Tailwind CSS for web interface

## Customer Configuration Management

The project supports multiple customers through a configuration management system. Each customer has their own configuration file in the `customers` directory.

### Customer Configuration Structure

Each customer configuration file (`customers/<customer_name>.sh`) contains:
- Customer Information (name, ID, environment)
- Source Database Configuration
- Sink Database Configuration
- Kafka Configuration
- Connector Names
- Topic Prefixes

### Using Customer Configurations

To load a customer's configuration:

```bash
# Load customer1 configuration
source customers/load_customer.sh customer1

# Load customer2 configuration
source customers/load_customer.sh customer2
```

The `load_customer.sh` script will:
1. Load the specified customer's configuration
2. Verify all required variables are set
3. Display the loaded configuration details

### Available Customers

To list all available customer configurations:
```bash
source customers/load_customer.sh
```

## Frontend Development

For the web interface development:

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

See [frontend/README.md](frontend/README.md) for detailed frontend development instructions.

## Development Environment

For local development and testing, use Docker Compose:

```bash
# Navigate to development directory
cd development

# Start all services
docker compose up -d

# Check service status
docker compose ps
```

See [development/README.md](development/README.md) for detailed development instructions.

## Production Deployment

For Kubernetes deployment, use Helm charts:

```bash
# Deploy infrastructure (shared components)
helm install infrastructure ./deployment/infrastructure

# Deploy customer-specific Kafka Connect
source customers/load_customer.sh customer1
helm install customer1-connect ./deployment/connect-postgres
```

See [deployment/README.md](deployment/README.md) for detailed deployment instructions.

## Access Points

### Development Environment
- Web Interface: http://localhost:3000 (frontend dev server)
- Kafka UI: http://localhost:8080
- Kafka Connect: http://localhost:8083
- Schema Registry: http://localhost:8081
- Source PostgreSQL: localhost:5432
- Sink PostgreSQL: localhost:5435

### Production Environment
- Access through Kubernetes services and ingress configurations

## Monitoring
- Modern web interface for system overview and monitoring
- Kafka UI provides a web interface for monitoring topics, connectors, and messages
- Health checks are implemented for all services
- Connector status can be monitored through Kafka Connect REST API

## Future Enhancements
- Support for additional database types
- File system monitoring capabilities
- Enhanced error handling and retry mechanisms
- Advanced monitoring and alerting
- Data validation and quality checks
- Real-time dashboard with metrics and analytics

SELECT rolname, rolpassword FROM pg_authid WHERE rolname = 'dwh_sink_user';"

