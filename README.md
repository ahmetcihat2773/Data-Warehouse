Main Purpose :

Source database den sink database a, kafka connectorler araciligiyla veri aktarimi.

Source ve sink databaselerimiz burada postgres databaseler. 

Spin up the product with docker compose file.


curl -X POST -H "Content-Type: application/json" --data-binary @config/source-connector.json http://localhost:8083/connectors

curl http://localhost:8083/connectors

curl http://localhost:8083/connectors/postgres-source-connector/status

docker exec kafka kafka-topics --bootstrap-server localhost:9092 --list



curl -X POST -H "Content-Type: application/json" --data-binary @config/sink-connector.json http://localhost:8083/connectors



curl -X DELETE http://localhost:8083/connectors/postgres-source-connector
curl -X DELETE http://localhost:8083/connectors/postgres-sink-connector


curl -X POST -H "Content-Type: application/json" --data-binary @config/source-connector.json http://localhost:8083/connectors

curl -X POST -H "Content-Type: application/json" --data-binary @config/sink-connector.json http://localhost:8083/connectors