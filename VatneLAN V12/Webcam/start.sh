#!/bin/bash 
sudo screen -d -m ffserver

sudo screen -d -m ffmpeg -loglevel quiet -r 5 -s 1280x720 -f video4linux2 -i /dev/video0 http://localhost:8090/feed1.ffm sondag.avi
