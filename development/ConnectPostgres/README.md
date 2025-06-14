# Kafka Connect - Custom Build

Bu klasör, Data Warehouse projesi için Kafka Connect'in custom build edilmesini sağlar.

## Dosya Yapısı

```
ConnectPostgres/
├── Dockerfile                           # Custom Kafka Connect build
├── env.list                             # Environment variables
├── config/
│   ├── connect-distributed.properties   # Connect worker configuration
│   └── log4j.properties                # Logging configuration
├── scripts/
│   └── connect-startup.sh              # Startup script with auto-deployment
├── workers/
│   ├── source-connector.json           # Debezium CDC source connector
│   └── sink-connector.json             # JDBC sink connector
├── connectors/                         # Custom connector JARs
└── README.md                          # Bu dosya
```

## Özellikler

- **Debezium CDC**: PostgreSQL için real-time Change Data Capture
- **JDBC Sink**: High-performance sink connector
- **Auto-deployment**: Otomatik connector kurulumu
- **Enhanced Logging**: Ayrıntılı log sistemi
- **Schema Registry**: Avro schema integration
- **Production Ready**: Robust error handling

## CDC Pipeline Akışı

```
PostgreSQL Source → Debezium → Kafka Topics → JDBC Sink → PostgreSQL Sink
     (users,orders)     ↓         (users,orders)        ↓      (users,orders)
                    Avro Schema                      Avro Schema
```

## Connector Konfigürasyonları

### Debezium Source Connector
- **Class**: `io.debezium.connector.postgresql.PostgresConnector`
- **Tables**: `public.users`, `public.orders`
- **Snapshot Mode**: `initial`
- **Plugin**: `pgoutput` (PostgreSQL 10+)
- **Topics**: `users`, `orders`

### JDBC Sink Connector
- **Class**: `io.confluent.connect.jdbc.JdbcSinkConnector`
- **Mode**: `upsert` (for CDC updates/deletes)
- **Tables**: Directly mapped from topics
- **Batch Size**: 500 records
- **Transform**: Debezium unwrap + metadata

## Kullanım

Docker Compose ile build etmek için:

```bash
# Sadece Kafka Connect'i build et
docker-compose build kafka-connect

# Tüm servisleri çalıştır
docker-compose up --build

# Sadece Connect'i çalıştır (dependencies ile birlikte)
docker-compose up kafka postgres-source postgres-sink schema-registry kafka-connect
```

## Connector Yönetimi

### REST API ile Yönetim
```bash
# Connector listesi
curl http://localhost:8083/connectors

# Source connector durumu
curl http://localhost:8083/connectors/debezium-postgres-source-connector/status

# Sink connector durumu
curl http://localhost:8083/connectors/postgres-jdbc-sink-connector/status

# Connector silme
curl -X DELETE http://localhost:8083/connectors/debezium-postgres-source-connector
```

### Manual Connector Deployment
```bash
# Source connector kurulumu
curl -X POST -H "Content-Type: application/json" \
  --data @workers/source-connector.json \
  http://localhost:8083/connectors

# Sink connector kurulumu
curl -X POST -H "Content-Type: application/json" \
  --data @workers/sink-connector.json \
  http://localhost:8083/connectors
```

## Environment Variables

Ana konfigürasyon `env.list` dosyasında:

### Core Settings
- `CONNECT_BOOTSTRAP_SERVERS`: Kafka broker'lar
- `CONNECT_GROUP_ID`: Connect cluster ID
- `CONNECT_REST_PORT`: REST API portu

### Topic Configuration
- `CONNECT_CONFIG_STORAGE_TOPIC`: Connector configurations
- `CONNECT_OFFSET_STORAGE_TOPIC`: Connector offsets
- `CONNECT_STATUS_STORAGE_TOPIC`: Connector status

### Converter Settings
- `CONNECT_KEY_CONVERTER`: String converter
- `CONNECT_VALUE_CONVERTER`: Avro converter
- `CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL`: Schema Registry

### Database Connections
- `POSTGRES_SOURCE_*`: Source database credentials
- `POSTGRES_SINK_*`: Sink database credentials
- `DEBEZIUM_SLOT_NAME`: PostgreSQL replication slot

## CDC Özellikleri

### Debezium Features
- **Initial Snapshot**: Mevcut verilerin initial load'u
- **Incremental Updates**: Real-time değişiklikleri yakalama
- **Schema Evolution**: Schema değişikliklerini takip
- **Delete Handling**: Silinen kayıtları işleme

### Data Transformations
- **ExtractNewRecordState**: Debezium wrapper'ı kaldırma
- **RegexRouter**: Topic adlarını transformation
- **InsertField**: Metadata alanları ekleme
- **Timestamp Conversion**: Zaman damgası dönüşümleri

## Monitoring

### Log İzleme
```bash
# Connect worker logs
docker exec kafka-connect tail -f /var/log/kafka-connect/connect.log

# Debezium CDC logs
docker exec kafka-connect tail -f /var/log/kafka-connect/debezium-cdc.log

# JDBC connector logs
docker exec kafka-connect tail -f /var/log/kafka-connect/jdbc-connector.log

# Task logs
docker exec kafka-connect tail -f /var/log/kafka-connect/connect-tasks.log
```

### Performance Metrics
```bash
# JMX metrics (if enabled)
curl http://localhost:8083/metrics

# Connector metrics
curl http://localhost:8083/connectors/debezium-postgres-source-connector/tasks/0/status
```

## Troubleshooting

### Common Issues

1. **Connector Failed to Start**
   ```bash
   # Check connector status
   curl http://localhost:8083/connectors/debezium-postgres-source-connector/status
   
   # Check Connect worker logs
   docker logs kafka-connect
   ```

2. **CDC Not Working**
   ```bash
   # Check PostgreSQL replication
   docker exec postgres-source psql -U source_user -d source_db -c "SELECT * FROM pg_replication_slots;"
   
   # Check publication
   docker exec postgres-source psql -U source_user -d source_db -c "SELECT * FROM pg_publication;"
   ```

3. **Schema Registry Issues**
   ```bash
   # Check schema registration
   curl http://localhost:8081/subjects
   
   # Check specific schema
   curl http://localhost:8081/subjects/users-value/versions/latest
   ```

### Debug Mode
Environment variable'larda debug modunu aktif etmek için:
```bash
CONNECT_LOG4J_ROOT_LOGLEVEL=DEBUG
```

## Data Flow Validation

### Source Verification
```bash
# PostgreSQL'de veri değişikliği
docker exec postgres-source psql -U source_user -d source_db -c "INSERT INTO users (username, email, first_name, last_name) VALUES ('test_user', 'test@example.com', 'Test', 'User');"
```

### Topic Verification
```bash
# Kafka topic'leri kontrol et
docker exec kafka kafka-topics --list --bootstrap-server localhost:9092

# Topic'lerdeki mesajları oku
docker exec kafka kafka-console-consumer --topic users --bootstrap-server localhost:9092 --from-beginning --max-messages 5
```

### Sink Verification
```bash
# Sink database'de verileri kontrol et
docker exec postgres-sink psql -U sink_user -d sink_db -c "SELECT * FROM users ORDER BY id DESC LIMIT 5;"
```

## Auto-deployment

Custom startup script sayesinde:
- ✅ Otomatik dependency beklemesi
- ✅ Connect topic'lerinin otomatik oluşturulması
- ✅ Connector'ların otomatik deployment'ı
- ✅ Graceful shutdown handling

Bu setup ile production-ready, real-time CDC pipeline hazır! 