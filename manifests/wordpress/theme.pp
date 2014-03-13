# Define lieutdan13::wordpress::theme
define lieutdan13::wordpress::theme (
    $destination_dir = '',
    $extracted_dir   = '',
    $ensure          = 'present',
    $themes_url      = 'http://wordpress.org/themes/download',
    $source_file     = '',
    $source_url      = '',
    $version         = ''
) {
    $real_destination_dir = $destination_dir ? {
        ''      => "${::wordpress::real_data_dir}/wp-content/themes",
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

    $real_source_url = $source_file ? {
        ''      => $source_url ? {
            ''      => "${themes_url}/${name}${version_append}.zip",
            default => $source_url,
        },
        default => $source_file,
    }

    case $ensure {
        'present': {
            if ($source_file != '') {
                $source_filename = url_parse($source_file, 'filename')
                file { "wp-theme ${name} archive":
                    path   => "/var/tmp/${source_filename}",
                    source => $source_file,
                }
                $retrieve_command = "test"
                $theme_require = [Class['::wordpress'],File["wp-theme ${name} archive"]]
            } else {
                $retrieve_command = undef
                $theme_require = Class['::wordpress']
            }
            puppi::netinstall { "wp-theme ${name}":
                url             => $real_source_url,
                destination_dir => $real_destination_dir,
                extracted_dir   => $real_extracted_dir,
                retrieve_command => $retrieve_command,
                require         => $theme_require,
            }
        }

        'absent': {
            file { "wp-theme ${name}":
                ensure  => absent,
                force   => true,
                path    => "${real_destination_dir}/${real_extracted_dir}",
                recurse => true,
            }
        }

        default: { }
    }
}
