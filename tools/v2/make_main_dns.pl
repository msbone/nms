#!/usr/bin/perl
use DBI;
use Net::Netmask;

require "config.pm";
my $hostname = $nms::config::eventname.".".$nms::config::domain;
my $vlan_nett = "$nms::config::nett 127.0.0.0/8; ::1;";
my $transfer = "$nms::config::pri_v4; $nms::config::sec_v4;";
my $secret = $nms::config::ddns_key;

my $main_srv = $nms::config::pri_hostname;
my $main_srv_ip = $nms::config::pri_v4;

my $sec_srv = $nms::config::sec_hostname;
my $sec_srv_ip = $nms::config::sec_v4;

#END OF CONFIG

my $named_conf;
my $maindomain;
my $master_conf;

open (NAMED, ">$nms::config::bind9_dir/named.conf");
open (MASTER_CONF, ">$nms::config::bind9_dir/named.master.conf");

#La oss lage mapper i bind mappa
eval { mkpath("$nms::config::bind9_dir/dynamic") };
eval { mkpath("$nms::config::bind9_dir/reverse") };


$Main_Domain_filepath = "$nms::config::bind9_dir/".$hostname.".zone";

my $date=localtime;

# FIXME: THIS IS NOT APPRORPIATE!
my $serial = `date +%Y%m%d01`;
chomp $serial;
# FIXME


$named_conf = "
// MADE WITH make_dns.pl at $date\n// DO NOT EDIT MANUAL, UNLESS YOU ARE OLE\n
acl vlan-nett {$vlan_nett};
acl ns-xfr {$transfer};
options {
        directory \"/etc/bind\";
        allow-recursion { vlan-nett; };
        allow-query { any; };
        allow-transfer { ns-xfr; };
        recursion yes;
        auth-nxdomain no;
        listen-on-v6 { any; };
};

key DHCP_UPDATER {
        algorithm HMAC-MD5.SIG-ALG.REG.INT;
        secret $secret;
};

zone \"$hostname\" {
type master;
file \"$hostname.zone\";
notify yes;
allow-transfer { ns-xfr; };
};

include \"named.master.conf\";
include \"named.conf.default-zones\";
";

print NAMED $named_conf;
close (NAMED);
print "Generated $nms::config::bind9_dir/named.conf\n";

$maindomain .= "
; Generated by make_dns.pl at $date;
; This file should be okey to edit and is only generated if the file not exist :)

\$TTL 3600
@	IN	SOA	$main_srv.$hostname.	ole_mathias.sdok.no. (
			$serial; serial
			3600 ; refresh
			1800 ; retry
			608400 ; expire
			3600 ) ; minimum and default TTL

		IN	NS  $main_srv.$hostname.
		IN	NS  $sec_srv.$hostname.

$main_srv		IN	A	$main_srv_ip
$sec_srv		IN	A	$sec_srv_ip
ns1		IN	CNAME	$main_srv.$hostname.
ns2		IN	CNAME	$sec_srv.$hostname.

; Servers
";
unless (-e $Main_Domain_filepath) {open (MAINDOMAIN, ">$Main_Domain_filepath"); print MAINDOMAIN $maindomain; print "Generated $Main_Domain_filepath\n"; close (MAINDOMAIN);}




# MAKE THE named.master.conf
$dbh = DBI->connect("dbi:mysql:$nms::config::db_name",$nms::config::db_username,$nms::config::db_password) or die "Connection Error: $DBI::errstr\n";
$sql = "select * from netlist";
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";

my @all_rev;

while (my $ref = $sth->fetchrow_hashref()) {
  $network_hostname = lc($ref->{'name'}).".".$hostname;
  $base_network_sql = $ref->{'network'};

  my ($t, $s, $p) = (split(/[.!]/, $base_network_sql));

my $rev_zone = $p.".".$s.".".$t. ".in-addr.arpa";;

$master_conf .= "
zone \"$network_hostname\" {
        type master;
        notify yes;
        allow-update { key DHCP_UPDATER; };
        file \"dynamic/$network_hostname.zone\";
        allow-transfer { ns-xfr; };
};
";

#Opprette base config
$base_config_filepath = "$nms::config::bind9_dir/dynamic/$network_hostname.zone";
unless (-e $base_config_filepath) {open (baseconf, ">$base_config_filepath"); print baseconf
"; Generated by make_dns.pl at $date;
; This file should be okey to edit and is only generated if the file not exist :)

\$TTL 3600
@	IN	SOA	$main_srv.$hostname.	ole_mathias.sdok.no. (
      $serial; serial
      3600 ; refresh
      1800 ; retry
      608400 ; expire
      3600 ) ; minimum and default TTL

    IN	NS  $main_srv.$hostname.
    IN	NS  $sec_srv.$hostname.

ns1		IN	CNAME	$main_srv.$hostname.
ns2		IN	CNAME	$sec_srv.$hostname.
";
print "Generated $base_config_filepath\n";
close (baseconf);}

unless($rev_zone ~~ @all_rev) {
  push(@all_rev, $rev_zone);
  $master_conf .= "
  zone \"$rev_zone\"	{
      type master;
      allow-update { key DHCP_UPDATER; };
      notify yes;
      allow-transfer { ns-xfr; };
      file \"reverse/$rev_zone.zone\";
  };";

#Opprette base rev config
$base_config_filepath = "$nms::config::bind9_dir/reverse/$rev_zone.zone";
unless (-e $base_config_filepath) {open (baseconf, ">$base_config_filepath"); print baseconf
"; Generated by make_dns.pl at $date;
; This file should be okey to edit and is only generated if the file not exist :)

\$TTL 3600
@	IN	SOA	$main_srv.$hostname.	ole_mathias.sdok.no. (
      $serial; serial
      3600 ; refresh
      1800 ; retry
      608400 ; expire
      3600 ) ; minimum and default TTL

$rev_zone.   IN	NS  $main_srv.$hostname.
$rev_zone.    IN	NS  $sec_srv.$hostname.
";
print "Generated $base_config_filepath\n";
close (baseconf);}  
}
}

print MASTER_CONF $master_conf;
print "Generated $nms::config::bind9_dir/named.master.conf\n";
close (MASTER_CONF);
