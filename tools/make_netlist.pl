#!/usr/bin/perl
use DBI;

require "config.pm";

my $net_list;

 # Connect to the database.
$dbh = DBI->connect("dbi:mysql:$nms::config::db_name",$nms::config::db_username,$nms::config::db_password) or die "Connection Error: $DBI::errstr\n";
$sql = "select * from netlist";
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";

  while (my $ref = $sth->fetchrow_hashref()) {
$net_list .= "$ref->{'network'} $ref->{'subnet'} $ref->{'name'}\n";
  }

print $net_list;
