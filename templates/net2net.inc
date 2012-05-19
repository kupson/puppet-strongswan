# Puppet managed IPsec connection
conn <%= title %>
	left		= <%= local_ip %>
	leftsourceip	= <%= local_net_ip %>
	leftsubnet	= <%= local_net %>
	leftcert	= <%= local_cert %>
	right		= <%= remote_ip %>
	rightsubnet	= <%= remote_net %>
	rightid		= "<%= remote_id %>"
	auto		= start
