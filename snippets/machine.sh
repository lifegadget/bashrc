#!/bin/bash
# Vagrant Machine Manager
# -----------------------

configFile="machine-example.conf"
configuration=`cat $configFile`
lockers=`echo $configuration | jsawk 'return this.lockers'`
infrastructure=`echo $configuration | jsawk 'return this.infrastructure'`
declare -A DICTIONARY
declare -a BASH_ARRAY

# ensure that bash is on 4.x version
function validateBashVersion() {
	bashVersion;
	if [[ "${BASH_MAJOR}" -lt 4 ]]; then
		echo -e "${BOLD}${RED}ERROR:${NORMAL} you must use at least version ${GREEN}4.x${NORMAL} of bash to use this script!"
		echo -e "\t${DIM}- this system is currently using version ${BASH_VERSION}${NORMAL}"
		echo ""
		exit 1
	fi
}

function bashVersion() {
	BASH_VERSION=`bash --version | sed 1q | cut -d' ' -f4`
	BASH_MAJOR=`echo ${BASH_VERSION} | cut -d'.' -f1`
	BASH_MINOR=`echo ${BASH_VERSION} | cut -d'.' -f2`
	BASH_BUILD=`echo ${BASH_VERSION} | cut -d'.' -f3`
}

#converts JSON dictionary into associative array
function getDictionary() {
	local json="$1" 
	shift # get rid of json input off of stack
	if [[ "${json:0:1}" == "[" ]]; then
		json=${json:1:-1} # strips off array characters so can operate on just object
	fi
	getDictionaryKeys $json;
	for key in $KEYS; do
		local value=`echo $json | jsawk "return this.${key}"`
		DICTIONARY["$key"]="${value}"
	done
	return 0
}

function getDictionaryKeys() {
	local json="$1"
	KEYS=`echo $json | jsawk -n 'out(_.keys(this))'`
	KEYS="${KEYS//\"}" # strip out quotation marks
	KEYS=`echo "${KEYS:1:-1}" | tr ',' '\n'` # get rid of array markers and convert commas to newlines
}

# Converts a JSON array to a bash array
function getArray() {
	local json="$1" 
	# ensure it looks like a JSON array
	if [[ "json:0:1}" == "[" ]];then
		BASH_ARRAY=`echo "json:1:-1}" | tr ',' '\n'`
	else 
		# doesn't look like it was an array so just return the value
		BASH_ARRAY="${json}"
	fi
}

# list the lockers that this machine has
function machineInventory() {
	verbose=0
	output="text"
	while getopts ":vco:" opt; do
	    case $opt in 
	        v) 
				verbose=1
	            ;;
	        o)
				if [[ "$OPTARG" == "json" ]];then
					output="json"
				fi
				;;
			c)
				# remove color/highlighting from output
				BOLD=""
				NORMAL=""
				DIM=""
				;;
	        \? ) echo "usage: inventory [-v] [-o json|text] "
	             exit 1
	    esac
	done
	
	if [[ $verbose == 1 ]]; then 
		echo ""
		echo -e "${BOLD}Lockers${NORMAL} on this machine:"
		echo "------------------------"
		lockerList=`echo ${lockers} | jsawk -n 'out(this.id)'`
		for locker in $lockerList; do
			echo -e "LOCKER: ${BOLD}${locker}${NORMAL}"
			container=`echo "${lockers}" | jsawk -q "[?(id='${locker}')]"`
			getDictionary "${container}";
			for property in $KEYS; do
				echo -e "  - ${property}: ${DIM}${DICTIONARY[${property}]}${NORMAL}"
			done;
		done
		echo ""
		echo -e "${BOLD}Infrastructure${NORMAL} on this machine:"
		echo "-------------------------------"
		echo $infrastructure | jsawk 'return this.id'
	else
		echo "${lockers}" | jsawk -n 'out(this.id)'
		echo "$infrastructure" | jsawk -n 'out(this.id)'
	fi
}

# load all lockers with content and run any needed prep
function loadLockers() {
	echo ""
	echo "Loading all Lockers associated with this machine:"
	echo "-------------------------------------------------"
	lockerList=`echo "$lockers" | jsawk -n 'out(this.id)'`
	for locker in lockerList; do
		echo "$lockerList"
	done
	
}


validateBashVersion;
case "$1" in 
	inventory)
		shift;
		machineInventory $@;
	;;
	init)
		loadLockers;
	;;
esac
