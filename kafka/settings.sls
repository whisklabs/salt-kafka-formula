{% set p  = salt['pillar.get']('kafka', {}) %}
{% set pc = p.get('config', {}) %}
{% set g  = salt['grains.get']('kafka', {}) %}
{% set gc = g.get('config', {}) %}

# these are global - hence pillar-only
{%- set zookeeper_connect = pillar.zookeeper_connect %}
{%- set prefix            = p.get('prefix', '/usr/lib/kafka') %}

{%- set version           = g.get('version', p.get('version', '0.8.1.1')) %}
{%- set scala_version     = g.get('scala_version', p.get('scala_version', '2.10')) %}

{%- set version_name = 'kafka_' + scala_version + '-' + version %}
{%- set real_home    = prefix + '_' + scala_version + '-' + version %}
{%- set default_url  = 'http://www.mirrorservice.org/sites/ftp.apache.org/kafka/' + version + '/' + version_name + '.tgz' %}
{%- set source_url   = g.get('source_url', p.get('source_url', default_url)) %}

# bind_address is only supported as a grain, because it has to be host-specific
{%- set bind_address = gc.get('bind_address', '0.0.0.0') %}
{%- set data_dir     = gc.get('data_dir', pc.get('data_dir', '/tmp/data')) %}

{%- set broker_id    = g.get('broker_id', p.broker_id) %}

{%- set kafka = {} %}

{%- do kafka.update({
  'broker_id': broker_id,
  'zookeeper_connect': zookeeper_connect,
  'uid': uid,
  'userhome': userhome,
  'prefix': prefix,
  'java_home': java_home,
  'version': version,
  'version_name': version_name,
  'source_url': source_url,
  'bind_address': bind_address,
  'data_dir': data_dir,
  'real_home': real_home
  }) %}