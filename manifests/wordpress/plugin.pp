# Define lieutdan13::wordpress::plugin
define lieutdan13::wordpress::plugin (
    $destination_dir = '',
    $extracted_dir   = '',
    $ensure          = 'present',
    $plugins_url     = 'http://downloads.wordpress.org/plugin',
    $source_url      = '',
    $version         = ''
) {
    $real_destination_dir = $destination_dir ? {
        ''      => "${::wordpress::real_data_dir}/wp-content/plugins",
        default => $destination_dir,
    }

    $real_extracted_dir = $extracted_dir ? {
        ''      => $name,
        default => $extracted_dir,
    }

    $real_source_url = $source_url ? {
        ''      => "${plugins_url}/${name}.${version}.zip",
        default => $source_url,
    }

#    puppi::netinstall { "wp-plugin ${name}":
#        url             => $real_source_url,
#        destination_dir => $real_destination_dir,
#        extracted_dir   => $real_extracted_dir
#    }

    notify { "wp-plugin ${name} \$real_source_url": message => $real_source_url, log_level => debug, }
    notify { "wp-plugin ${name} \$ensure": message => $ensure, log_level => debug, }
    notify { "wp-plugin ${name} \$version": message => $version, log_level => debug, }
    notify { "wp-plugin ${name} \$real_destination_dir": message => $real_destination_dir, log_level => debug, }
    notify { "wp-plugin ${name} \$real_extracted_dir": message => $real_extracted_dir, log_level => debug, }
}
