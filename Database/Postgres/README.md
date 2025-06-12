# PostgreSQL Source Database

Bu klasör, Data Warehouse projesi için PostgreSQL source database'inin build edilmesini sağlar.

## Dosya Yapısı

```
Database/Postgres/
├── Dockerfile              # PostgreSQL container build dosyası
├── env.list                # Environment variables
├── postgresql.conf         # PostgreSQL configuration
├── init/                   # Initialization scripts
│   └── 01-create-tables.sql # Sample table creation
└── README.md              # Bu dosya
```

## Özellikler

- **Logical Replication**: Debezium CDC için gerekli WAL konfigürasyonu
- **Sample Data**: Test için hazır tablolar ve veriler (users, orders)
- **Performance Tuning**: CDC için optimize edilmiş konfigürasyon
- **Environment Variables**: Merkezi konfigürasyon yönetimi

## Kullanım

Docker Compose ile build etmek için:

```bash
# Sadece PostgreSQL source'u build et
docker-compose build postgres-source

# Tüm servisleri çalıştır
docker-compose up --build

# Sadece PostgreSQL'i çalıştır
docker-compose up postgres-source
```

## Database Bağlantısı

```bash
# Container içinden bağlantı
docker exec -it postgres-source psql -U source_user -d source_db

# Host'tan bağlantı
psql -h localhost -p 5432 -U source_user -d source_db
```

## Environment Variables

Ana konfigürasyon `env.list` dosyasında:

- `POSTGRES_DB`: Database adı
- `POSTGRES_USER`: Kullanıcı adı  
- `POSTGRES_PASSWORD`: Şifre
- `POSTGRES_WAL_LEVEL`: Logical replication için
- `POSTGRES_MAX_WAL_SENDERS`: CDC için gerekli

## CDC Hazırlık

Bu konfigürasyon Debezium CDC connector'ı için hazır:

- WAL level: logical
- Replication slots: 3
- WAL senders: 3
- Gerekli izinler otomatik olarak verilir

## Test Tabloları

Hazır olarak gelen tablolar:
- `users`: Kullanıcı bilgileri
- `orders`: Sipariş bilgileri

Bu tablolar CDC test'leri için kullanılabilir. 