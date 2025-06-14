# Deployment

This directory contains Helm charts for Kubernetes deployment.

## Structure

- `infrastructure/` - Complete infrastructure components Helm chart (Kafka, Schema Registry, Kafka UI, PostgreSQL Databases)
- `connect-postgres/` - PostgreSQL Kafka Connect Helm chart (customer-specific)

## Infrastructure Chart

The infrastructure chart deploys all core components that are shared across all customers:

- **PostgreSQL Databases:**
  - Source PostgreSQL (with replication settings for Debezium)
  - Sink PostgreSQL
- **Kafka Ecosystem:**
  - Kafka Brokers (StatefulSet with 3 replicas)
  - Schema Registry (Deployment)
  - Kafka UI (Deployment)

### Deploying Infrastructure

```bash
# Deploy complete infrastructure
helm install infrastructure ./deployment/infrastructure

# Check deployment status
kubectl get pods

# Access services
kubectl port-forward svc/kafka-ui 8080:8080
kubectl port-forward svc/schema-registry 8081:8081
kubectl port-forward svc/postgres-source 5432:5432
kubectl port-forward svc/postgres-sink 5433:5432
```

### Infrastructure Components

#### PostgreSQL Databases
- **Source Database**: `postgres-source` service on port 5432
  - Database: `source_db`
  - User: `source_user`
  - Password: `source_password`
  - Configured for logical replication (Debezium)

- **Sink Database**: `postgres-sink` service on port 5432
  - Database: `sinkdb`
  - User: `sinkuser`
  - Password: `sinkpass`

#### Kafka Components
- **Kafka Brokers**: 3 replicas with persistent storage
- **Schema Registry**: Single instance for schema management
- **Kafka UI**: Web interface for monitoring

## Connect PostgreSQL Chart

The connect-postgres chart deploys customer-specific Kafka Connect instances with PostgreSQL connectors.

### Customer-Specific Deployment

1. Load customer configuration:
```bash
source customers/load_customer.sh customer1
```

2. Deploy customer-specific connect:
```bash
helm install customer1-connect ./deployment/connect-postgres
```

3. Verify deployment:
```bash
kubectl get pods -l app=kafka-connect
kubectl logs -l app=kafka-connect
```

### Multiple Customer Deployments

Each customer gets their own Kafka Connect deployment:

```bash
# Customer 1
source customers/load_customer.sh customer1
helm install customer1-connect ./deployment/connect-postgres

# Customer 2  
source customers/load_customer.sh customer2
helm install customer2-connect ./deployment/connect-postgres
```

## Environment Variables

The charts use environment variables from customer configuration files:

- `CUSTOMER_NAME` - Customer identifier
- `SOURCE_DB_*` - Source database connection details
- `SINK_DB_*` - Sink database connection details
- `KAFKA_BOOTSTRAP_SERVERS` - Kafka cluster connection
- `KAFKA_SCHEMA_REGISTRY_URL` - Schema Registry URL

## Database Access

### Connecting to Databases

```bash
# Connect to source database
kubectl exec -it postgres-source-0 -- psql -U source_user -d source_db

# Connect to sink database
kubectl exec -it postgres-sink-0 -- psql -U sinkuser -d sinkdb
```

### Database Initialization

Both databases are automatically initialized with:
- Required users and databases
- Proper permissions
- Replication settings (source database only)

## Monitoring

```bash
# Check all deployments
helm list

# Check pod status
kubectl get pods

# View database logs
kubectl logs -f postgres-source-0
kubectl logs -f postgres-sink-0

# View Kafka logs
kubectl logs -f kafka-0

# Check connector status
kubectl exec -it deployment/kafka-connect -- curl localhost:8083/connectors
```

## Cleanup

```bash
# Remove customer-specific deployment
helm uninstall customer1-connect

# Remove complete infrastructure
helm uninstall infrastructure
```

## Storage

All components use persistent storage:
- PostgreSQL databases: 5Gi each
- Kafka brokers: 10Gi each
- Default storage class: "standard"

Storage settings can be customized in `values.yaml`. 