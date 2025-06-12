# Schema Registry - Custom Build

Bu klasör, Data Warehouse projesi için Schema Registry'nin custom build edilmesini sağlar.

## Dosya Yapısı

```
SchemaRegistry/
├── Dockerfile                      # Custom Schema Registry build
├── env.list                        # Environment variables
├── config/
│   ├── schema-registry.properties  # Schema Registry configuration
│   └── log4j.properties           # Logging configuration
├── scripts/
│   └── schema-registry-startup.sh # Startup script with auto-configuration
└── README.md                      # Bu dosya
```

## Özellikler

- **Multi-Format Support**: Avro, JSON Schema, Protobuf desteği
- **Backward Compatibility**: Schema evolution management
- **Enhanced Logging**: Ayrıntılı log sistemi
- **Performance Tuned**: CDC workload için optimize
- **Auto-configuration**: Otomatik setup ve dependency management
- **CORS Enabled**: Web UI integration için

## Schema Registry Konfigürasyonu

### Core Settings
- **Host**: `schema-registry:8081`
- **Kafka Store**: `kafka:29092`
- **Topic**: `_schemas` (compacted)
- **Compatibility**: `BACKWARD` (default)

### Supported Formats
- **Avro**: Primary format for CDC
- **JSON Schema**: Draft 7 specification
- **Protobuf**: Multi-file support

### Performance Settings
- **Heap**: 512MB (Xms/Xmx)
- **GC**: G1GC with 20ms pause target
- **Cache**: 1000 schemas, 5 min expiry

## Kullanım

Docker Compose ile build etmek için:

```bash
# Sadece Schema Registry'yi build et
docker-compose build schema-registry

# Tüm servisleri çalıştır
docker-compose up --build

# Sadece Schema Registry'yi çalıştır (dependencies ile birlikte)
docker-compose up kafka schema-registry
```

## Schema Yönetimi

### REST API ile Yönetim
```bash
# Schema Registry durumu
curl http://localhost:8081/subjects

# Global compatibility level
curl http://localhost:8081/config

# Compatibility level ayarlama
curl -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{"compatibility": "BACKWARD"}' \
  http://localhost:8081/config

# Subject listesi
curl http://localhost:8081/subjects
```

### Schema Operations
```bash
# Schema kaydetme (Avro örneği)
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{"schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"id\", \"type\": \"int\"}, {\"name\": \"username\", \"type\": \"string\"}]}"}' \
  http://localhost:8081/subjects/users-value/versions

# Schema sürümleri görme
curl http://localhost:8081/subjects/users-value/versions

# Belirli sürüm alma
curl http://localhost:8081/subjects/users-value/versions/1

# Schema silme
curl -X DELETE http://localhost:8081/subjects/users-value/versions/1
```

## Environment Variables

Ana konfigürasyon `env.list` dosyasında:

### Core Settings
- `SCHEMA_REGISTRY_HOST_NAME`: Host name
- `SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS`: Kafka brokers
- `SCHEMA_REGISTRY_LISTENERS`: HTTP listeners

### Kafka Store Settings
- `SCHEMA_REGISTRY_KAFKASTORE_TOPIC`: Schema storage topic
- `SCHEMA_REGISTRY_KAFKASTORE_TOPIC_REPLICATION_FACTOR`: Replication
- `SCHEMA_REGISTRY_KAFKASTORE_TIMEOUT_MS`: Connection timeout

### Performance Settings
- `SCHEMA_REGISTRY_HEAP_OPTS`: JVM memory settings
- `SCHEMA_REGISTRY_JVM_PERFORMANCE_OPTS`: GC settings
- `SCHEMA_REGISTRY_SCHEMA_CACHE_SIZE`: Cache configuration

### Schema Evolution
- `SCHEMA_REGISTRY_SCHEMA_COMPATIBILITY_LEVEL`: Global compatibility
- `SCHEMA_REGISTRY_SCHEMA_PROVIDERS`: Format providers

## Schema Evolution

### Compatibility Levels

| Level | Description | Use Case |
|-------|-------------|----------|
| **BACKWARD** | New schema can read old data | Default for CDC |
| **FORWARD** | Old schema can read new data | Producer evolution |
| **FULL** | Both backward and forward | Strict compatibility |
| **NONE** | No compatibility checks | Development only |

### Best Practices
- ✅ Start with `BACKWARD` compatibility
- ✅ Add optional fields only
- ✅ Don't remove required fields
- ✅ Use default values for new fields
- ✅ Test compatibility before deployment

