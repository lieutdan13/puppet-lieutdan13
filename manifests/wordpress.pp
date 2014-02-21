# Class lieutdan13::wordpress
# $multisite                : There are different stages of initializing the multisite feature in Wordpress.
#                             Here are the different values in order of the stages.
#                             false   = Completely disabled. The Wordpress site will not give an option to create the Network
#                             allow   = Enables the Network Setup in the Admin Dashboard Tools
#                             migrate = Enables multisite and allows the Admin to migrate the databases from a single database
#                                       to multiple databases
#                             true    = Completely enabled and ready to use
####################
class lieutdan13::wordpress(
    $db_name     = 'wordpress',
    $db_host     = 'localhost',
    $db_password = '',
    $db_type     = 'mysql',
    $db_user     = '',
    $multisite   = false,
    $options     = {},
    $version     = 'latest',
    $install_source = '',
) {

    include lieutdan13::essentials

    if $db_password == '' {
        notify { "You must define a \$db_password for lieutdan13::wordpress": loglevel => err }
    } elsif $db_user == '' {
        notify { "You must define a \$db_user for lieutdan13::wordpress": loglevel => err }
    } elsif $version == '' and $install_source == '' {
        notify { "You must define a \$version or \$install_source for lieutdan13::wordpress": loglevel => err }
    } else {

        $real_install_source = $install_source ? {
            ''      => "http://wordpress.org/wordpress-${version}.zip",
            default => $install_source,
        }

        if $multisite == false {
            $options['WP_ALLOW_MULTISITE'] = false
            $options['MULTISITE'] = false
        } elsif $multisite == 'allow' {
            $options['WP_ALLOW_MULTISITE'] = true
            $options['MULTISITE'] = false
        } else {
            $options['WP_ALLOW_MULTISITE'] = true
            $options['MULTISITE'] = true
            if $options['shardb_prefix'] == undef {
                $options['shardb_prefix'] = 'wordpress_mu'
            }
            if $options['shardb_dataset'] == undef {
                $options['shardb_dataset'] = 'global'
            }
            if $options['enable_home_db'] == undef {
                $options['enable_home_db'] = true
            }
            $global_db_name = "${options['shardb_prefix']}${options['shardb_dataset']}"
            mysql::grant { "wordpress_server_grants_${::fqdn}_${global_db_name}":
                mysql_db         => $global_db_name,
                mysql_user       => $db_user,
                mysql_password   => $db_password,
                mysql_privileges => 'ALL',
                mysql_host       => $db_host,
            }
        }

        # This is the only way I could force unzip to be installed before wordpress was installed
        # Adding require => Package['unzip'] to the wordpress class below was not enough
        file { 'wordpress_dependency_workaround':
            ensure  => present,
            path    => '/tmp/wordpress_dependency_workaround',
            require => Package['unzip'],
            before  => Class['::wordpress::install'],
        }

        class { '::wordpress':
            db_name         => $db_name,
            db_host         => $db_host,
            db_password     => $db_password,
            db_type         => $db_type,
            db_user         => $db_user,
            install         => 'source',
            install_source  => $real_install_source,
            my_class        => 'lieutdan13::wordpress::extras',
            options         => $options,
            template        => 'lieutdan13/wordpress/wp-config.php.erb',
            web_server      => '',
            web_virtualhost => '',
        }
    }
}
