#!/usr/bin/env bash

# did you change the version number?

sbt clean
sbt assembly
sbt docker:publishLocal
docker image tag iotkafkawinddirection intel-server-03:5000/iotkafkawinddirection/latest
ssh -t appuser@intel-server-03 sudo docker stop wind_direction
ssh -t appuser@intel-server-03 sudo docker rm wind_direction
ssh -t appuser@intel-server-03 sudo docker image rmi intel-server-03:5000/iotkafkawinddirection/latest
docker image push intel-server-03:5000/iotkafkawinddirection/latest
ssh -t appuser@intel-server-03 sudo docker run -m 275m --name=wind_direction --network=host --restart=always -e KAFKA_SERVERS=pi-server-03-eth:9092,pi-server-04-eth:9092,pi-server-05-eth:9092 -e TOPIC_START=latest -e INFLUX_HOST=intel-server-03 -e KAFKA_CONSUMER_GROUP=connectorGroup -d intel-server-03:5000/iotkafkawinddirection/latest
