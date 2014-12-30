#! /usr/bin/perl
use POSIX;
use strict;
use warnings;


my $year = 14;

my %months = (
Jan => 1,
Feb => 2,
Mar => 3,
Apr => 4,
May => 5,
Jun => 6,
Jul => 7,
Aug => 8,
Sep => 9,
Oct => 10,
Nov => 11,
Dec => 12
);

my ($dbh, $q, $cq);
open(SYSLOG, "tail -n 100 -F /var/log/syslog |") or die "Unable to tail syslog: $!";
while (<SYSLOG>) {
/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+(\d+)\s+(\d+:\d+:\d+).*DHCPACK on (\d+\.\d+\.\d$
my $date = $year . "-" . $months{$1} . "-" . $2 . " " . $3;
my $machine = $5;

print "$date - $4\n";
}
close SYSLOG;
