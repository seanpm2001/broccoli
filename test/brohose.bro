# Depending on whether you want to use encryption or not,
# include "listen-clear" or "listen-ssl":
#
# @load frameworks/communication/listen-ssl
@load frameworks/communication/listen-clear

global brohose_log = open_log_file("brohose");

# Let's make sure we use the same port no matter whether we use encryption or not:
#
@ifdef (Communication::listen_port_clear)
redef Communication::listen_port_clear    = 47758/tcp;
@endif

# If we're using encrypted communication, redef the SSL port and hook in
# the necessary certificates:
#
@ifdef (Communication::listen_port_ssl)
redef Communication::listen_port_ssl      = 47758/tcp;
redef ssl_ca_certificate   = "<path>/ca_cert.pem";
redef ssl_private_key      = "<path>/bro.pem";
@endif

redef Communication::nodes += {
	["brohose"] = [$host = 127.0.0.1, $events = /brohose/, $connect=F, $ssl=F]
};

event brohose(id: string) {
	print brohose_log, fmt("%s %s", id, current_time());
}
