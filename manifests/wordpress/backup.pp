####################################################################################################
# Class lieutdan13::wordpress::backup
#
# The Wordpress Class supports an $options parameter that can be used in included classes and
# templates. This class uses the $options['backup'] element in the hash. Here are the supported
# sub-keys.
#
# options['backup']['enabled']              : (boolean) Enable or disable backup (Default: false)
# options['backup']['bacula']               : (boolean) Enable or disable backup using bacula
#                                             (Default: false)
# options['backup']['bacula_client_name']   : (string) The name of the Bacula Client to use.
#                                             (Default: $::fqdn)
# options['backup']['backup_dir']           : (string)  Directory to use to dump the MySql database
#                                             (Default: $::mysql_backup_dir global variable or
#                                             $lieutdan13::params::mysql_backup_dir if not set)
# options['backup']['user']                 : (string)  User to run the MySql dump command using cron
#                                             and to own the $backup_dir (Default: root)
# options['backup']['cron_hour']            : (string)  Hour of the day to run the MySql dump
#                                             (Default: 0)
# options['backup']['cron_minute']          : (string)  Minute of the hour to run the MySql dump
#                                             (Default: 5)
# options['backup']['cron_dated']           : (boolean) Whether to include a date in the MySql dump file
#                                             (Default: '')
# options['backup']['cleanup_days']         : (integer) How many MySql files to keep. If you use this
#                                             feature, you must also enable cron_dated. Otherwise, the
#                                             MySql dumps will be removed shortly after they are created.
#                                             (Default: 14)
# options['backup']['compress']             : (boolean) Whether to compress the MySql dump into a
#                                             .sql.gz file instead of .sql (Default: false)
#
####################################################################################################
class lieutdan13::wordpress::backup {
    include lieutdan13::params

    $backup_options = $::wordpress::options['backup']
    $backup_enabled = $backup_options['enabled'] ? {
        true    => true,
        default => false,
    }
    $bacula_enabled = $backup_enabled ? {
        true    => $backup_options['bacula'] ? {
            true    => true,
            default => false,
        },
        default => false,
    }
    $database_cron_ensure   = $backup_enabled ? {
        true    => $::wordpress::db_type ? {
            /^(mysql|remote_mysql)$/ => 'present',
            default => 'absent',
        },
        default => 'absent',
    }

    $database_backup_dir = $backup_options['backup_dir'] ? {
        ''      => $::mysql_backup_dir ? {
            ''      => $lieutdan13::params::mysql_backup_dir,
            default => $::mysql_backup_dir,
        },
        default => $backup_options['backup_dir'],
    }
    $backup_user = $backup_options['user'] ? {
        ''      => 'root',
        default => $backup_options['user'],
    }
    $backup_hour = $backup_options['cron_hour'] ? {
        ''      => 0,
        default => $backup_options['cron_hour'],
    }
    $backup_minute = $backup_options['cron_minute'] ? {
        ''      => 5,
        default => $backup_options['cron_minute'],
    }
    $backup_db_date = $backup_options['cron_dated'] ? {
        true    => ".`date +\\%Y\\%m\\%d`",
        default => '',
    }
    $backup_db_cleanup_days = $backup_options['cron_dated'] ? {
        true    => $backup_options['cleanup_days'] ? {
            ''      => 14,
            default => $backup_options['cleanup_days'],
        },
        default => 0,
    }
    $bacula_client_name = $backup_options['bacula_client_name'] ? {
        ''      => $::fqdn,
        default => $backup_options['bacula_client_name'],
    }
    if $database_cron_ensure == 'present' and $backup_db_cleanup_days > 0 {
        $database_cron_cleanup_ensure = 'present'
    } else {
        $database_cron_cleanup_ensure = 'absent'
    }
    $cron_command = $backup_options['compress'] ? {
        true    => "mysqldump -h ${::wordpress::db_host} -u ${::wordpress::db_user} --password=${::wordpress::db_password} --compact ${::wordpress::db_name} | gzip -c > ${database_backup_dir}/${::wordpress::db_name}/${::wordpress::db_name}${backup_db_date}.sql.gz",
        default => "mysqldump -h ${::wordpress::db_host} -u ${::wordpress::db_user} --password=${::wordpress::db_password} ${::wordpress::db_name} > ${database_backup_dir}/${::wordpress::db_name}/${::wordpress::db_name}${backup_db_date}.sql",
    }
    # Double escaped to prevent puppet errors
    $cron_cleanup_command = "find ${database_backup_dir}/${::wordpress::db_name} -type f -regextype grep -type f -regex '.*/${::wordpress::db_name}\\(\\.[0-9]\\{8\\}\\)\\?\\.sql\\(\\.gz\\)\\?' -mtime +${backup_db_cleanup_days} -print0 | xargs -0 --no-run-if-empty rm -f"

    #Don't remove the directory if backup is not enabled, in case the directory is shared by other backups
    if $backup_enabled == true {
        if !defined(File[$database_backup_dir]) {
            file { $database_backup_dir:
                ensure => directory,
                owner  => $backup_user,
                path   => $database_backup_dir,
            }
        }
        file { "${database_backup_dir}/${::wordpress::db_name}":
            ensure => directory,
            owner  => $backup_user,
            path   => "${database_backup_dir}/${::wordpress::db_name}",
        }
    }
    cron { 'wordpress backup database':
        command => $cron_command,
        ensure  => $database_cron_ensure,
        hour    => $backup_hour,
        minute  => $backup_minute,
        require => Class['::wordpress'],
        user    => $backup_user,
    }
    cron { 'wordpress backup database cleanup':
        command => $cron_cleanup_command,
        ensure  => $database_cron_cleanup_ensure,
        hour    => $backup_hour + 1,
        minute  => $backup_minute,
        require => Class['::wordpress'],
        user    => $backup_user,
    }
    if $bacula_enabled == true {
        @@bacula::director::fileset { "Wordpress Files for ${bacula_client_name}":
            signature    => 'SHA1',
            compression  => 'GZIP',
            onefs        => 'yes',
            include      => [
                "${database_backup_dir}/${::wordpress::db_name}",
                "${::wordpress::real_data_dir}",
            ],
        }
        @@bacula::director::pool { "Wordpress for ${bacula_client_name} Full":
            type                => 'Backup',
            maximum_volume_jobs => '1',
            use_volume_once     => 'yes',
            recycle             => 'no',
            action_on_purge     => 'Truncate',
            auto_prune          => 'yes',
            volume_retention    => '1 month',
            label_format        => 'Full_${Year}-${Month:p/2/0/r}-${Day:p/2/0/r}_Wordpress_for_${bacula_client_name}',
            storage             => 'FullStorage',
            tag                 => "${::fqdn}",
        }
        @@bacula::director::job { "Backup Wordpress for ${bacula_client_name}":
            client       => $bacula_client_name,
            type         => 'Backup',
            fileset      => "Wordpress Files for ${bacula_client_name}",
            pool         => "Wordpress for ${bacula_client_name} Full",
            job_schedule => 'Monthly',
            priority     => 5,
            messages     => 'Standard',
            jobdef       => 'Default JobDefs',
            template     => 'bacula/director/job.conf.erb',
            require      => Bacula::Director::Client[$bacula_client_name],
            tag          => "${::fqdn}",
        }
    }
}
