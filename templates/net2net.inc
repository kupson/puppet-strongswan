# Puppet managed IPsec connection
conn <%= @title %>
	left		= <%= @local_ip %>
<% if @ike_version.to_s == '1' -%>
	leftsourceip	= <%= @local_net_ip %>
<% end -%>
	leftsubnet	= <%= @real_local_net %>
	leftcert	= <%= @local_cert %>
	right		= <%= @remote_ip %>
	rightsubnet	= <%= @remote_net %>
	rightid		= "<%= @remote_id %>"
	keyexchange	= ikev<%= @ike_version %>
	dpdaction	= hold
	dpddelay	= 10s
	dpdtimeout	= 60s
	keyingtries	= %forever
	compress	= <%= @compress %>
<% if @ike_version.to_s == '2' -%>
	mobike		= <%= @mobike %>
<% end -%>
	pfs		= <%= @pfs %>
	auto		= start

