use strict;
use warnings;
use Net::Telnet::Cisco;

package ciscoconf;

my $session;

my $name;

sub connect {
   my $class = shift;
   my $self = bless {}, $class;
   my %args = @_;
  $session = Net::Telnet::Cisco->new(Host => '192.168.1.242');
   $session->login($args{username}, $args{password});
   
     if ($session->enable($args{enable_password}) ) {
  } else {
      warn "Can't enable: " . $session->errmsg;
  }
  $name = $args{hostname};
  return $self; 
}

sub setvlan {
my $self = shift;
my %args = @_;
#Set a port at a vlan
$session->cmd("clear arp-cache");
$session->cmd("conf t");
$session->cmd("interface gigabit 0/".$args{port});
$session->cmd("switchport mode access");
$session->cmd("switchport access vlan ".$args{vlan});
$session->cmd("desc ".$args{desc});
$session->cmd("exit");
$session->cmd("exit");
print $name.": port ". $args{port}. " set to vlan ".$args{vlan}."\n";
}

1;
