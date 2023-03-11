# setup users
delete default RPI user:
  user.absent:
    - name: pi


delete default RPI group:
  group.absent:
    - name: pi


create soundfleet user:
  group.present:
    - system: True
  user.present:
    - name: soundfleet
    - password: '{{ pillar.user_password }}'
    - shell: /bin/bash
    - enforce_password: True


drop root password:
  user.present:
    - name: root
    - password: '""'
    - shell: /bin/bash