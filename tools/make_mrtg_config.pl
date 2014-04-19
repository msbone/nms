#!/usr/local/bin/perl

#NEEDS SWITCHES.TXT

#GENERATES make_graph.sh, index.html


open (MYFILE, 'switches.txt');
open (GRAPH, '>make_graph.sh');
open (HTML, '>index.html');

$core = 0;

$core1 = "213.184.213.4_";
$core2 = "213.184.213.5_";

$writing_config = "#THIS FILE IS AUTOGENRATED BY make_mrtg_config.pl";
$writing_html = "<!--THIS FILE IS AUTOGENRATED BY make_mrtg_config.pl-->";

while (<MYFILE>) {
        chomp;
        $line = $_;
		
        $first = substr($line, 0, 1);
		
		if($first eq "#") {
		$core++;
		}
		
        else {
#comments removed
my ($port, $name) = split(' ', $line, 2);
#Here we will generate the config!
if($core == 1) {
$config_core = $core1;
}
if($core == 2) {
$config_core = $core2;
}

$config = '
rrdtool graph /var/www/mrtg/'.$name.'.png \
--start=-3600 \
--title="'.$name.'" \
--rigid \
--base=1000 \
--height=90 \
--width=550 \
--alt-autoscale-max \
--lower-limit=0 \
--vertical-label="bits per second" \
--slope-mode \
--font TITLE:12: \
--font AXIS:8: \
--font LEGEND:10: \
--font UNIT:8: \
DEF:inbytes="/var/www/mrtg/'.$config_core.$port.'.rrd":ds0:AVERAGE \
DEF:outbytes="/var/www/mrtg/'.$config_core.$port.'.rrd":ds1:AVERAGE \
"CDEF:a=inbytes,8,*" \
"CDEF:b=outbytes,8,*" \
AREA:a#00CF00FF:"Inbound"  \
GPRINT:a:LAST:" Current\:%8.2lf %s"  \
GPRINT:a:AVERAGE:"Average\:%8.2lf %s"  \
GPRINT:a:MAX:"Maximum\:%8.2lf %s\n"  \
LINE1:b#002A97FF:"Outbound"  \
GPRINT:b:LAST:"Current\:%8.2lf %s"  \
GPRINT:b:AVERAGE:"Average\:%8.2lf %s"  \
GPRINT:b:MAX:"Maximum\:%8.2lf %s\n"
';

$html = '
<img src="http://srv01.vl13.vatnelan.net/mrtg/'.$name.'.png" alt="'.$name.'">
';

$writing_html .= $html;
$writing_config .= $config;
}
 }
 
 print GRAPH $writing_config;
 print HTML $writing_html;
 
 close (GRAPH);
 close (HTML);
 close (MYFILE);
