#!/usr/bin/perl
use DBI;
require "config.pm";


#Tilgjenlige switcher
my $port24 = 10;
my $port16 = 13;
my $port8 = 3;

my $port24_igjen = $port24;
my $port16_igjen = $port16;
my $port8_igjen = $port8;

#La oss hente ifra salkartet ifra mysql
$dbh = DBI->connect("dbi:mysql:$nms::config::db_name",$nms::config::db_username,$nms::config::db_password) or die "Connection Error: $DBI::errstr\n";
$sql = "select * from salkart";
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";

  while (my $ref = $sth->fetchrow_hashref()) {
    $row = $ref->{'radnr'};

print "Rad: ".$row."\n";
$deltagere_igjen = $ref->{'deltagere'};
$total_ports = 0;
$switch_number = 0;

while ($deltagere_igjen >= 0) {
  if($port16_igjen < 0 or $deltagere_igjen > 20 and $port24 > 0 or $port8_igjen == 0 and $port16_igjen == 0) {
    print "24porter\n";
    $deltagere_igjen = $deltagere_igjen - 23;
    $total_ports = $total_ports + 23;
    $port24_igjen--;
    $switch_number++;
    $dbh->do("INSERT INTO switches (name,model,rad) VALUES ('E".$row.".".$switch_number."', 'dlink_24p',$ref->{'radnr'})");
  }
  elsif($deltagere_igjen >= 5 and $port16_igjen > 0 or $port8_igjen == 0) {
    print "16porter\n";
    $deltagere_igjen = $deltagere_igjen - 15;
    $total_ports = $total_ports + 15;
    $port16_igjen--;
    $switch_number++;
    $dbh->do("INSERT INTO switches (name,model,rad) VALUES ('E".$row.".".$switch_number."', '16p',$row)");
  }elsif($port8_igjen > 0) {
    print "8porter\n";
    $deltagere_igjen = $deltagere_igjen - 7;
    $total_ports = $total_ports + 7;
    $port8_igjen--;
    $switch_number++;
    $dbh->do("INSERT INTO switches (name,model,rad) VALUES ('E".$row.".".$switch_number."', '8p',$row)");
  }
};
print "Plasser: $ref->{'deltagere'} \n";
print "Totalt porter: $total_ports \n";
  };

$port24_ibruk = $port24-$port24_igjen;
$port16_ibruk = $port16-$port16_igjen;
$port8_ibruk = $port8-$port8_igjen;

  print "Switcher i bruk:
  24porter = $port24_ibruk;
  16porter = $port16_ibruk;
  8porter = $port8_ibruk;
  ";
