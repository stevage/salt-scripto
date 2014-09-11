# This settings file is parsed as if it were Salt, so Jinja and YAML rules apply.
{% set dbpassword='banana' %}
{% set dbrootpassword='xm98XVYUr9dSvRCBEE' %}
{% set wwwdir='/var/www' %}
{% set omekadir=wwwdir ~ '/omeka' %}
{% set omekaplugins=['http://omeka.org/wordpress/wp-content/uploads/CSV-Import-2.0.2.zip',
'http://omeka.org/wordpress/wp-content/uploads/Search-By-Metadata-1.1.zip',
'http://omeka.org/wordpress/wp-content/uploads/Neatline-2.3.0.zip',
'http://omeka.org/wordpress/wp-content/uploads/Neatline-Time-2.0.3.zip',
'http://omeka.org/wordpress/wp-content/uploads/NeatlineFeatures-2.0.5.zip',
'http://omeka.org/wordpress/wp-content/uploads/Commenting-2.1.1.zip',
'http://omeka.org/wordpress/wp-content/uploads/Simple-Vocab-2.0.1.zip',
'sudo wget http://omeka.org/wordpress/wp-content/uploads/Dropbox-0.7.2.zip'
] %}

{% set omekathemes=[
'http://omeka.org/wordpress/wp-content/uploads/Astrolabe-1.0-rc.2.zip',
'http://omeka.org/wordpress/wp-content/uploads/Neatscape-1.0-rc.2.zip',
'https://github.com/ebellempire/Deco/archive/master.zip',
'http://omeka.org/wordpress/wp-content/uploads/Emiglio-2.0.2.zip',
'http://omeka.org/wordpress/wp-content/uploads/Rhythm-2.0.zip',
'http://omeka.org/wordpress/wp-content/uploads/Minimalist-2.0.zip'
] %}
