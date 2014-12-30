#!/usr/bin/perl
use DBI;


print "Generate config \n";
print "Longname of event \n";
$eventname = <>;
print "Shortname of event \n";
$shortname = <>;
print "Domain of event \n";
$domain = <>;
print "Name of pri server \n";
$pri_server = <>;
print "IP of pri server \n";
$pri_server_ip = <>;
print "Name of sec server \n";
$sec_server = <>;
print "IP of sec server \n";
$sec_server_ip = <>;
print "Database root user \n";
$db_user = <>;
print "Database root password \n";
$db_password = <>;
print "We will now make the databases and stuff"





$config = <<"EOF";

#! /usr/bin/perl
package nms::config;

our $fullname = "$eventname";
our $eventname = "$shortname";
our $domain = "$domain";

our $pri_hostname = "$pri_server";
our $pri_v4 = "$pri_server_ip";

our $sec_hostname = "$sec_server";
our $sec_v4   = "$sec_server_ip";

our $db_name = "vlan";
our $db_host = "bird";
our $db_username = "root";
our $db_password = "<REMOVED>";

our $isc_dhcp_dir = "/etc/dhcp/";
our $bind9_dir = "/etc/bind9";

our $dhcp_server = $pri_v4;

our $ios_user = "vlan";
our $ios_pass = "<REMOVED>";

our @distrobox_ips = (
'213.184.213.12', # dist01
'213.184.213.13', # dist02
);

our $snmp_community = "<REMOVED>";

our $dlink_user = "admin";
our $dlink_passwd = "<REMOVED>";

our $server_nett = "192.168.1.0/24"; #USED IN DHCP

our $nett = "213.184.213.0/24; 213.184.214.0/23; 10.0.0.0/24;"; #used in dns

# To generate new dnssec-key for ddns:
# dnssec-keygen -a HMAC-MD5 -b 128 -n HOST DHCP_UPDATER
our $ddns_key = "<REMOVED>";

EOF
