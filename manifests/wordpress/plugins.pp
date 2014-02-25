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

    lieutdan13::wordpress::plugin { 'resume-page':
        ensure  => $plugin_options['resume-page'] ? {
            /(false|absent)/ => absent,
            ''               => absent,
            default          => present,
        },
        source_url => 'http://downloads.wordpress.org/plugin/resume-page.zip', #This plugin doesn't have versions (yet)
    }
}
