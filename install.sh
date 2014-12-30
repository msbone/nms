echo "Downloading NMS"
apt-get install -y unzip
mkdir /SLMS/
cd /SLMS/
wget https://github.com/msbone/nms/archive/master.zip
unzip master.zip;
echo "FILES DOWNLOADED"
perl generate_config.pl
