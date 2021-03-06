#!/bin/bash

echo "Stopping webserver and PHP"
echo "--------------------------"
sudo docker stop webserver
sudo docker stop PHP
sudo docker stop CB
sudo docker rm webserver
sudo docker rm PHP
sudo docker rm CB

if [[ "$1" = "build" ]]; then
	echo "Building PHP";
	sudo docker build -t "lifegadget/docker-php" ~/repos/mine/docker-php
	echo "Build webserver";
	sudo docker build -t "lifegadget/docker-nginx" ~/repos/mine/docker-nginx
elif [[ "$1" = "PHP" ]]; then
	echo "Building PHP";
	sudo docker build -t "lifegadget/docker-php" ~/repos/mine/docker-php
elif [[ "$1" = "webserver" ]]; then
	echo "Build webserver";
	sudo docker build -t "lifegadget/docker-nginx" ~/repos/mine/docker-nginx
elif [[ "$1" = "couchbase" ]]; then
	echo "Build couchbase";
	sudo docker build -t "lifegadget/docker-couchbase" ~/repos/mine/docker-couchbase
else
	echo "Not rebuilding ..."
fi

echo "Starting services ..."
echo "---------------------"
sudo docker run -d -p 11210:11210 -p 8091:8091 -p 8092:8092 \
	--name=CB \
	lifegadget/docker-couchbase \
	create
sudo docker run -d --name PHP --link CB:CB lifegadget/docker-php
sudo docker run -d --name webserver --link PHP:PHP -p 80:80 lifegadget/docker-nginx

sudo docker ps