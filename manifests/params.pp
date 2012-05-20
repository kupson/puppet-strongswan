# Class: strongswan::params
#
# This class sets platform specific variables for strongswan:: namespace.
#
# Parameters:
#   [*ikev1_nat_t*]   - enable IKEv1 NAT-T true|*false* (extlookup)
#   [*silence_ikev2*] - less vebose charon/IKEv2 logging *true*|false (extlookup)
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

    $ikev1_nat_t   = extlookup('strongswan_ikev1_nat_t', 'false')
    $silence_ikev2 = extlookup('strongswan_silence_ikev2', 'true')

}
