#!/usr/bin/perl
use DBI;
use POSIX qw(ceil);
use Net::Netmask;

#This script will set switch to core and give an port
require "config.pm";

my $patch_list;
open (PATCHLIST, '>patchlist.txt');


$distros = scalar(@nms::config::distrobox_ips);

$dbh = DBI->connect("dbi:mysql:$nms::config::db_name",$nms::config::db_username,$nms::config::db_password) or die "Connection Error: $DBI::errstr\n";
$sql = "select * from salkart";
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";

my $antall_rader = $rows = $sth->rows;
my $rad_teller = 0;
my $dist_nr = 1;
$switcher_kvardist = ceil($antall_rader/$distros);

  while (my $ref = $sth->fetchrow_hashref()) {
    $current_row = $ref->{'radnr'};

    $rad_teller++;
    print "Rad: $current_row pa dist$dist_nr\n";
    $dbh->do("UPDATE switches SET core = $dist_nr WHERE rad = $current_row");
    if($rad_teller >= $switcher_kvardist) {
      $rad_teller=0;
      $dist_nr++;
    }
  }

  #CORE ER SATT I SWITCHES DB NEXT SET PORT
  $sql = "select * from switches WHERE core != 0";
  $sth = $dbh->prepare($sql);
  $sth->execute or die "SQL Error: $DBI::errstr\n";

while (my $ref = $sth->fetchrow_hashref()) {
  $switch_id = $ref->{'id'};

  unless($ref->{'core'} == $last_core) {
    $current_port = 0;
  }
  $current_port++;
  print $ref->{'name'}." at ".$current_port."\n";
  $dbh->do("UPDATE switches SET core_port = 'Gi0/$current_port' WHERE id = $switch_id");
  $patch_list .= "$ref->{'core'} Gi0/$current_port $ref->{'name'}\n";

  $last_core = $ref->{'core'};
}

 #LA OSS SETTE DET PA ET NETTVERK - HER MÅ VI TENKE ANTALL DELTAGERE OG IKKE ANTALL SWITCHER

 #Hente ut tilgjenlige nettverk
 $sql = "SELECT * from netlist WHERE de = 1";
 $sth = $dbh->prepare($sql);
 $sth->execute or die "SQL Error: $DBI::errstr\n";

while (my $ref = $sth->fetchrow_hashref()) {

  $network = $ref->{'network'}."/".$ref->{'subnet'};
  $block = new Net::Netmask ($network);

  $ledige_ip = $block->size();

  $net_id = $ref->{'id'};

$sql1 = "SELECT switches.name, switches.core, switches.model, switches.net_id, switches.id AS swid, salkart.deltagere, salkart.radnr from switches JOIN salkart WHERE switches.rad = salkart.radnr";
$sth1 = $dbh->prepare($sql1);
$sth1->execute or die "SQL Error: $DBI::errstr\n";

while (my $ref1 = $sth1->fetchrow_hashref()) {

  $switch_id = $ref1->{'swid'};
  if($last_rad == $ref1->{'radnr'} and $ref1->{'net_id'} == 0) {
    #Samme rad
    print $ref1->{'name'}." til nettverk ".$ref->{'network'}."\n";
    $dbh->do("UPDATE switches SET net_id = $net_id WHERE id = $switch_id");
  }
  elsif($ref1->{'net_id'} == 0) {
    #Ny rad
    if($ledige_ip > $ref1->{'deltagere'}) {
      $ledige_ip = $ledige_ip - $ref1->{'deltagere'};
      $last_rad = $ref1->{'radnr'};
      print $ref1->{'name'}." til nettverk ".$ref->{'network'}."\n";
      $dbh->do("UPDATE switches SET net_id = $net_id WHERE id = $switch_id");
    }
  }
}
$ledig_ip = $ledig_ip;
print $ref->{'network'}.": ".$ledige_ip."/".$block->size()."\n";
}

print PATCHLIST $patch_list;
close (PATCHLIST);
