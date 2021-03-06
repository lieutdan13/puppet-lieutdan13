# Class lieutdan13::wordpress::plugins
class lieutdan13::wordpress::plugins {

    $plugin_options = $::wordpress::options['plugins']

    lieutdan13::wordpress::plugin { 'advanced-custom-fields':
        ensure  => $plugin_options['advanced-custom-fields'] ? {
            /(false|absent)/ => absent,
            ''               => absent,
            default          => present,
        },
        version =>  $plugin_options['advanced-custom-fields'] ? {
            /(true|latest)/  => 'latest-stable', #TODO Put this in a params class
            default          => $plugin_options['advanced-custom-fields'],
        },
    }

    lieutdan13::wordpress::plugin { 'google-analytics-for-wordpress':
        ensure  => $plugin_options['google-analytics-for-wordpress'] ? {
            /(false|absent)/ => absent,
            ''               => absent,
            default          => present,
        },
        version =>  $plugin_options['google-analytics-for-wordpress'] ? {
            /(true|latest)/  => '4.3.5', #TODO Put this in a params class
            default          => $plugin_options['google-analytics-for-wordpress'],
        },
    }

    lieutdan13::wordpress::plugin { 'jetpack':
        ensure  => $plugin_options['jetpack'] ? {
            /(false|absent)/ => absent,
            ''               => absent,
            default          => present,
        },
        version =>  $plugin_options['jetpack'] ? {
            /(true|latest)/  => '2.9', #TODO Put this in a params class
            default          => $plugin_options['jetpack'],
        },
    }

    lieutdan13::wordpress::plugin { 'responsive-lightbox':
        ensure  => $plugin_options['responsive-lightbox'] ? {
            /(false|absent)/ => absent,
            ''               => absent,
            default          => present,
        },
        version =>  $plugin_options['responsive-lightbox'] ? {
            /(true|latest)/  => '1.3.6', #TODO Put this in a params class
            default          => $plugin_options['responsive-lightbox'],
        },
    }

    lieutdan13::wordpress::plugin { 'resume-page':
        ensure  => $plugin_options['resume-page'] ? {
            /(false|absent)/ => absent,
            ''               => absent,
            default          => present,
        },
        version =>  $plugin_options['resume-page'] ? {
            true             => '', #TODO Put this in a params class
            /(true|latest)/  => '', #TODO Put this in a params class
            default          => $plugin_options['resume-page'],
        },
    }

    lieutdan13::wordpress::plugin { 'wordpress-importer':
        ensure  => $plugin_options['wordpress-importer'] ? {
            /(false|absent)/ => absent,
            ''               => absent,
            default          => present,
        },
        version =>  $plugin_options['wordpress-importer'] ? {
            /(true|latest)/  => '0.6.1', #TODO Put this in a params class
            default          => $plugin_options['wordpress-importer'],
        },
    }

    lieutdan13::wordpress::plugin { 'wordpress-seo':
        ensure  => $plugin_options['wordpress-seo'] ? {
            /(false|absent)/ => absent,
            ''               => absent,
            default          => present,
        },
        version =>  $plugin_options['wordpress-seo'] ? {
            /(true|latest)/  => '1.5.2.8', #TODO Put this in a params class
            default          => $plugin_options['wordpress-seo'],
        },
    }

    lieutdan13::wordpress::plugin { 'wp-google-maps':
        ensure  => 'absent',
    }
}
