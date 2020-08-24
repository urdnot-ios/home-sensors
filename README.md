# Sensor Data Collection Project


In 2014 I started getting interested in Raspberry Pi's and Arduino's because the idea of small 
computers that could run at such low power and provide so much sensor information was just so appealing!
Around the same time I started working professionally in Scala and then Kafka and then the Akka framework. It seemed like
a natural fit to combine my hobby and my job. 

This is the result. Most of the code is from 2017 when I had some extra time on my hands, and it all needs to be updated.

I thought I'd share the implementation while I work on the upgrades.

The basic flow is 

`sensor --> Kafka Cluster --> Docker-based Scala/Akka service --> InfluxDB --> Grafana`

I've been working in HDFS/Hadoop since 2012 and had already built a small, 4-node, Raspberry Pi
HDFS cluster, so I got 2 more and expanded to include YARN, Spark, Kafka, and Zookeeper. When the Pi4's came out 
I couldn't resist and got 2 more to host Kerberos, LDAP, and an internal DNS server.
I use Ansible to maintain the mini-cluster and have since expanded it to some stripped down Intel 
boxes to give a little more power to the cluster.

Currently I have a simple Docker running on one of the Intel servers that hosts the different Scala/Akka
services. I've now added Kubernetes and am slowly migrating my docker code to that instead. 

Today (2020) my cluster consists of:
1. Raspberry Pi 01 (USB Attached Drive): NameNode, DataNode, Zookeeper
2. Raspberry Pi 02 (USB Attached Drive): Zookeeper, DataNode, ResourceManager
3. Raspberry Pi 03 (USB Attached Drive): Zookeeper, DataNode, NodeManager
4. Raspberry Pi 04 (USB Attached Drive): DataNode, Kafka Broker, NodeManager
5. Raspberry Pi 05 (USB Attached Drive): DataNode, Kafka Broker, NodeManager 
6. Raspberry Pi 06: DNS server, Kafka Broker, NodeManager
7. Raspberry Pi 07: Kerberos primary, LDAP secondary
8. Raspberry Pi 08: LDAP server, kerberos secondary
9. Intel Server 01 (USB Attached Drive): k8s, InfluxDB
10. Intel Server 02 (USB Attached Drive): k8s master, Grafana
11. Intel Server 03 (USB Attached Drive): Docker, k8s 
12. Intel Server 04 (USB Attached Drive): k8s

Works In Progress:
1. Expanding K8S to the RPi's and including Spark
2. Switching from InfluxDB to Scylla
3. Upgrading all the code

The new flow is expected to be:

`sensor --> Kafka --> K8s services --> Scylla --> Grafana`

I've liked InfluxDB but lately I've grown a bit weary of them while I've seen some presentations
about Scylla and did a prototype and am very much impressed. I haven't been able to persuade the powers-that-be
to switch to it but I'm the power-that-is for this cluster!

Some weather sensors need to find out the current sea-level pressure so that they can give accurate
barometer readings. I added a local proxy for that as well as other weather-related API calls so that
I don't have to have each sensor know how to talk to OpenWeatherMap. 

Links to my code are below. They are very much "as is" and "use at your own risk." I've tried to 
make them modular and independent, however they are hobby code and built for my network.

#### Kafka Message Handlers

The various Kafka message consumer/formatters are here:

[Anemometer](https://github.com/urdnot-ios/iotKafkaWindDirection) 

#### API Service
The OpenWeatherMap API service as well as a central place to query door status. There is also an MQTT pass-through to Kafka for my 
Arduino-style sensors.

#### Ansible Scripts
mostly used when I have a new pi or need to reformat an existing one.