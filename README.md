puppet-cpanel
=============

This module provides the following new Resource Types that enable you to
control various aspects of cPanel in an automated fashion through Puppet.
Here is a list available Resource Types:

###cpanel::easyapache
Allows you to pass a EasyApache YAML stored config, and automatically trigger an
easyapache recompile if a change is detected with the configuration file.

###cpanel::tweaksettings
Allows you to pass key => value pairs for the cpanel.config file and
automatically updates your tweak settings if a change is detected.

###cpanel::baseconfig
Allows you to pass a set options to update the /etc/wwacct.conf file

###cpanel::cpanelaccount
Allows you to add/remove a cpanel account. You must use the cpanel::baseconfig
resource type when using this resource type.

Examples
--------

    cpanel::easyapache { 'puppet':
        source => 'puppet:///modules/basenode/puppet.yaml',
        email  => 'scott@cpanel.net'
    }

    cpanel::tweaksetting { 'puppet':
        options => {
                     'skipantirelayd'   => 1,
                     'jaildefaultshell' => 0,
                   },
        email   => 'scott@cpanel.net'
    }

    cpanel::baseconfig { 'puppet':
        host         => 'test.cpanel.net',
        ns           => 'test-a.cpanel.net',
        ns2          => 'test-b.cpanel.net',
        contactemail => 'scott@cpanel.net'
    }

    #Make sure to include a cpanel::baseconfig resource when using
    #cpanel::cpanelaccount
    cpanel::cpanelaccount{ 'puppet':
        email       => 'scott@cpanel.net',
        domain      => 'thisisabar.com',
        user        => 'zanny',
        ensure      => 'absent'
    }

Complete set of options
-----------------------

    cpanel::easyapache { 'resource title':
        #Required Parameters
        source => #An easyapache stored configuration YAML. Examples can be
                  #found in /var/cpanel/easy/apache/profile
                  #See documentation for the source parameter in the file
                  #resource for more specification information.
        #Optional Parameters
        email  => #An E-Mail address where the output from the easyapache
                  #should be sent
    } 

    cpanel::tweaksetting { 'resource title':
        #Required parameters
        options => #A hash of keys and values for the cpanel.config file. Take
                   #a look at your /var/cpanel/cpanel.config for a list of the
                   #available keys. See the tweak settings WHM page for some
                   #hints as to which key does what
        #Optional Parameters
        email   => #An E-Mail address where the output from the easyapache
                   #should be sent
    }

    cpanel::baseconfig { 'resource title':
        #See
        #http://docs.cpanel.net/twiki/bin/view/AllDocumentation/InstallationGuide/AdvancedOptions#The%20/etc/wwwacct.conf%20file
        #for additional documentation on the /etc/wwwacct.conf file for more
        #info

        #Required Parameters
        host         => #Hostname of server,
        ns           => #First name server for domains created with cPanel
        ns2,         => #Second name server for domains created with cPanel
        contactemail => #E-Mail address cPanel sends notifications to
        #Optional Parameters
        logstyle        => #Apache LogFormat. Default: combined
        ns4             => #Foruth name server for domains created with cPanel
                           #Default: (empty string)
        nsttl           => #TTL for NS records for domains created with cPanel
                           #Default: 86400
        ns3             => #Third name server for domains created with cPanel
                           #Default: (empty string)
        ethdev          => #Ethernet device name. Default: eth0
        contactpager    => #E-Mail address of pager/cell phone to contact when
                           #a problem arises Default: (empty string)
        ttl             => #TTL for all other records for domains created with
                           #cPanel. Default: 14400
        homematch       => #Search word for other "home" directories. Default:
                           #home
        defwebmailtheme => #Default webmail theme to use when creating new
                           #accounts. Default is x3
        minuid          => #Minimum uerid to use when creating system users.
                           #Default is 500
        addr            => #IP Address used for shared virtual hosts. Default
                           #uses the facter value $ipaddress
        homedir         => #Directory to create new accounts in. Default:
                           #/home
        defmod          => #Default them to use when creating new accounts.
                           #Default is x3
        scriptalias     => #Whether a cgi-bin directory should be creared with
                           #new accounts. Default is y
    }

    cpanel::cpanelaccount { 'Resource Title':
        #Note: Does not run if an account with the same username or domain name
        #      already exists
        #Required
        $domain        => #Domain name of the account you want to add
        $user          => #Username of the account you want to add
        #Optional
        $ensure        => #One of present or absent. Ensures the user/domain
                          #exists or ensure it does not exist. Default is
                          #present
        $email         => #E-Mail address to send the output of the wwwacct
                          #command
        $contactemail  => #E-Mail address for the contact person of this
                          #account. Default is 0
        $pass          => #Password for new account. By default it's a
                          #random 25 character string
        $quota         => #Disk quota. By default it's  0, which is unlimited
        $theme         => #Theme for this account. Default is x3
        $has_ip        => #Assign this site a dedicated IP. Default is n
        $has_cgi       => #Include CGI support. Default is n
        $has_frontpage => #Include frontpage support. Default is n
        $maxftp        => #Maximum number of FTP accounts. Default is 0
        $maxsql        => #Maximum number of MySQL databases. Default is 0
        $maxpop        => #Maximum number of pop accounts. Default is 0
        $maxlist       => #Maximum number of mailing lists. Default is 0
        $maxsub        => #Maximum number of subdmains. Default is 0
        $bwlimit       => #Bandwith limit. Default is 0
        $has_shell     => #Enable shell access? Default is n
        $owner         => #Which reseller owns this account? Default is root
        $plan          => #Which hosting plan? Deafult is default
        $maxpark       => #Max parked domains? Default is 0
        $maxaddon      => #Max addon domains? Default is 0
        $featurelist   => #Feature list? Default is default
        $language      => #Language? Default is english
        $use_registered_nameservers => #Where or not to use the registered 
                                       #authoritative nameservers. Default is
                                       #0
    }

