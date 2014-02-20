# Class lieutdan13::wordpress::extras
class lieutdan13::wordpress::extras {
    #htaccess
    file { 'wordpress_htaccess':
        content => template('lieutdan13/wordpress/htaccess.erb'),
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/.htaccess",
    }

    #shardb plugin
    file { 'wpplugin_shardb_db-settings.php':
        ensure  => $lieutdan13::wordpress::multisite ? {
            false   => 'absent',
            allow   => 'absent',
            default => 'present',
        },
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/db-settings.php",
        source  => 'puppet:///modules/lieutdan13/wordpress/plugins/shardb/db-settings.php'
    }
    file { 'wpplugin_shardb_shardb-admin.php':
        ensure  => $lieutdan13::wordpress::multisite ? {
            false   => 'absent',
            allow   => 'absent',
            default => 'present',
        },
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/wp-content/plugins/shardb-admin.php",
        source  => 'puppet:///modules/lieutdan13/wordpress/plugins/shardb/shardb-admin.php'
    }
    file { 'wpplugin_shardb_db.php':
        ensure  => $lieutdan13::wordpress::multisite ? {
            true    => 'present',
            default => 'absent',
        },
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/wp-content/db.php",
        source  => 'puppet:///modules/lieutdan13/wordpress/plugins/shardb/db.php'
    }
}
