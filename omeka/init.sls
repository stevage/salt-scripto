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
      - libapache2-mod-php5

# May need to do this: echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf && sudo a2enconf fqdn

webdev:
  group.present

ubuntu:
  user.present:
    - groups: [ webdev ]


get:
  cmd.run:
    - name: |
        [ -f /tmp/omeka.zip ] || wget -nv http://omeka.org/files/omeka-2.1.4.zip -O /tmp/omeka.zip
        unzip -oq /tmp/omeka.zip -d /tmp
{% for instance in settings.omekainstances %}
install_{{ instance }}:
  cmd.run:
    - name: |
        mkdir -p {{ settings.omekadir }}/{{instance}}
        cp -r /tmp/omeka-2.1.4/* {{ settings.omekadir }}/{{instance}}
        cp /tmp/omeka-2.1.4/.htaccess {{ settings.omekadir }}/.. # Not sure. {{instance}}
        rm -f {{ settings.omekadir }}/{{instance}}/index.html # In case installing into existing directory.
    - unless: test -d {{ settings.omekadir }}/{{instance}}/themes/berlin

webify_{{ instance }}:
  cmd.run:
    - name: |
        cd /var
        chown -R root.webdev www 

        chmod 775 www
        cd {{ settings.omekadir }}/{{instance}}
        find . -type d | xargs chmod 775
        find . -type f | xargs chmod 664
        find files -type d | xargs chmod 777
        find files -type f | xargs chmod 666
{% endfor %}

mysql_admin_password:
  cmd.run:
    - name: mysqladmin -u root password {{ settings.dbrootpassword }}

{% for instance in settings.omekainstances %}
mysql_{{ instance }}:
  cmd.run:
     - require: [ pkg: server_stuff ]
     - name: |
        mysql --password={{ settings.dbrootpassword}} <<EOF
        create database omeka_{{instance}};
        grant all privileges on omeka_{{instance}}.* to 'ubuntu'@'localhost'     identified by '{{ settings.dbpassword }}';
        flush privileges;
        EOF

{{ settings.omekadir }}/{{instance}}/db.ini:
  file.managed:
    - source: salt://files/omeka_db.ini
    - template: jinja
    - defaults:
        dbpassword: "{{ settings.dbpassword }}"
        instance: "{{ instance }}"
{% endfor %}

modrewrite:
  cmd.run:
    - name: |
        a2enmod rewrite
        a2enmod php5

# This bit is a bit bodgy:

{#
#/etc/apache2/apache2.conf:
#  file.managed:
#    - source: salt://files/apache2.conf
#    
#/etc/apache2/sites-available/default:
#  file.managed:
#    - source: salt://files/default
#}

apache2conf:
  pkg.installed:
    - names: [ augeas-tools, augeas-lenses]
  cmd.run:
    - name: |
        augtool -b <<EOF
        set /files/etc/apache2/apache2.conf/Directory[arg = '/var/www/']/*[. = 'AllowOverride']/arg All
        save
        EOF


{#




#}


{% for instance in settings.omekainstances %}
get_plugins_{{instance}}:
  cmd.run: 
    - name: |
        cd {{ settings.omekadir }}/{{instance}}/plugins
        {% for plugin in settings.omekaplugins|default([]) %}
        wget -nc {{ plugin }}
        {% endfor %}
        unzip -n '*.zip'

get_themes_{{instance}}:
  cmd.run: 
    - name: |
        cd {{ settings.omekadir }}/{{ instance }}/themes
        {% for theme in settings.omekathemes|default([]) %}
        wget -nc {{ theme }}
        {% endfor %}
        unzip -n '*.zip'
{% endfor %}
{#
Trying to get *all* plugins just broke Omeka.
get_plugins:
  cmd.run: 
    - name: |
        cd {{ settings.omekadir }}/plugins
        wget -A zip -r -l 0 -nd http://omeka.org/add-ons/plugins/
        unzip -n '*.zip'
#}        
{# Download all themes, because why the hell not. Easier than getting them later.
get_themes:
  cmd.run:
    - name: |
        cd {{ settings.omekadir }}/themes
        wget -A zip -r -l 0 -nd http://omeka.org/add-ons/themes/
        unzip -n '*.zip'    
#}


apache2:
  service:
    - running
    - reload: True
    - enable: True
    #- require: [ file: /etc/apache2/sites-available/default, file: /etc/apache2/apache2.conf ]

reload_apache:
  cmd.run:
    - name: "service apache2 reload"
