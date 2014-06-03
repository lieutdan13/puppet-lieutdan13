# Class lieutdan13::wordpress::themes
class lieutdan13::wordpress::themes {

    $theme_options = $::wordpress::options['themes']

    lieutdan13::wordpress::theme { 'responsive':
        ensure  => $theme_options['responsive'] ? {
            /(false|absent)/ => absent,
            default          => present, #If left blank, enable it
        },
        version =>  $theme_options['responsive'] ? {
            /(true|latest)/  => '1.9.6.1', #TODO Put this in a params class
            default          => $theme_options['responsive'],
        },
    }

    lieutdan13::wordpress::theme { 'twentytwelve':
        ensure  => $theme_options['twentytwelve'] ? {
            /(false|absent)/ => absent,
            default          => present, #If left blank, enable it
        },
        version =>  $theme_options['twentytwelve'] ? {
            /(true|latest)/  => '1.3', #TODO Put this in a params class
            undef            => '1.3', #TODO Put this in a params class
            default          => $theme_options['twentytwelve'],
        },
    }

    lieutdan13::wordpress::theme { 'something-fishy':
        ensure  => $theme_options['something-fishy'] ? {
            /(false|absent)/ => absent,
            ''               => absent,
            default          => present,
        },
        version =>  $theme_options['something-fishy'] ? {
            /(true|latest)/  => '1.10', #TODO Put this in a params class
            default          => $theme_options['something-fishy'],
        },
    }
}
