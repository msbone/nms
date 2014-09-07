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
my $include; #TODO We must make this file!

open (NAMED, '>named.conf');

$Main_Domain_filepath = $hostname.".conf";

my $date=localtime;

# FIXME: THIS IS NOT APPRORPIATE!
my $serial = `date +%Y%m%d01`;
chomp $serial;
# FIXME


$named_conf = "
;MADE WITH make_dns.pl at $date\n;DO NOT EDIT MANUAL, UNLESS YOU ARE OLE\n
acl vlan-nett {$vlan_nett};
acl ns-xfr {$transfer}
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

include named.conf.default-zones
";

print NAMED $named_conf;
close (NAMED);
print "Generated named.conf\n";

$maindomain .= "
; Generated by make_dns.pl at $date;
; This file should be okey to edit and is only generated if the file exist :)

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

unless (-e $Main_Domain_filepath) {open (MAINDOMAIN, ">$hostname.conf"); print MAINDOMAIN $maindomain; print "Generated $hostname.conf\n"; close (MAINDOMAIN);}