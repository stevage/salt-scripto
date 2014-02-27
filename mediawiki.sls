{% mwdir='/var/www' %}
mediawiki_install:
  cmd.run:
    - name: |
        f=mediawiki.tar.gz
        
        [ -f /tmp/$f ] || wget -nv http://download.wikimedia.org/mediawiki/1.22/mediawiki-1.22.2.tar.gz -O /tmp/$f
        mkdir -p {{ mwdir }}
        cd {{ mwdir }}
        tar -xzf /tmp/$f
        # Move stuff from subdirectory if required.
        [ "`ls *.php`"] || mv `ls`/* .
        
    #- unless: test -d /var/www/mw