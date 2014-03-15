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

    $lightbox_gallery_ensure = $plugin_options['lightbox-gallery'] ? {
        /(false|absent)/ => absent,
        ''               => absent,
        default          => present,
    }
    lieutdan13::wordpress::plugin { 'lightbox-gallery':
        ensure  => $lightbox_gallery_ensure,
        version =>  $plugin_options['lightbox-gallery'] ? {
            /(true|latest)/  => '0.7.4', #TODO Put this in a params class
            default          => $plugin_options['lightbox-gallery'],
        },
    }

    if ($lightbox_gallery_ensure == 'present') {
         puppi::netinstall { 'lightbox-gallery jquery.lightbox.js':
            url             => 'http://wpgogo.com/jquery.lightbox.js',
            destination_dir => "${::wordpress::real_data_dir}/wp-content/plugins/lightbox-gallery",
            extract_command => 'cp',
            require         => Lieutdan13::Wordpress::Plugin['lightbox-gallery'],
        }
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

    lieutdan13::wordpress::plugin { 'wp-google-maps':
        ensure  => 'absent',
    }
}
