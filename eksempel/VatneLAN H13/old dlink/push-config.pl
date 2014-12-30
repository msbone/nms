use Net::Telnet;

$myIPaddress = "10.90.90.90";
$telnet = new Net::Telnet ( Timeout=>10,Errmode=>'die');
$myDefaultPassword = 'admin';
$myUsername = "admin";

$telnet->open("$myIPaddress");
$telnet->waitfor('/DGS-1210-28 login: $/i');
$telnet->print("$myUsername");
$telnet->waitfor(-match => '/Password: $/i',
                      -errmode => "return")
            or die "problem connecting to host: ", $telnet->lastline;
$telnet->print("$myDefaultPassword");
$telnet->waitfor(-match => '/DGS-1210-28> ?$/i',-errmode => "return")
or die "login failed: ", $telnet->lastline;
$telnet->print("download cfg_fromTFTP 192.168.1.142 config.bin");
