# Define: net2net
#
# Define a network to network IPsec tunnel
#
# Parameters:
# 
#   [*ensure*]      - *present*|absent
#   [*local_ip*]    - local IP for IPsec packets (instead of default route source IP) *%defaultroute*|<IP address>
#   [*local_iface*] - local subnet network interface (setup tunnel to network on this interface)
#   [*local_cert*]  - local certificate file name (defaults to auto-generated one)
#   [*remote_ip*]   - remote host IP
#   [*remote_net*]  - remote network (to reach by IPsec tunnel)
#   [*remote_fqdn*] - fully qualified domain name of remote host
#   [*ike_version*] - IKE version *1*|2
#   [*compress*]    - enable compression yes|*no*
#   [*mobike*]      - enable Mobike (IKEv2 only) yes|*no*
#   [*pfs*]         - Perfect Forward Secrecy *yes*|no
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# include strongswan
#
# strongswan::net2net {
#   local_iface => 'xen-br0',
#   remote_ip   => '192.0.2.13',
#   remote_net  => '10.0.0.0/8',
#   remote_fqdn => 'ipsec.example.net';
# }
#
define strongswan::net2net (
    $ensure       = 'present',
    $local_ip     = '%defaultroute',
    $local_iface,
    $local_cert   = "${::fqdn}.pem",
    $remote_ip,
    $remote_net,
    $remote_fqdn,
    $ike_version  = '1',
    $compress     = 'no',
    $mobike       = 'no',
    $pfs          = 'yes'
) {

    $file_ensure = $ensure ? {
                     "present" => "file",
                     "absent"  => "absent",
                   }

    $facter_iface = regsubst($local_iface, '[.-]', '_', 'G')

    $iface_ip   = inline_template('<%= scope.lookupvar("::ipaddress_" + facter_iface)-%>')
    $iface_net  = inline_template('<%= scope.lookupvar("::network_" + facter_iface)-%>')
    $iface_mask = inline_template('<%= scope.lookupvar("::netmask_" + facter_iface)-%>')
    $iface_cidr = netmask2cidr($iface_mask)

    $local_net_ip = $iface_ip
    $local_net    = "${iface_net}/${iface_cidr}"
    $remote_id    = "CN=${remote_fqdn}"

    file {
        "/etc/ipsec.d/connections/${title}.inc":
            ensure  => $file_ensure,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('strongswan/net2net.inc'),
            notify  => Exec['ipsec-reload'];
    }

#    if $require {
#    }
#
#    if $before {
#    }
#
#    if $notify {
#    }
#
#    if $subscribe {
#    }

}
