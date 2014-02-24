# Class lieutdan13::wordpress::backup
class lieutdan13::wordpress::backup {
    include lieutdan13::params

    $backup_options = $::wordpress::options['backup']
    $backup_enabled = $backup_options['enabled'] ? {
        true    => true,
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
        true    => "-`date +\%Y\%d\%m`",
        default => '',
    }

    #Don't remove the directory if backup is not enabled, in case the directory is shared by other backups
    if $backup_enabled == true and !defined(File[$database_backup_dir]) {
        file { $database_backup_dir:
            ensure => directory,
            owner  => $backup_user,
            path   => $database_backup_dir,
        }
    }

    cron { 'wordpress backup database':
        command => "mysqldump -h ${::wordpress::db_host} -u ${::wordpress::db_user} --password=${::wordpress::db_password} ${::wordpress::db_name} > ${database_backup_dir}/${::wordpress::db_name}${backup_db_date}.sql",
        ensure  => $database_cron_ensure,
        hour    => $backup_hour,
        minute  => $backup_minute,
        require => Class['::wordpress'],
        user    => $backup_user,
    }
}
