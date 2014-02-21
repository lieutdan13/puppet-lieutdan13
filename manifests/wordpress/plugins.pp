# Class lieutdan13::wordpress::plugins
class lieutdan13::wordpress::plugins {

    if $::wordpress::options['plugins']['google-analytics-for-wordpress'] != '' {
        lieutdan13::wordpress::plugin { 'google-analytics-for-wordpress':
            ensure  => $::wordpress::options['plugins']['google-analytics-for-wordpress'] ? {
                /(false|absent)/ => absent,
                default          => present,
            },
            version =>  $::wordpress::options['plugins']['google-analytics-for-wordpress'] ? {
                /(true|latest)/    => '4.3.5', #TODO Put this in a params class
                default => $::wordpress::options['plugins']['google-analytics-for-wordpress'],
            },
        }
    }
}
