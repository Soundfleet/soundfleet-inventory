# install required packages
install_packages:
  pkg.installed:
    - names:
    {% for pkg in pillar.pkg_names %}
      - {{ pkg }}
    {% endfor %}


# setup virtualenv
setup_virtualenv:
  virtualenv.managed:
    - name: {{ pillar.virtualenv }}
    - python: python3
    - require:
      - pkg: install_packages


# install player directly from git
install_player:
  pip.installed:
    - bin_env: {{ pillar.virtualenv }}/bin/pip
    - editable: {{ pillar.repository_url }}#egg=soundfleet
    - exists_action: w
    - require:
      - pkg: install_packages


# create dir for media files
create_media_dir:
  file.directory:
    - name: {{ pillar.media_dir }}
    - mode: 755
    - makedirs: True
