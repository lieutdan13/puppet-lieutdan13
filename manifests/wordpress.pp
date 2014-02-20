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
        err("You must define a \$db_password for lieutdan13::wordpress")
    } elsif $db_user == '' {
        err("You must define a \$db_user for lieutdan13::wordpress")
    } elsif $version == '' && $install_source == '' {
        err("You must define a \$version or \$install_source for lieutdan13::wordpress")
    } else {

        $real_install_source = $install_source ? {
            ''      => "'http://wordpress.org/wordpress-${version}.zip",
            default => $install_source,
        }

        if $multisite == 'migrating' {
            $options['WP_ALLOW_MULTISITE'] = true
            $options['MULTISITE'] = false
        } elif $multisite == true {
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
