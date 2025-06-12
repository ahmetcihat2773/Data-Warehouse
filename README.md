Main Purpose :

Source database den sink database a, kafka connectorler araciligiyla veri aktarimi. Ilk basta postgres source dan postgres sinke veri aktarimi 
gerekecek. Sonrasinda desteklenen databaseler zamanla arttirilacak. Hatta dosya dinleme klasör dinleme tarzi seylerde desteklenecek. 

Strimzi, debezium kullanilacak.


Schema Registry eklenmesi (veri şeması yönetimi için)
Dead Letter Queue implementasyonu (hata yönetimi)
Monitoring/Alerting sistemi (Kafka Connect durumu izleme)
Data validation mekanizmaları

Bu repository de test icin kafka broker, kafka connect, ve source ve sink db ler olusturulacak boylelik data kopyalama gerceklestirilmis olacak. 


Faz 1: PostgreSQL → PostgreSQL
Faz 2: Diğer veritabanları (MySQL, MongoDB, etc.)
Faz 3: File/Directory watching (gerçek zamanlı dosya işleme)


Kafka Connectors kullanarak veritabanları arası veri transferi
Event-driven data streaming yaklaşımı