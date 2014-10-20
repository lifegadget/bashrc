#!/bin/bash

case "$1" in 
	ls)
		sudo docker run --volumes-from logdata \
			"lifegadget/docker-locker" \
			ls "$2"
		exit 0;
	;;
	*)
		echo "Shutting down logstash data locker"
		echo "----------------------------------"
		sudo docker rm logdata
		echo "Building Locker"
		echo "--------------------"
		sudo docker build -t "lifegadget/docker-locker" ~/repos/mine/docker-locker
		echo "Starting up Locker"
		echo "--------------------"
		sudo docker run --name logdata \
			"lifegadget/docker-locker" \
			empty
	;;
esac	