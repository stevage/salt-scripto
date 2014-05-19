Salt formula for Omeka
========================

###(and Scripto and MediaWiki, sort of).

This is a SaltStack formula that can install Omeka. It can also try to install MediaWiki and [Scripto](http://scripto.org), but that bit doesn't work very well.


Unfortunately all three of those components
require some web-based manual configuration so this formula can only do about half the job.


### Installing Omeka

On a clean Ubuntu VM (only tested with Quantal):

    sudo apt-get update && sudo apt-get install -y git-core curl
    curl -L http://bootstrap.saltstack.org | sudo sh
    cd /srv
    sudo git clone http://github.com/stevage/salt-scripto salt
    cd salt
    vim start.sls # Edit settings
    sudo salt-call --local state.highstate

Then go to your server at http://localhost/omeka to complete the install.

### Installing Scripto

I had some issues getting MediaWiki and Omeka to coexist, probably due to unfamiliarity with Apache. In the end, I put MediaWiki
directly in /var/www and Omeka in /var/www/omeka, which seems to work.

In its current state it's unlikely to fully work, but may be a useful starting point for someone.


Visit http://localhost to configure MediaWiki - you will end by downloading LocalSettings.php to /var/www

Visit http://localhost/omeka to configure Omeka then Scripto as per the [instructions](http://scripto.org/documentation/omeka-scripto/omeka-scripto-installation-and-configuration/).
