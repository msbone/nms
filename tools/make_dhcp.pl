#!/usr/bin/perl
use DBI;
use Net::Netmask;

require "config.pm";

open (DHCPD, ">$nms::config::isc_dhcp_dir/dhcpd.conf");

my $dhcp_conf;
my $hostname = $nms::config::eventname.".".$nms::config::domain;

my $date=localtime;


$srv_nett = new Net::Netmask ($nms::config::server_nett);
$srv_netmask = $srv_nett->mask();
$srv_subnet = $srv_nett->base();


$dhcp_conf = <<"EOF";
#MADE WITH make_dhcp.pl at $date\n#DO NOT EDIT MANUAL, UNLESS YOU ARE OLE\n
option domain-name "$hostname";
option domain-name-servers $nms::config::pri_v4, $nms::config::sec_v4;
default-lease-time 3600;
max-lease-time 7200;
authoritative;

ddns-update-style interim;
key DHCP_UPDATER {
        algorithm HMAC-MD5.SIG-ALG.REG.INT;
        secret $nms::config::ddns_key;
}

subnet $srv_subnet netmask $srv_netmask {}

EOF

 # Connect to the database.
$dbh = DBI->connect("dbi:mysql:$nms::config::db_name",$nms::config::db_username,$nms::config::db_password) or die "Connection Error: $DBI::errstr\n";
$sql = "select * from netlist WHERE dhcp = 1";
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";

while (my $ref = $sth->fetchrow_hashref()) {
$network = $ref->{'network'}."/".$ref->{'subnet'};
$reserved_ips = $ref->{'dhcp_reserved'};
$name = lc($ref->{'name'});
$desc = "- " . $ref->{'desc'};

$block = new Net::Netmask ($network);

$netmask = $block->mask();
$subnet = $block->base();
$router = $block->nth(1);

if($reserved_ips == 0) {
$first_ip = $block->nth(2);
}
else {
$first_ip = $block->nth($reserved_ips+2);
}

$last_ip = $block->nth(-2);

$dhcp_conf .= "
#$ref->{'name'} $desc

zone $name.$hostname {
        primary 127.0.0.1;
        key DHCP_UPDATER;
}

subnet $subnet  netmask $netmask {
        authoritative;
        option routers $router;
        option domain-name \"$name.$hostname\";
        option domain-name \"$name.$hostname\";
        range $first_ip $last_ip;
        ignore client-updates;
}
";
  }

print DHCPD $dhcp_conf;
close (DHCPD);
print "Generated $nms::config::isc_dhcp_dir/dhcpd.conf\n";
