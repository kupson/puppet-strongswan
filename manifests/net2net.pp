# Define: net2net
#
# Define a network to network IPsec tunnel
#
# Parameters:
# 
#   [*ensure*] - present|absent
#
# Actions:
#
# Requires:
#
# Sample Usage:
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

    $facter_iface = regsubst($local_iface, '-', '_', 'G')

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
