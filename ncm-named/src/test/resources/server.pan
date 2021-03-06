@{ Template for testing DNS server configuration by ncm-named }

object template server;

prefix '/software/components/named';

'active' = true;
'dependencies/pre/0' = 'spma';
'dispatch' = true;
'serverConfig' = <<EOF;
// generated by named-bootconf.pl

options {
	directory "/var/named";
	/*
	 * If there is a firewall between you and nameservers you want
	 * to talk to, you might need to uncomment the query-source
	 * directive below.  Previous versions of BIND always asked
	 * questions using port 53, but BIND 8.1 uses an unprivileged
	 * port by default.
	 */
        allow-recursion {
            127.0.0.1;
            134.158.0.0/16;
        };
	// query-source address * port 53;
};

// 
// a caching only nameserver config
// 
controls {
	inet 127.0.0.1 allow { localhost; } keys { rndckey; };
};
zone "." IN {
	type hint;
	file "named.ca";
};

zone "localhost" IN {
	type master;
	file "localhost.zone";
	allow-update { none; };
};

zone "0.0.127.in-addr.arpa" IN {
	type master;
	file "named.local";
	allow-update { none; };
};

include "/etc/rndc.key";


//-----------------

zone "lal.in2p3.fr" {
        type slave;
        file "lal.db";
        masters {
                134.158.88.147;
        };
};
EOF

