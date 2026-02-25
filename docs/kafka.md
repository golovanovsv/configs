Одно сообщение записывается в одну партицию.
Сообщения с одинаковыми ключами всегда записывается в одну партицию. Если ключа нету, то RR.
Каждая партиция реплицируется N-раз (replicas) на разных брокерах.
У каждой партиции есть leader, которым является один из брокеров, где есть партиция.
Бэкапные брокеры партиций (follower) осуществляют запросы к leader`у, чтобы получать новые данные.
Толлько лидер осуществляет запись в партицию и в общем случае обеспечивает чтение.

Партиция - последовательность сообщений (Log)
retention.ms - минимальное время хранения сообщения
retention.bytes - максимальный размер партиции
Добавлять партиции можно на лету. Удалять партиции нельзя, только весь топик.
Физически партиции представляют собой файлы-сегменты на диске. Сегменты бывают открытые (сегмент, куда идет запись) и закрытые. Механизм удаления старых данных в партициях удаляет посегментно. Т.е. самая новая запись сегмента должна быть старше, чем retention.ms

Consumer является частью consumer group. Группа имеет уникальное название. consumer`ы получают сообщения из разных топиков.
Партиции между consumer распределяются автоматически в зависимости от кол-ва consumer. Если число consumer больше числа топиков, то лишние consumer не будут работать вообще.

Так как каждая партиция обрабатывается одним уникальным консьюмером, то только он может сдвинуть указатель чтения после успешной обработки сообщения!

# unset KAFKA_OPTS
# unset JMX_PORT
kafka-topics.sh --bootstrap-server <kafka>:<port> \
  --create \
  --topic <name> \
  --partitions 1 \
  --replication-factor 1 \
  --config retention.ms=60000

kafka-topics.sh --bootstrap-server <kafka>:<port> \
  --alter \
  --topic <name> \
  --partitions 40 \
  --replication-factor 2

kafka-topics.sh --bootstrap-server <kafka>:<port> \
  --delete \
  --topic <name>

kafka-topics.sh --bootstrap-server <kafka>:<port> --list

kafka-topics.sh --describe --topic <name> --bootstrap-server <kafka>:<port>

kafka-console-producer.sh --topic <name> --bootstrap-server <kafka>:<port>
kafka-console-consumer.sh --topic <name> --bootstrap-server <kafka>:<port> \
  [--consumer-property auto.offset.reset=earliest] [--from-beginning] \
  [--group <group-name>]

# auto.offset.reset=earliest - работает только для новой группы
kafka-consumer-groups.sh --bootstrap-server <kafka>:<port> --group <group-name> --describe
kafka-consumer-groups.sh --bootstrap-server <kafka>:<port> --group <group-name> --reset-offsets --to-earliest --topic <name> --execute

## retentions
log.retentions.check.interval.ms=300000 # Периоды проверки партиций

kafka-configs.sh --bootstrap-server <kafka>:<port> --entity-type topics --entity-name <name> --alter --add-config retention.ms=60000
kafka-configs.sh --bootstrap-server <kafka>:<port> --entity-type topics --entity-name <name> --alter --add-config segment.ms=10000
kafka-configs.sh --bootstrap-server <kafka>:<port> --entity-type topics --entity-name <name> --alter --delete-config segment.ms=10000

retention.ms - минимальное время хранения данных
retention.bytes - максимальный размер партиции на диске
segment.ms - период ротации сегмента (1 week)
segment.bytes - максимальный размер сегмента (1Гб)

Ротация сегмента наступает по правилу segment.ms ИЛИ segment.bytes

## log compation
Процедура сжатия лога весьма затратна для брокера. И не атомарна.
cleanup.policy=<delete|compact>
cleanup.policy=compact,delete # так тоже можно, работают одновременно

Политика compact вносит изменения только в закрытые сегменты

## kafka metadata
kafka-broker-api-versions.sh \
  --bootstrap-server 127.0.0.1:9092 \
  --command-config client.properties

## zookeeper
zookeeper-shell.sh <server>:<port>
ls /brokers/ids     # Список подключенных брокеров
stat /brokers/ids/0 # Статистика ключа в zk

./bin/zkCli.sh ls /brokers/(ids | topics)
./bin/zkCli.sh get /brokers/ids/<id>

## Что стоит мониторить
Сеть, диски, баланс нагрузки партиций топиков по брокерам.
Отставание партиций от лидеров.
Переизбрания лидеров.
Время ответа брокера на фетчи.

# Get topic config
kafka-configs --bootstrap-server <KAFKA_SERVERS> --entity-type topics --entity-name <TOPIC_NAME> --describe --all

# Auth
# https://kafka.apache.org/documentation/#security_sasl_mechanism
# https://strimzi.io/docs/operators/latest/deploying#con-securing-kafka-authentication-str
sasl.mechanism:
  - GSSAPI
  - PLAIN
  - SCRAM-SHA-[256/512]
  - OAUTHBEARER

# https://kafka.apache.org/documentation/#producerconfigs_security.protocol
security.protocol:
  - SASL_SSL
  - SASL_PLAINTEXT
  - PLAINTEXT
  - SSL
