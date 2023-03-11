include:
  - reload
  - install  # required to configure


# add entry in /etc/hosts for redis
setup_hosts_for_redis:
  host.present:
    - ip:
        - 127.0.0.1
    - names:
        - redis

# set env file
player_configuration:
  file.managed:
    - name: /etc/soundfleet.env
    - source: salt://configure/templates/environment.j2
    - template: jinja


# enable redis service for player
enable_redis_service:
  service.enabled:
    - name: redis
    - require:
      - setup_hosts_for_redis


# ensure redis is running
run_redis_service:
  service.running:
    - name: redis
    - enable: True
    - reload: True
    - require:
      - setup_hosts_for_redis
      - enable_redis_service


# configure/run player services
{% for unit in ['player', 'scheduler'] %}
install_{{ unit }}_service:
  file.managed:
    - name: /etc/systemd/system/{{ unit }}.service
    - template: jinja
    - source: salt://configure/templates/unit.service.j2
    - context:
      unit: {{ unit }}
      venv_dir: {{ pillar.virtualenv }}
    - watch_in:
      - cmd: reload_systemd_configuration
    - require:
      - setup_hosts_for_redis


enable_{{ unit }}_service:
  service.enabled:
    - name: {{ unit }}
    - require:
      - enable_redis_service


run_{{ unit }}_service:
  service.running:
    - name: {{ unit }}
    - enable: True
    - restart: True
    - require:
      - run_redis_service
    - watch:
      - install_player
      - player_configuration
{% endfor %}
