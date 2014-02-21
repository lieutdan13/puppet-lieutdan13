puppet-lieutdan13
=================

A Puppet module to store custom classes, templates, and files to share between Puppet Master configurations


## Wordpress Multisite Installation
The installation of Wordpress onto a server using Puppet needs to be done in multiple steps, if tall of he following criteria are met:
* You want to enable the Multisite/Network feature
* This is the first site to be installed on the server

### Steps
1. Allow Multisite to be configured by running the class with multisite =  'allow'. For example:

    ```Puppet
    class { 'lieutdan13::wordpress':
        db_password => 'random_password',
        db_user     => 'wordpress',
        multisite   => 'allow',
        version     => 'latest',
    }
    ```
    
1. Run puppet on the machine
1. Initialize the first/primary blog for the Wordpress network by visiting the blog's url
   * This assumes that the DNS and firewall are configured properly and you have access to the url in a browser
1. Login to the blog's admin panel with the user created
1. Go to Tools --> Network Setup and initialize the Network
1. Select "Sub-domains" and click "Install"
1. Set Multisite to be migrated by running the class with multisite =  'migrate'.
   * If you also want to enable the multi-database feature, set multidb = true.
   * For example:

    ```Puppet
    class { 'lieutdan13::wordpress':
        db_password => 'random_password',
        db_user     => 'wordpress',
        multidb     => true/false,
        multisite   => 'migrate',
        options     => {
            'main_site' => 'blogs.example.com',
        },
        version     => 'latest',
    }
    ```

1. Run puppet on the machine again
1. Login again to the admin panel
1. Go to My Sites --> Network Admin --> Dashboard 
1. Go to Settings --> Network Settings and configure the blog accordingly
1. Go to Settings --> Domain Mapping and configure accordingly
1. If you chose to enable the multidb feature:
    1. Go to Plugins and activate SharDB site admin utilities network-wide
    1. Go to Settings --> SharDB Migration and perform the migration of the sites
1. Enable Multisite completely by running the class with multisite =  true. For example:

    ```Puppet
    class { 'lieutdan13::wordpress':
        db_password => 'random_password',
        db_user     => 'wordpress',
        multidb     => true/false,
        multisite   => true,
        options     => {
            'main_site' => 'blogs.example.com',
        },
        version     => 'latest',
    }
    ```
