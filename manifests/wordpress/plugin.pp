# Define lieutdan13::wordpress::plugin
define lieutdan13::wordpress::plugin (
    $destination_dir = '',
    $extracted_dir   = '',
    $ensure          = 'present',
    $plugins_url     = 'http://downloads.wordpress.org/plugin',
    $source_url      = '',
    $version         = '',
    $version_file    = 'readme.txt',
    $version_regex   = 'Stable tag: '
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
            if $version != '' and $version != 'latest' and $version_file and $version_regex and $real_destination_dir and $real_extracted_dir {
                exec { "wp-plugin ${name} version check":
                    command => "/bin/true",
                    unless  => "/bin/grep '${version_regex} ${version}' ${real_destination_dir}/${real_extracted_dir}/${version_file}",
                    notify  => Exec["wp-plugin ${name} remove old version"],
                }

                exec { "wp-plugin ${name} remove old version":
                    command     => "/bin/rm -rf ${real_destination_dir}/${real_extracted_dir}",
                    refreshonly => true,
                    before      => Puppi::Netinstall["wp-plugin ${name}"],
                }
            }
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
