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


function CheckLockerExistance() {
	local whichLocker="$1"
	echo "checking ${whichLocker}"
	local status="`sudo docker ps -a | grep -E '.*\s+${whichLocker}\s+$'`"
	if [[ "$status" == "" ]];then
		echo "0: $status"
		return 0;
	else
		echo "1: $status"
		return 1;
	fi
}

function ProxyToLocker() {
	local CMD="$1"
	local DOCKER_PARAMS="$2"
	local USER_PARAMS="$3"
	echo -e "Proxying to locker-docker:"
	echo -e "   ${DIM}sudo docker run ${DOCKER_PARAMS} \"lifegadget/docker-locker\" ${CMD} ${USER_PARAMS}${NORMAL}"
	sudo docker run ${DOCKER_PARAMS} "lifegadget/docker-locker" ${CMD} ${USER_PARAMS}
}

# Management of lifegadget/docker-locker data storage
function locker () {
	if [[ -z "$1" ]];then 
		echo "Usage: locker [name] [cmd]"
		echo ""
		echo "commands include: ls cat load empty pull update-dep hashtag branch status ... and more"
		echo ""
	else
		local locker="${1:=undefined}"
		shift;
		local cmd="${1:=status}"
		shift;
		# For commands proxied through to docker-locker, docker parameters must be set accordingly
		declare -a STATELESS=("ls" "cat" "pull" "update-dep" "hashtag" "status" "branch")
		case " ${STATELESS[*]} " in
			*\ $cmd\ *)
				# Stateless command, therefore remove image after completion
				dockerParams="--volumes-from ${locker} --rm"
				;;
			*)
				# Statefull command ... aka, involved in setting up a locker
				dockerParams="--name ${locker}"
				;;
		esac
		
		# Now segment non-proxy based commands with case and proxy remaining to docker-locker
		case "$cmd" in
			exists)
				if [[ `CheckLockerExistance "$locker"` == 0 ]]; then
					echo -e "The '${locker}' locker ${BOLD}does not exist${NORMAL} on this machine."
				else
					echo -e "The '${locker}' locker ${BOLD}exists ${NORMAL}on this machine."
				fi
				;;
			about)
				AboutLocker
				;;
			*)
				ProxyToLocker "${cmd}" "${dockerParams}" "$@"
				;;
		esac
	fi	
}
