{%- from 'kafka/settings.sls' import kafka with context %}

include:
  - kafka

kafka-server-conf:
  file.managed:
    - name: {{ kafka.real_home }}/config/server.properties
    - source: salt://kafka/config/server.properties
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      broker_id: {{ kafka.broker_id }}
      hostname: {{ grains.fqdn }}
      zookeeper_connect: {{ kafka.zookeeper_connect }}
    - require:
      - cmd: install-kafka-dist

/etc/init/kafka.conf:
  file.managed:
    - source: salt://kafka/config/kafka.init.conf
    - mode: 644
    - template: jinja
    - context:
      workdir: {{ kafka.prefix }}
    - require:
      - file: kafka-server-conf

kafka-service:
  service.running:
    - name: kafka
    - enable: true
    - require:
      - file: /etc/init/kafka.conf