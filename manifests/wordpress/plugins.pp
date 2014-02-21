# Class lieutdan13::wordpress::plugins
class lieutdan13::wordpress::plugins {

    $plugin_options = $::wordpress::options['plugins']

    if $plugin_options['google-analytics-for-wordpress'] != '' {
        lieutdan13::wordpress::plugin { 'google-analytics-for-wordpress':
            ensure  => $plugin_options['google-analytics-for-wordpress'] ? {
                /(false|absent)/ => absent,
                default          => present,
            },
            version =>  $plugin_options['google-analytics-for-wordpress'] ? {
                /(true|latest)/  => '4.3.5', #TODO Put this in a params class
                default          => $plugin_options['google-analytics-for-wordpress'],
            },
        }
    }
}
