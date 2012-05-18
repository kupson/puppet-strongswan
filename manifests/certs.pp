# Class: strongswan::certs
#
# This class manage Certification Authority for strongswan module.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class strongswan::certs {

    # FIXME: replace this whole part with proper puppet functions
    $dir = '/etc/puppet/modules/strongswan/data/pki'
    notice(generate('/usr/bin/puppet', 'cert', '--ssldir', $dir, 'generate', $::fqdn))

    $ca_cert   = file("${dir}/ca/ca_crt.pem")
    $ca_crl    = file("${dir}/ca/ca_crl.pem")
    $node_cert = file("${dir}/certs/${::fqdn}.pem")
    $node_key  = file("${dir}/private_keys/${::fqdn}.pem")

}
