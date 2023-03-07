users:
  root:
    name: root
    password: '""'
    shell: /bin/bash

  soundfleet:
    name: soundfleet
    password: {{ pillar.user_password }}
    shell: /bin/bash
    groups:
      - soundfleet
      - sudo
