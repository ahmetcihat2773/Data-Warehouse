# Deployment

This directory contains Helm charts for Kubernetes deployment.

## Structure

- `infrastructure/` - Infrastructure components Helm chart (Kafka, Schema Registry, Kafka UI)
- `connect-postgres/` - PostgreSQL Kafka Connect Helm chart (customer-specific)

## Infrastructure Chart

The infrastructure chart deploys the core Kafka ecosystem components that are shared across all customers:

- Kafka Brokers (StatefulSet with 3 replicas)
- Schema Registry (Deployment)
- Kafka UI (Deployment)

### Deploying Infrastructure

```bash
# Deploy infrastructure components
helm install infrastructure ./deployment/infrastructure

# Check deployment status
kubectl get pods

# Access services
kubectl port-forward svc/kafka-ui 8080:8080
kubectl port-forward svc/schema-registry 8081:8081
```

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

## Monitoring

```bash
# Check all deployments
helm list

# Check pod status
kubectl get pods

# View logs
kubectl logs -f deployment/kafka-connect

# Check connector status
kubectl exec -it deployment/kafka-connect -- curl localhost:8083/connectors
```

## Cleanup

```bash
# Remove customer-specific deployment
helm uninstall customer1-connect

# Remove infrastructure
helm uninstall infrastructure
``` 