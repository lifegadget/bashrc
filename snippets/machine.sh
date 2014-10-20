#!/bin/bash
# Vagrant Machine Manager
# -----------------------

function stopStash() {
	sudo docker stop logstash
	sudo docker rm logstash
}

function startStash() {
	sudo docker run -d \
		--name logstash \
		--volumes-from logdata \
		-p 9292:9292 \
		-p 9200:9200 \
		"lifegadget/logstash-server" \
		start
	
	listRunning;
}

function runStateless() {
	sudo docker run --rm \
		--volumes-from logdata \
		--volumes-from logstash \
		"lifegadget/logstash-server"
		$2
}

function listRunning() {
	echo "";
	echo "Running docker instances:"
	echo "-------------------------"
	sudo docker ps
}

function buildStash() {
	sudo docker build -t "lifegadget/logstash-server" ~/repos/mine/docker-logstash-server
}

echo "COMMAND: $1"

case "$1" in
	stop)
		stopStash;
		;;
	start)
		startStash;
		;;
	restart)
		stopStash;
		startStash;	
		;;
	build)
		buildStash;
		;;
	cycle)
		stopStash;
		buildStash;
		startStash;
		;;
	*)
		echo "Running a stateless command: $1"
		runStateless $@
		;;
esac