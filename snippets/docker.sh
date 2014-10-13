#!/bin/bash

function into () {
	if [[ -z "$1" ]]; then
		echo "Usage:"
		echo "   into [image-id]"
		echo ""
		echo "Current Images: [sudo docker images]"
		echo ""
		sudo docker images
	else
		echo "Jumping into Docker Image:"
		echo "  - sudo docker run -it --entrypoint=\"/bin/bash\" \"$1\""
		sudo docker run -it --entrypoint="/bin/bash" "$1"
	fi
}

function killstalecontainers () {
	echo "Killing Docker containers which have exited"
	echo " - sudo docker ps -a | grep Exit | awk '{print $1}' | sudo xargs docker rm"
	echo
	sudo docker ps -a | grep Exit | awk '{print $1}' | sudo xargs docker rm
}

function homeless () {
	echo "Images without a repository [sudo docker images]:"
	echo ""
	sudo docker images | awk '{print $1,$3,$4,$5,$6}' |grep "<none>" | awk '{print $2, " - ", $3,$4,$5}'
	if [[ -z "$1" ]]; then
		echo ""
		echo "use 'homeless kill' to eliminate to remove these images"
	elif [[ $1 = "kill" ]]; then
		echo ""
		echo "killing all homeless images (aka, those with no repository)"
		sudo docker images | awk '{print $1,$3}' |grep "<none>" | awk '{print $2}' | sudo xargs docker rmi
	else
		echo ""
		echo "unknown parameter: $1"
	fi
}

function container () {
	if [[ -z "$1" ]];then
		echo "You must supply the container-id (or name)"
	else
		PID=`sudo docker inspect --format "{{ .State.Pid }}" $1`
		echo "Process ID is "$PID
		sudo nsenter --target "$PID" --mount --uts --ipc --net --pid
	fi
}

function locker () {
	if [[ -z "$1" ]];then 
		echo "Usage: locker [name] [cmd]"
		echo ""
		echo "commands include 'ls', 'update', 'status', etc."
		echo ""
	fi

	locker="$1"
	if [[ -z "$2" ]];then
		command="status"
	else
		command="$2"
	fi
	
	sudo docker run --volumes-from ${locker} \
		"lifegadget/docker-locker" \
		${command} "$3"
}

# SPECIFIC CONTAINER START/STOP OPERATIONS


