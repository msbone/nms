#!/bin/bash

db_name = "nms"
db_user = "nms"
db_password = $2
root_password = $1


Q1="CREATE DATABASE IF NOT EXISTS $db_name;"
Q2="GRANT ALL ON $db_name.* TO '$db_user'@'localhost' IDENTIFIED BY '$db_password';"
Q3="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}"

mysql -uroot -p$root_password  -e "$SQL"
mysql -uroot -p$root_password $db_name < nms.sql
