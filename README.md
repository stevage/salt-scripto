Salt formula for Scripto
========================

This is a fairly rough SaltStack formula that installs MediaWiki, Omeka and [Scripto](http://scripto.org). Unfortunately all three of those components
require some web-based manual configuration so this formula can only do about half the job.

I had some issues getting MediaWiki and Omeka to coexist, probably due to unfamiliarity with Apache. In the end, I put MediaWiki
directly in /var/www and Omeka in /var/www/omeka, which seems to work.

In its current state it's unlikely to fully work, but may be a useful starting point for someone.

Basic usage:

On a clean Ubuntu VM (only tested with Quantal):

    curl -L http://bootstrap.saltstack.org | sudo sh
    cd /srv
    sudo git clone http://github.com/stevage/salt-scripto salt
    cd salt
    sudo salt-call --local state.highstate

Visit http://localhost to configure MediaWiki - you will end by downloading LocalSettings.php to /var/www

Visit http://localhost/omeka to configure Omeka then Scripto as per the [instructions](http://scripto.org/documentation/omeka-scripto/omeka-scripto-installation-and-configuration/).