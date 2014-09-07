#! /usr/bin/perl
package nms::config;

our $eventname = "vl14";
our $domain = "vatnelan.net";

our $pri_hostname = "bird";
our $pri_v4 = "213.184.213.18";

our $sec_hostname = "fish";
our $sec_v4   = "213.184.213.19";

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
