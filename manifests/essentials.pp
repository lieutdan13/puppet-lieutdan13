# Class lieutdan13::essentials
class lieutdan13::essentials {
    $essential_packages = [
        'make',
        'tar',
        'unzip',
        'zip',
    ]
    package {  [
            'make',
            'tar',
            'unzip',
            'zip',
        ]:
        ensure => latest,
    }
}
