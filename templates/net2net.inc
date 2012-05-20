# Puppet managed IPsec connection
conn <%= title %>
	left		= <%= local_ip %>
	leftsourceip	= <%= local_net_ip %>
	leftsubnet	= <%= local_net %>
	leftcert	= <%= local_cert %>
	right		= <%= remote_ip %>
	rightsubnet	= <%= remote_net %>
	rightid		= "<%= remote_id %>"
	keyexchange	= ikev<%= ike_version %>
	dpdaction	= hold
	dpddelay	= 10s
	dpdtimeout	= 60s
	keyingtries	= %forever
	compress	= <%= compress %>
	mobike		= <%= mobike %>
	pfs		= <%= pfs %>
	auto		= start

