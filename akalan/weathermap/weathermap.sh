#!/bin/bash
sleep 5
NOW=$(date +"%T-%m-%d")
cd /weathermap/

php weathermap
cp weathermap.png timelapse/$NOW.png
cp weathermap.png /stats/now.png
