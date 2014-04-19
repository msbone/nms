#!/bin/bash
sleep 5
NOW=$(date +"%T-%m-%d")

cd /web/weathermap/
./weathermap

cp weathermap.png /web/weathermap/timelapse/$NOW.png
cp weatherman.png /web/weathermap/web/now.png