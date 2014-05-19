# This settings file is parsed as if it were Salt, so Jinja and YAML rules apply.
{% set dbpassword='banana' %}
{% set dbrootpassword='xm98XVYUr9dSvRCBEE' %}
{% set wwwdir='/var/www' %}
{% set omekadir=wwwdir ~ '/omeka' %}
{% set omekaplugins=['http://omeka.org/wordpress/wp-content/uploads/CSV-Import-2.0.2.zip'] %}
