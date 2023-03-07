# setup users
{% for _, kwargs in pillar.users.items() %}
{{ kwargs.name }}:
  group.present:
    - system: True
  user.present:
    - password: {{ kwargs.password }}
    - shell: {{ kwargs.shell }}
    - enforce_password: True
  {% if 'groups' in kwargs %}
    - groups:
      {% for group in kwargs.groups %}
      - {{ group }}
      {% endfor %}
  {% endif %}
{% endfor %}


delete default RPI user:
  user.absent:
    - name: pi

delete default RPI group:
  group.absent:
    - name: pi