## CDC Integration

### Debezium Schema Registration
CDC pipeline otomatik olarak schema'ları kaydeder:

```bash
# CDC schema'larını kontrol et
curl http://localhost:8081/subjects | grep -E "(users|orders)"

# User schema detayları
curl http://localhost:8081/subjects/users-value/versions/latest
```

### Schema Evolution in CDC
- **Add Columns**: Backward compatible
- **Remove Columns**: Breaking change
- **Change Types**: Usually breaking
- **Rename Columns**: Breaking change

## Monitoring

### Log İzleme
```bash
# Schema Registry main log
docker exec schema-registry tail -f /var/log/schema-registry/schema-registry.log

# API request logs
docker exec schema-registry tail -f /var/log/schema-registry/requests.log

# Kafka store logs
docker exec schema-registry tail -f /var/log/schema-registry/kafka-store.log

# Performance logs
docker exec schema-registry tail -f /var/log/schema-registry/performance.log
```

### Health Checks
```bash
# Schema Registry health
curl http://localhost:8081/subjects

# Kafka connectivity
docker exec schema-registry kafka-broker-api-versions --bootstrap-server kafka:29092

# Schema count
curl -s http://localhost:8081/subjects | jq length
```

## Troubleshooting

### Common Issues

1. **Schema Registry Not Starting**
   ```bash
   # Check Kafka connectivity
   docker logs schema-registry
   
   # Verify Kafka is running
   docker exec kafka kafka-topics --list --bootstrap-server localhost:9092
   ```

2. **Schema Registration Failed**
   ```bash
   # Check compatibility
   curl http://localhost:8081/compatibility/subjects/users-value/versions/latest \
     -H "Content-Type: application/vnd.schemaregistry.v1+json" \
     --data '{"schema": "{...}"}'
   ```

3. **Performance Issues**
   ```bash
   # Check cache statistics
   curl http://localhost:8081/metrics
   
   # Review heap usage
   docker exec schema-registry jps -v
   ```

### Debug Mode
Environment variable'larda debug modunu aktif etmek için:
```bash
SCHEMA_REGISTRY_DEBUG=true
SCHEMA_REGISTRY_LOG4J_ROOT_LOGLEVEL=DEBUG
```

## API Examples

### Complete Workflow
```bash
# 1. Schema Registry durumunu kontrol et
curl http://localhost:8081/subjects

# 2. User schema'sını kaydet
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{
    "schema": "{\"type\": \"record\", \"name\": \"User\", \"namespace\": \"datawarehouse\", \"fields\": [
      {\"name\": \"id\", \"type\": \"int\"},
      {\"name\": \"username\", \"type\": \"string\"},
      {\"name\": \"email\", \"type\": \"string\"},
      {\"name\": \"created_at\", \"type\": \"string\"}
    ]}"
  }' \
  http://localhost:8081/subjects/users-value/versions

# 3. Schema'yı doğrula
curl http://localhost:8081/subjects/users-value/versions/latest

# 4. Compatibility test et
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{
    "schema": "{\"type\": \"record\", \"name\": \"User\", \"namespace\": \"datawarehouse\", \"fields\": [
      {\"name\": \"id\", \"type\": \"int\"},
      {\"name\": \"username\", \"type\": \"string\"},
      {\"name\": \"email\", \"type\": \"string\"},
      {\"name\": \"created_at\", \"type\": \"string\"},
      {\"name\": \"updated_at\", \"type\": [\"null\", \"string\"], \"default\": null}
    ]}"
  }' \
  http://localhost:8081/compatibility/subjects/users-value/versions/latest
```

## Performance Optimization

### JVM Tuning
- **G1GC**: Low-latency garbage collection
- **512MB Heap**: Sufficient for most workloads
- **String Deduplication**: Memory optimization

### Cache Optimization
- **1000 Schema Cache**: Covers typical usage
- **5 Min Expiry**: Balance between memory and freshness

### Network Optimization
- **CORS Enabled**: Web UI integration
- **Compression**: Gzip for API responses

## Auto-startup Features

Custom startup script provides:
- ✅ Otomatik Kafka dependency beklemesi
- ✅ `_schemas` topic'inin otomatik oluşturulması
- ✅ Global compatibility level ayarlama
- ✅ Configuration validation
- ✅ Graceful shutdown handling

Bu setup ile production-ready, scalable Schema Registry hazır! 