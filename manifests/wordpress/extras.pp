# Class lieutdan13::wordpress::extras
class lieutdan13::wordpress::extras {
    #htaccess
    file { 'wordpress_htaccess':
        content => template('lieutdan13/wordpress/htaccess.erb'),
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/.htaccess",
        require => Class['::wordpress::install'],
    }

    #shardb plugin
    file { 'wpplugin_shardb_db-settings.php':
        ensure  => $lieutdan13::wordpress::multisite ? {
            false   => 'absent',
            allow   => 'absent',
            default => $lieutdan13::wordpress::multidb ? {
                true    => 'present',
                default => 'absent',
            },
        },
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/db-settings.php",
        source  => 'puppet:///modules/lieutdan13/wordpress/plugins/shardb/db-settings.php',
        require => Class['::wordpress::install'],
    }
    file { 'wpplugin_shardb_shardb-admin.php':
        ensure  => $lieutdan13::wordpress::multisite ? {
            false   => 'absent',
            allow   => 'absent',
            default => $lieutdan13::wordpress::multidb ? {
                true    => 'present',
                default => 'absent',
            },
        },
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/wp-content/plugins/shardb-admin.php",
        source  => 'puppet:///modules/lieutdan13/wordpress/plugins/shardb/shardb-admin.php',
        require => Class['::wordpress::install'],
    }
    file { 'wpplugin_shardb_db.php':
        ensure  => $lieutdan13::wordpress::multisite ? {
            true    => $lieutdan13::wordpress::multidb ? {
                true    => 'present',
                default => 'absent',
            },
            default => 'absent',
        },
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/wp-content/db.php",
        source  => 'puppet:///modules/lieutdan13/wordpress/plugins/shardb/db.php',
        require => Class['::wordpress::install'],
    }

    # WordPress MU Domain Mapping plugin
    file { 'wpplugin_mu-domain-mapping_mu-plugins':
        ensure  => $lieutdan13::wordpress::multisite ? {
            false   => 'absent',
            allow   => 'absent',
            default => directory,
        },
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/wp-content/mu-plugins",
        require => Class['::wordpress::install'],
    }
    file { 'wpplugin_mu-domain-mapping_domain_mapping.php':
        ensure  => $lieutdan13::wordpress::multisite ? {
            false   => 'absent',
            allow   => 'absent',
            default => 'present',
        },
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/wp-content/mu-plugins/domain_mapping.php",
        source  => 'puppet:///modules/lieutdan13/wordpress/plugins/wordpress-mu-domain-mapping/domain_mapping.php',
        require => File['wpplugin_mu-domain-mapping_mu-plugins'],
    }
    file { 'wpplugin_mu-domain-mapping_sunrise.php':
        ensure  => $lieutdan13::wordpress::multisite ? {
            false   => 'absent',
            allow   => 'absent',
            default => 'present',
        },
        group   => root,
        mode    => '644',
        owner   => root,
        path    => "${::wordpress::real_data_dir}/wp-content/sunrise.php",
        source  => 'puppet:///modules/lieutdan13/wordpress/plugins/wordpress-mu-domain-mapping/sunrise.php',
        require => Class['::wordpress::install'],
    }
}
