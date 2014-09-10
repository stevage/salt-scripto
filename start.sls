# This settings file is parsed as if it were Salt, so Jinja and YAML rules apply.
{% set dbpassword='banana' %}
{% set dbrootpassword='xm98XVYUr9dSvRCBEE' %}
{% set wwwdir='/var/www' %}

{% set omekainstances=['one','two'] %}

{% set omekadir=wwwdir ~ '/omeka' %}
{% set omekaplugins=['http://omeka.org/wordpress/wp-content/uploads/CSV-Import-2.0.2.zip'] %}

{% set omekathemes=[
'http://omeka.org/wordpress/wp-content/uploads/Astrolabe-1.0-rc.2.zip',
'http://omeka.org/wordpress/wp-content/uploads/Neatscape-1.0-rc.2.zip',
'https://github.com/ebellempire/Deco/archive/master.zip',
] %}
