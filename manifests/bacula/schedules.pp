####################################################################################################
# Class lieutdan13::bacula::schedules
####################################################################################################
class lieutdan13::bacula::schedules {
    bacula::director::schedule { 'Monthly':
        run_spec => [
            [
                'Full',
                'on 5',
                '0:01',
            ],
        ],
    }
    bacula::director::schedule { 'Monthly-on-7':
        run_spec => [
            [
                'Full',
                'on 7',
                '0:01',
            ],
        ],
    }
    bacula::director::schedule { 'Monthly-on-10':
        run_spec => [
            [
                'Full',
                'on 10',
                '0:01',
            ],
        ],
    }
    bacula::director::schedule { 'Daily':
        run_spec => [
            [
                'Full',
                'daily',
                '0:10',
            ],
        ],
    }
}
