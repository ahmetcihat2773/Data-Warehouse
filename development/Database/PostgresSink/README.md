# PostgreSQL Sink Database

Bu klasör, Data Warehouse projesi için PostgreSQL sink database'inin build edilmesini sağlar.

## Dosya Yapısı

```
Database/PostgresSink/
├── Dockerfile                     # PostgreSQL sink container build dosyası
├── env.list                       # Environment variables
├── postgresql.conf                # Sink için optimize edilmiş configuration
├── init/                          # Initialization scripts
│   └── 01-create-sink-tables.sql  # Target table creation ve indexing
└── README.md                     # Bu dosya
```

## Özellikler

- **Write-Optimized**: Bulk insert'ler için optimize edilmiş konfigürasyon
- **Target Tables**: Source ile eşleşen tablo yapıları
- **Performance Indexes**: Hızlı sorgular için indexler
- **CDC Metadata**: Veri lineage takibi için metadata tablosu
- **Monitoring Ready**: Log ve performans izleme yapılandırması

## Sink Database Optimizasyonları

### Performance Settings
- `synchronous_commit = off`: Bulk insert performansı
- `commit_delay = 1000`: Batch commit'ler
- `autovacuum_naptime = 1min`: Sık vacuum işlemi

### Indexing Strategy
- Primary key'ler otomatik
- Foreign key'ler için indexler
- Sık sorgulanan alanlar için composite indexler

## Kullanım

Docker Compose ile build etmek için:

```bash
# Sadece PostgreSQL sink'i build et
docker-compose build postgres-sink

# Tüm servisleri çalıştır
docker-compose up --build

# Sadece sink'i çalıştır
docker-compose up postgres-sink
```

## Database Bağlantısı

```bash
# Container içinden bağlantı
docker exec -it postgres-sink psql -U sink_user -d sink_db

# Host'tan bağlantı
psql -h localhost -p 5433 -U sink_user -d sink_db
```

## Environment Variables

Ana konfigürasyon `env.list` dosyasında:

- `POSTGRES_DB`: Sink database adı
- `POSTGRES_USER`: Kullanıcı adı  
- `POSTGRES_PASSWORD`: Şifre
- `POSTGRES_WAL_LEVEL`: Replica (minimal)

## Target Tables

Kafka Connect'ten gelen veriler için hazır tablolar:
- `users`: Kullanıcı bilgileri (source'tan sync)
- `orders`: Sipariş bilgileri (source'tan sync)
- `cdc_metadata`: Veri lineage ve CDC metadata

## Monitoring

CDC işlemlerini takip etmek için:

```sql
-- CDC metadata kontrolü
SELECT * FROM cdc_metadata ORDER BY sink_timestamp DESC LIMIT 10;

-- Tablo boyutları
SELECT 
    schemaname,
    tablename,
    attname,
    n_distinct,
    correlation
FROM pg_stats 
WHERE tablename IN ('users', 'orders');
```

## Veri Doğrulama

Source ve sink arasında veri tutarlılığı kontrolü:

```sql
-- Kayıt sayısı karşılaştırması
SELECT 'users' as table_name, COUNT(*) as record_count FROM users
UNION ALL
SELECT 'orders' as table_name, COUNT(*) as record_count FROM orders;
``` 