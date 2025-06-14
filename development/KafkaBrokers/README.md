# Kafka Broker - Custom Build

Bu klasör, Data Warehouse projesi için Kafka Broker'ın custom build edilmesini sağlar.

## Dosya Yapısı

```
KafkaBrokers/
├── Dockerfile                    # Custom Kafka build
├── env.list                      # Environment variables
├── config/
│   ├── server.properties         # Kafka server configuration
│   └── log4j.properties         # Logging configuration
├── scripts/
│   └── kafka-startup.sh         # Custom startup script
└── README.md                    # Bu dosya
```

## Özellikler

- **KRaft Mode**: Zookeeper'a ihtiyaç durmayan modern Kafka
- **Custom Configuration**: Data Warehouse projesi için optimize edilmiş
- **Enhanced Logging**: Ayrıntılı log sistemi
- **Performance Tuned**: CDC workload için optimize
- **Monitoring Ready**: JMX metrikleri aktif

## Kafka Konfigürasyonu

### KRaft Mode Settings
- **Node ID**: 1 (single broker)
- **Process Roles**: broker,controller
- **Cluster ID**: MkU3OEVBNTcwNTJENDM2Qk
- **No Zookeeper**: Tamamen self-contained

### Listener Configuration
- **Internal**: `kafka:29092` (container network)
- **External**: `localhost:9092` (host access)
- **Controller**: `kafka:29093` (KRaft controller)

### Storage & Performance
- **Log Directory**: `/var/lib/kafka/data`
- **Default Partitions**: 3
- **Retention**: 7 days (168 hours)
- **Segment Size**: 1GB
- **Memory**: 1GB heap size

## Kullanım

Docker Compose ile build etmek için:

```bash
# Sadece Kafka'yı build et
docker-compose build kafka

# Tüm servisleri çalıştır
docker-compose up --build

# Sadece Kafka'yı çalıştır
docker-compose up kafka
```

## Kafka Yönetimi

### Topic İşlemleri
```bash
# Container içinde topic oluştur
docker exec kafka kafka-topics --create --topic test-topic --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

# Topic listele
docker exec kafka kafka-topics --list --bootstrap-server localhost:9092

# Topic detayları
docker exec kafka kafka-topics --describe --topic test-topic --bootstrap-server localhost:9092
```

### Message İşlemleri
```bash
# Producer başlat
docker exec -it kafka kafka-console-producer --topic test-topic --bootstrap-server localhost:9092

# Consumer başlat
docker exec -it kafka kafka-console-consumer --topic test-topic --bootstrap-server localhost:9092 --from-beginning
```

## Environment Variables

Ana konfigürasyon `env.list` dosyasında:

### Core Settings
- `KAFKA_NODE_ID`: Broker ID (1)
- `KAFKA_PROCESS_ROLES`: broker,controller
- `CLUSTER_ID`: KRaft cluster identifier

### Network Configuration
- `KAFKA_ADVERTISED_LISTENERS`: Client bağlantı adresleri
- `KAFKA_LISTENERS`: Server listener adresleri
- `KAFKA_CONTROLLER_QUORUM_VOTERS`: KRaft controller'lar

### Performance Settings
- `KAFKA_HEAP_OPTS`: JVM memory ayarları
- `KAFKA_NUM_NETWORK_THREADS`: Network thread sayısı
- `KAFKA_NUM_IO_THREADS`: IO thread sayısı

## Monitoring

### JMX Metrics
Kafka JMX metrikleri `localhost:9101` portunda:

```bash
# JConsole ile bağlan
jconsole localhost:9101

# curl ile test
curl http://localhost:9101/mbean?objectname=kafka.server:type=BrokerTopicMetrics,name=MessagesInPerSec
```

### Log İzleme
```bash
# Ana server log
docker exec kafka tail -f /var/lib/kafka/logs/server.log

# Controller log
docker exec kafka tail -f /var/lib/kafka/logs/controller.log

# State change log
docker exec kafka tail -f /var/lib/kafka/logs/state-change.log
```

## CDC için Optimizasyonlar

### Topic Configuration
- **Partitions**: 3 (paralel processing)
- **Replication Factor**: 1 (single broker)
- **Auto Create**: Enabled (Connect için)

### Performance Settings
- **Message Size**: 1MB max
- **Compression**: Producer'a bırakılmış
- **Batch Size**: Optimize edilmiş
- **Network Threads**: 8

## Troubleshooting

### Common Issues

1. **Storage Format Error**
   ```bash
   # Storage'ı temizle ve yeniden format et
   docker-compose down -v
   docker-compose up kafka
   ```

2. **Port Conflicts**
   ```bash
   # Portları kontrol et
   netstat -tulpn | grep :9092
   ```

3. **Permission Issues**
   ```bash
   # Container loglarını kontrol et
   docker logs kafka
   ```

### Health Check
```bash
# Broker health
docker exec kafka kafka-broker-api-versions --bootstrap-server localhost:9092

# Topic operations test
docker exec kafka kafka-topics --list --bootstrap-server localhost:9092
```

## Custom Startup Script

`scripts/kafka-startup.sh` dosyası:
- Directory permission'ları ayarlar
- Storage format kontrolü yapar
- KRaft initialization yapar
- Kafka server'ı başlatır

## Configuration Files

### server.properties
- KRaft mode configuration
- Listener settings
- Performance tuning
- CDC optimizations

### log4j.properties
- Structured logging
- Separate log files
- Performance monitoring
- Debug capabilities

Bu setup ile production-ready, CDC için optimize edilmiş Kafka broker hazır! 