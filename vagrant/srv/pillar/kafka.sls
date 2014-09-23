java_home: /usr/lib/jvm/java-7-openjdk-amd64

kafka:
  config:
    zookeeper_connect: localhost:2181
    broker_id: 0
    host_name: 'salt-master'

zookeeper:
  config:
    snap_count: 10000
    snap_retain_count: 3
    purge_interval: 2
    max_client_cnxns: 40