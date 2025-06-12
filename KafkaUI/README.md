# Kafka UI - Custom Build

Bu klasör, Data Warehouse projesi için Kafka UI'ın custom build edilmesini sağlar.

## Dosya Yapısı

```
KafkaUI/
├── Dockerfile                  # Custom Kafka UI build
├── env.list                    # Environment variables
├── config/
│   └── application.yml         # Spring Boot configuration
├── static/
│   └── custom.css             # Custom styling
└── README.md                  # Bu dosya
```

## Özellikler

- **Custom Theming**: Data Warehouse projesi için özelleştirilmiş tema
- **Enhanced Configuration**: Gelişmiş Spring Boot konfigürasyonu
- **Performance Tuning**: Tomcat ve JVM optimizasyonları
- **Monitoring Ready**: Metrics ve health endpoints
- **Dark Theme**: Modern dark mode desteği

## Kafka UI Konfigürasyonu

### Cluster Configuration
- **Local Kafka**: `kafka:29092`
- **Schema Registry**: `http://schema-registry:8081`
- **Kafka Connect**: `http://kafka-connect:8083`

### UI Features
- **Read/Write Mode**: Tam yönetim yetkisi
- **Metrics Display**: Performans metrikleri gösterimi
- **Custom Pagination**: 25 kayıt per page
- **Enhanced Logging**: Debug level logging

## Kullanım

Docker Compose ile build etmek için:

```bash
# Sadece Kafka UI'ı build et
docker-compose build kafka-ui

# Tüm servisleri çalıştır
docker-compose up --build

# Sadece UI'ı çalıştır (dependencies ile birlikte)
docker-compose up kafka kafka-ui
```

## Web Arayüzü

Kafka UI'a erişim:
- **URL**: http://localhost:8080
- **Health Check**: http://localhost:8080/actuator/health
- **Metrics**: http://localhost:8080/actuator/metrics

## Custom Styling

`static/custom.css` dosyasında:
- Data Warehouse branding
- Custom color scheme
- Connector status indicators
- Message content styling
- Consumer lag indicators

## Environment Variables

Ana konfigürasyon `env.list` dosyasında:

### Core Settings
- `SERVER_PORT`: Web server portu (8080)
- `DYNAMIC_CONFIG_ENABLED`: Dinamik konfigürasyon
- `LOGGING_LEVEL_ROOT`: Ana log seviyesi

### Kafka Integration
- `KAFKA_CLUSTERS_0_NAME`: Cluster adı
- `KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS`: Kafka broker'lar
- `KAFKA_CLUSTERS_0_SCHEMAREGISTRY`: Schema Registry URL
- `KAFKA_CLUSTERS_0_KAFKACONNECT_0_ADDRESS`: Connect API

## Monitoring ve Yönetim

### Available Endpoints
- `/actuator/health`: Sağlık durumu
- `/actuator/info`: Uygulama bilgileri  
- `/actuator/metrics`: Performance metrikleri
- `/actuator/prometheus`: Prometheus format metrikleri

### Key Features
- **Topic Management**: Create, delete, configure topics
- **Message Browser**: View, search, produce messages
- **Consumer Groups**: Monitor lag, reset offsets
- **Connect Management**: Monitor connectors, tasks
- **Schema Registry**: View, create schemas

## Customization

### Tema Değişiklikleri
`static/custom.css` dosyasını düzenleyerek:
- Renk paleti değişikliği
- Logo ekleme
- Layout düzenlemeleri

### Konfigürasyon Değişiklikleri
`config/application.yml` dosyasında:
- Security ayarları
- Performance tuning
- Feature flags

## Troubleshooting

### Common Issues
1. **Connection Failed**: Kafka broker erişilebilir değil
2. **Schema Registry Error**: Schema Registry down
3. **Connect API Error**: Kafka Connect unavailable

### Log Kontrolü
```bash
# Container logları
docker logs kafka-ui

# Specific log level
docker exec kafka-ui tail -f /app/logs/application.log
```

Bu setup ile modern, kullanıcı dostu ve projene özel Kafka yönetim arayüzü hazır! 