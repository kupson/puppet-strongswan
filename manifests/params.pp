# Class: strongswan::params
#
# This class sets platform specific variables for strongswan:: namespace.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class strongswan::params {

    case $::operatingsystem {
        'ubuntu', 'debian': {
            $package      = 'strongswan'
            $service_name = 'ipsec'
            $conf_dir     = '/etc/ipsec.d'
            $secrets_file = '/etc/ipsec.secrets'
            $conf_file    = '/etc/ipsec.conf'
            $conf_tmpl    = 'ipsec.conf.debian'
        }
        # TODO: openswan: NSS certficates only?
        #'centos', 'redhat': {
        #    $package      = 'openswan'
        #    $service_name = 'ipsec'
        #    $conf_dir     = '/etc/ipsec.d'
        #    $secrets_file = '/etc/ipsec.secrets'
        #    $conf_file    = '/etc/ipsec.conf'
        #    $conf_tmpl    = 'ipsec.conf.centos'
        #}
        default: {
            fail("Unsupported platform: ${::operatingsystem}")
        }
    }

}
