# Class lieutdan13::wordpress
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

    if $db_password == '' {
        notify { "You must define a \$db_password for lieutdan13::wordpress": loglevel => err }
    } elsif $db_user == '' {
        notify { "You must define a \$db_user for lieutdan13::wordpress": loglevel => err }
    } elsif $version == '' and $install_source == '' {
        notify { "You must define a \$version or \$install_source for lieutdan13::wordpress": loglevel => err }
    } else {

        $real_install_source = $install_source ? {
            ''      => "'http://wordpress.org/wordpress-${version}.zip",
            default => $install_source,
        }

        if $multisite == 'migrating' {
            $options['WP_ALLOW_MULTISITE'] = true
            $options['MULTISITE'] = false
        } elsif $multisite == true {
            $options['WP_ALLOW_MULTISITE'] = true
            $options['MULTISITE'] = true
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
