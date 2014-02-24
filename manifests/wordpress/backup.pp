# Class lieutdan13::wordpress::backup
class lieutdan13::wordpress::backup {
    include lieutdan13::params

    $database_backup_dir = $::wordpress::options::db_backup_dir ? {
        ''      => $::mysql_backup_dir ? {
            ''      => $lieutdan13::params::mysql_backup_dir,
            default => $::mysql_backup_dir,
        },
        default => $::wordpress::options::db_backup_dir,
    }
}
