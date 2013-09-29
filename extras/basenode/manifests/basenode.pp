class basenode {
#    file { '/etc/motd':
#        source => 'puppet:///modules/basenode/motd'
#    }
#    file { '/etc/ssh/sshd_config':
#        source => 'puppet:///modules/basenode/sshd_config',
#        notify => Service['sshd']
#    }
#    service { 'sshd':
#    }
#    cpanel::easyapache { 'puppet':
#        source => 'puppet:///modules/basenode/easyapache.yaml',
#        email  => 'some@example.com'
#    }
#    cpanel::tweaksetting { 'puppet':
#        options => { 
#                     'ftpserver'  => 'proftpd',
#                     'mailserver' => 'dovecot'
#                   },
#	email   => 'some@example.com'
#    }
#    cpanel::baseconfig { 'puppet':
#        ns           => 'test-a.cpanel.net',
#        ns2          => 'test-b.cpanel.net',
#        contactemail => 'some@example.com'
#    }
#    cpanel::cpanelaccount{ 'puppet':
#	email       => 'some@example.com',
#       domain      => 'thisisadomain.com',
#       user        => 'someuser',
#	ensure      => 'present'
#    }
}

