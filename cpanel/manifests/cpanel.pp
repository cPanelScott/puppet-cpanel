class cpanel {
    define easyapache( $source, $email = '' ) {
        file { '/var/cpanel/easy/apache/profile/custom/puppet.yaml':
            owner  => 'root',
            group  => 'root',
            mode   => 0644,
            notify => Exec['runeasyapache'],
            source => $source
        }
        exec { 'runeasyapache':
            command     => $email ? { ''      => '/usr/local/cpanel/scripts/easyapache --profile=puppet --build 2>&1 >/dev/null',
                                      default => "/usr/local/cpanel/scripts/easyapache --profile=puppet --build 2>&1 | /bin/mail -s 'EasyApache Run' $email &" },
            refreshonly => true,
            user        => 'root',
            unless      => '/bin/ps ax | /bin/grep -v grep | /bin/grep easyapache > /dev/null'
        }
    }
    define tweaksetting( $source, $email ) {
        file { '/var/cpanel/cpanel.config':
            owner  => 'root',
            group  => 'root',
            mode   => 0644,
            notify => Exec['runtweaksetting'],
            source => $source
        }
        exec{ 'runtweaksetting':
            command     => $email ? { ''      => '/usr/local/cpanel/whostmgr/bin/whostmgr2 --updatetweaksettings 2>&1 >/dev/null',
                                         default => "/usr/local/cpanel/whostmgr/bin/whostmgr2 --updatetweaksettings 2>&1 | /bin/mail -s 'Tweak Settings Run' $email &" },
            refreshonly => true,
            user        => 'root',
            unless      => '/bin/ps ax | /bin/grep -v grep | /bin/grep updatetweaksettings > /dev/null'
        }
    }
    define baseconfig(
        $host,
        $ns,
        $ns2,
        $contactemail,
        $logstyle        = 'combined',
        $ns4             = '',
        $nsttl           = '86400',
        $ns3             = '',
        $ethdev          = 'eth0',
        $contactpager    = '',
        $ttl             = '14400',
        $homematch       = 'home',
        $defwebmailtheme = 'x3',
        $minuid          = '500',
        $addr            = $ipaddress,
        $homedir         = '/home',
        $defmod          = 'x3',
        $scriptalias     = 'y' ) {
        file { '/etc/wwwacct.conf':
            owner   => 'root',
            group   => 'root',
            mode    => 0644,
            content => template('cpanel/wwwacct.conf')
        }

    }

    define cpanelaccount(
        $ensure        = 'present',
        $email         = '',
        $domain,
        $user,
        $contactemail  = 0,
        $pass          = inline_template("<%= (1..25).collect{|a| (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + %w(% & * + - : ? @ ^ _))[rand(75)] }.join %>"),
        $quota         = 0,
        $theme         = 'x3',
        $has_ip        = 'n',
        $has_cgi       = 'n',
        $has_frontpage = 'n',
        $maxftp        = 0,
        $maxsql        = 0,
        $maxpop        = 0,
        $maxlist       = 0,
        $maxsub        = 0,
        $bwlimit       = 0,
        $has_shell     = 'n',
        $owner         = 'root',
        $plan          = 'default',
        $maxpark       = 0,
        $maxaddon      = 0,
        $featurelist   = 'default',
        $language      = 'english',
        $use_registered_nameservers = 0 ) {

        if $ensure == 'present' {
            exec { "add-$user":
                command => $email ? { ''      => "/usr/local/cpanel/scripts/wwwacct $domain $user $pass $quota $theme $has_ip $has_cgi $has_frontpage $maxftp $maxsql $maxpop $maxlist $maxsub $bwlimit $has_shell $owner $plan $maxpark $maxaddon $featurelist $contactemail $use_registered_nameservers $language",
                                      default => "/usr/local/cpanel/scripts/wwwacct $domain $user $pass $quota $theme $has_ip $has_cgi $has_frontpage $maxftp $maxsql $maxpop $maxlist $maxsub $bwlimit $has_shell $owner $plan $maxpark $maxaddon $featurelist $contactemail $use_registered_nameservers $language 2>&1 | /bin/mail -s 'Add Account for $user' $email &" },
                user    => 'root',
                unless  => [ "/bin/grep ^$domain: /etc/userdomains > /dev/null",
                             "/bin/grep ' $user$' /etc/userdomains > /dev/null" ],
                require => File['/etc/wwwacct.conf']
            }
        } elsif $ensure == 'absent' {
            exec { "remove-$user":
                command => $email ? { ''      => "/usr/local/cpanel/scripts/killacct --force $user",
                                      default => "/usr/local/cpanel/scripts/killacct --force $user 2>&1 | /bin/mail -s 'Remove account for $user' $email &" },
                user    => 'root',
                onlyif  => "/bin/grep ' $user$' /etc/userdomains | /bin/grep ^$domain: >/dev/null",
                require => File['/etc/wwwacct.conf']
            }
        }
    }
}
