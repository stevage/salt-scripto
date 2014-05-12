getscripto:
  cmd.run:
    - name: 
        wget -nv http://omeka.org/wordpress/wp-content/uploads/Scripto-2.0.zip -O /tmp/Scripto-2.0.zip
        unzip -qo /tmp/Scripto-2.0.zip -d /var/www/omeka/plugins
    - unless: test -f /tmp/Scripto-2.0.zip
