#!/bin/bash

curl -O https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz

tar zxvf logstash-1.4.2.tar.gz

sudo ./before-install.sh

sudo cp -r /home/\$USER/Downloads/logstash-1.4.2 /opt/logstash

sudo mkdir /var/log/logstash
sudo mkdir /var/lib/logstash

sudo ./after-install.sh

if ! [ $(echo $PATH | grep -c /opt/logstah) -eq 0 ] 
then 
    export PATH+=:/opt/logstash/bin
    echo PATH+=:/opt/logstash >> .bashrc
    source ~/.bashrc
fi
