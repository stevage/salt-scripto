{% set dbpassword='banana' %}
{% set omekadir='{{ omekadir }}/omeka' %}
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
        mkdir -p {{ omekadir }}
        mv /tmp/omeka-2.1.4/* {{ omekadir }}
        mv /tmp/omeka-2.1.4/.htaccess {{ omekadir }}
        rm {{ omekadir }}/index.html
    - unless: test -d {{ omekadir }}/themes/berlin

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
        cd {{ omekadir }} 
        find . -type d | xargs chmod 775
        find . -type f | xargs chmod 664
        find files -type d | xargs chmod 777
        find files -type f | xargs chmod 666

mysql:
  # todo change root password
  cmd.run:
     - require: [ pkg: server_stuff ]
     - name: |
        mysql <<EOF
        create database omeka;
        grant all privileges on omeka.* to 'ubuntu'@'localhost'     identified by '{{ dbpassword }}';
        flush privileges;
        EOF

{{ omekadir }}/db.ini:
  file.managed:
    - source: salt://omeka_db.ini
    - template: jinja
    - defaults:
        dbpassword: "{{ dbpassword }}"

modrewrite:
  cmd.run:
    - name: "a2enmod rewrite"

# This bit is a bit bodgy:


/etc/apache2/apache2.conf:
  file.managed:
    - source: salt://apache2.conf
    
/etc/apache2/sites-available/default:
  file.managed:
    - source: salt://default

apache2:
  service.running