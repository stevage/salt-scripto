{% import "start.sls" as settings %}
server_stuff:
  pkg:
    - installed
    - pkgs:
      - unzip
      - apache2
      - php5
      - php5-mysql
      - imagemagick
      - mysql-server

unzip:
  cmd.run:
    - name: |
        [ -f /tmp/omeka.zip ] || wget -nv http://omeka.org/files/omeka-2.1.4.zip -O /tmp/omeka.zip
        unzip -oq /tmp/omeka.zip -d /tmp
        mkdir -p {{ settings.omekadir }}
        mv /tmp/omeka-2.1.4/* {{ settings.omekadir }}
        mv /tmp/omeka-2.1.4/.htaccess {{ settings.omekadir }}
        rm {{ settings.omekadir }}/index.html
    - unless: test -d {{ settings.omekadir }}/themes/berlin

webdev:
  group.present

ubuntu:
  user.present:
    - groups: [ webdev ]

webify:
  cmd.run:
    - name: |
        cd /var
        chown -R root.webdev www 

        chmod 775 www
        cd {{ settings.omekadir }} 
        find . -type d | xargs chmod 775
        find . -type f | xargs chmod 664
        find files -type d | xargs chmod 777
        find files -type f | xargs chmod 666

mysql:
  cmd.run:
     - require: [ pkg: server_stuff ]
     - name: |
        mysql <<EOF
        create database omeka;
        grant all privileges on omeka.* to 'ubuntu'@'localhost'     identified by '{{ settings.dbpassword }}';
        flush privileges;
        EOF
        mysqladmin -u root password {{ settings.dbrootpassword }}

{{ settings.omekadir }}/db.ini:
  file.managed:
    - source: salt://files/omeka_db.ini
    - template: jinja
    - defaults:
        dbpassword: "{{ settings.dbpassword }}"

modrewrite:
  cmd.run:
    - name: "a2enmod rewrite"

# This bit is a bit bodgy:


/etc/apache2/apache2.conf:
  file.managed:
    - source: salt://files/apache2.conf
    
/etc/apache2/sites-available/default:
  file.managed:
    - source: salt://files/default

get_plugins:
  cmd.run: 
    - name: |
        cd {{ settings.omekadir }}/plugins
        {% for plugin in settings.omekaplugins|default([]) %}
        wget -nc {{ plugin }}
        {% endfor %}
        unzip -n *.zip
    

apache2:
  service:
    - running
    - reload: True

reload_apache:
  cmd.run:
    - name: "service apache2 reload"
