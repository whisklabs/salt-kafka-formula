{%- from 'kafka/settings.sls' import kafka with context %}

kafka:
  group.present:
    - name: kafka
  user.present:
    - gid_from_name: True
    - groups:
      - kafka

kafka-directories:
  file.directory:
    - user: kafka
    - group: kafka
    - mode: 755
    - makedirs: True
    - names:
      - {{ kafka.data_dir }}

install-kafka-dist:
  cmd.run:
    - name: curl -L '{{ kafka.source_url }}' | tar xz
    - cwd: /usr/lib
    - unless: test -d {{ kafka.real_home }}/config
  alternatives.install:
    - name: kafka-home-link
    - link: {{ kafka.prefix }}
    - path: {{ kafka.real_home }}
    - priority: 30
    - require:
      - cmd: install-kafka-dist

# fix permissions
{{ kafka.real_home }}:
  file.directory:
    - user: kafka
    - group: root
    - recurse:
      - user
      - group