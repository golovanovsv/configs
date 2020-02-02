# rabbit

Ports:
 5672  amqp
 5671  amqp (TLS)
 25672 CLI/inter-node
 15672 http api/management (rabbitmq-plugins enable rabbitmq_management)
 1883  MQTT (rabbitmq-plugins enable rabbitmq_mqtt)
 8883  MQTT/TLS
 61613 STOMP (rabbitmq-plugins enable rabbitmq_stomp)
 61614 STOMP/TLS 
 15674 STOMP-WS (rabbitmq-plugins enable rabbitmq_web_stomp)
 15675 MQTT-WS (rabbitmq-plugins enable rabbitmq_web_mqtt)
 15692 Prometheus (rabbitmq-plugins enable rabbitmq_prometheus)

# [Clustering](https://www.rabbitmq.com/clustering.html):

 rabbitmqctl stop_app
 rabbitmqctl reset
 rabbitmqctl join_cluster rabbit@rabbit0
 rabbitmqctl start_app
