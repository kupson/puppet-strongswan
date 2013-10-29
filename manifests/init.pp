# Class: strongswan
#
# This module installs strongswan on node.
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
class strongswan {
    include strongswan::params
    include strongswan::certs

    package {
        $strongswan::params::package:
            ensure => latest;
    }

    service {
        $strongswan::params::service_name:
            ensure     => running,
            enable     => true,
            hasrestart => true,
            hasstatus  => true, #FIXME: proper return code?
            require    => Package[$strongswan::params::package];
    }

    exec {
        'ipsec-reload':
            command     => 'ipsec reload',
            path        => '/usr/sbin',
            refreshonly => true,
            require     => Package[$strongswan::params::package];
        'ipsec-reread':
            command     => 'ipsec rereadall',
            path        => '/usr/sbin',
            refreshonly => true,
            require     => Package[$strongswan::params::package];
        'ipsec-secrets':
            command     => 'ipsec secrets',
            path        => '/usr/sbin',
            refreshonly => true,
            require     => Package[$strongswan::params::package];
    }

    file {
        [  "${strongswan::params::conf_dir}/cacerts",
           "${strongswan::params::conf_dir}/crls",
           "${strongswan::params::conf_dir}/certs",
           "${strongswan::params::conf_dir}/private",
           "${strongswan::params::conf_dir}/connections", ]:
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0755';
        "${strongswan::params::conf_dir}/cacerts/puppet_ca.pem":
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => $strongswan::certs::ca_cert,
            notify  => Exec['ipsec-reread'];
        "${strongswan::params::conf_dir}/crls/puppet_crl.pem":
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => $strongswan::certs::ca_crl,
            notify  => Exec['ipsec-reread'];
        "${strongswan::params::conf_dir}/certs/${::fqdn}.pem":
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => $strongswan::certs::node_cert,
            notify  => Exec['ipsec-reread'];
        "${strongswan::params::conf_dir}/private/${::fqdn}.pem":
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0600',
            content => $strongswan::certs::node_key,
            notify  => Exec['ipsec-reread'];
        "${strongswan::params::conf_dir}/connections/placeholder.inc":
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => '',
            alias   => 'ipsec-conn-placeholder';
        $strongswan::params::conf_file:
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template("strongswan/${strongswan::params::conf_tmpl}"),
            require => File['ipsec-conn-placeholder'],
            notify  => Service[$strongswan::params::service_name];
        $strongswan::params::secrets_file:
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0600';
    }

    ipsec_secret {
        "${::fqdn}.pem":
            ensure  => present,
            type    => 'rsa',
            notify  => Exec['ipsec-secrets'];
    }
}
