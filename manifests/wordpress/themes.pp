# Class lieutdan13::wordpress::themes
class lieutdan13::wordpress::themes {

    $theme_options = $::wordpress::options['themes']

    lieutdan13::wordpress::theme { 'twentytwelve':
        ensure  => $theme_options['twentytwelve'] ? {
            /(false|absent)/ => absent,
            ''               => absent,
            default          => present,
        },
        version =>  $theme_options['twentytwelve'] ? {
            /(true|latest)/  => '1.3', #TODO Put this in a params class
            default          => $theme_options['twentytwelve'],
        },
    }
}
