#THE SCRIPTS THAT HANDELS ALL THE OTHERS
my $start_run = time();
use Net::Telnet::Cisco;
use Net::Telnet;
my $cisco = Net::Telnet::Cisco->new(Host => '213.184.213.4');
$cisco->login('<REMOVED>', '<REMOVED>');
 
		my $hp = new Net::Telnet(Timeout    => 5,
                                  Telnetmode => 0,
                                  Prompt     => '/C2.*?# /',
                                  Host       => "213.184.213.5"
        );
    $hp->waitfor('/Password: /');
    $hp->print("<REMOVED>");
$hp->waitfor('/C2.*?# /');
$hp->cmd("conf t");

my $switch = 0;

#FIRST LOAD THE FILE WITH ALL THE SWITCHES THAT NEED CONFIG
open (SWITCHES, 'switches_managed.txt');
while (<SWITCHES>) {
$switch++;
chomp;
$line = $_;
        $first = substr($line, 0, 1);
		if($first eq "#") {$core++;}else{
		my ($ip, $port,$vlan, $name) = split(' ', $line, 4);
		if($core == 1) {
		#CISCO CONFIG
		if ($cisco->enable("Data13Party") ) {
		$cisco->cmd("clear arp-cache");
		print "Config switch ".$name. " on port ".$port."\n";
		$cisco->cmd("conf t");
		$cisco->cmd("interface giga 0/".$port);
		$cisco->cmd("no shut");
		$cisco->cmd("switchport mode access");
		$cisco->cmd("switchport access vlan 1337");
		$cisco->cmd("desc CONF-MODE");
		#The switch should be ready to get config
		sleep(35);
		print("Pushing config\n");
		system("/usr/bin/perl /home/tech/edge-conf/push-config.pl ");
		sleep(80);
		#The switch should be ready to set IP
		print("Trying to set IP\n");
		system("/usr/bin/perl /home/tech/edge-conf/set-ip.pl ".$ip);
		$cisco->cmd("switchport access vlan ".$vlan);
		$cisco->cmd("desc MANAGED-".$name);
		$cisco->cmd("exit");
		$cisco->cmd("exit");
		$cisco->cmd("clear arp-cache");
		}
		}
		if($core == 2) {
		#HP CONFIG
print "Config switch ".$name. " on port ".$port."\n";	
$hp->cmd("vlan 1337");
$hp->cmd("untagged ".$port);
sleep(30);
$hp->print("telnet 10.90.90.90");
sleep(1);
$hp->print("admin");
sleep(1);
$hp->print("admin");
$hp->print("config ipif System ipaddress 10.90.90.90 255.0.0.0 gateway 10.90.90.10");
sleep(2);
$hp->print("logout");
#The switch should be ready to get config
sleep(5);
		print("Pushing config\n");
		system("/usr/bin/perl /home/tech/edge-conf/push-config.pl ");
		sleep(80);
		#The switch should be ready to set IP
		print("Trying to set IP\n");
		system("/usr/bin/perl /home/tech/edge-conf/set-ip.pl ".$ip);
		$hp->cmd("no untagged ".$port);
		$hp->cmd("exit");
		$hp->cmd("vlan ".$vlan);
		$hp->cmd("untagged ".$port);
		}
		}
}
$switch = $switch - $core;
my $end_run = time();
my $run_time = $end_run - $start_run;
print "\n".$switch." switches in ".$run_time." secounds\n";