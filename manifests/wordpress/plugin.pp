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

    $version_append = $version ? {
        ''      => '',
        default => ".${version}",
    }

    $real_source_url = $source_url ? {
        ''      => "${plugins_url}/${name}${version_append}.zip",
        default => $source_url,
    }

    case $ensure {
        'present': {
            puppi::netinstall { "wp-plugin ${name}":
                url             => $real_source_url,
                destination_dir => $real_destination_dir,
                extracted_dir   => $real_extracted_dir,
                require         => Class['::wordpress'],
            }
        }

        'absent': {
            file { "wp-plugin ${name}":
                ensure  => absent,
                force   => true,
                path    => "${real_destination_dir}/${real_extracted_dir}",
                recurse => true,
            }
        }

        default: { }
    }
}
