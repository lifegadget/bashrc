# Define a few Color's
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m'        

BOLD='\[\033[1m\]'
BOLD_OFF='[\033[m\]'

# Add Homebrew autocomplete
# source `brew --repository`/Library/Contributions/brew_bash_completion.sh

# Sample Command using color: echo -e "${CYAN}This is BASH ${RED}${BASH_VERSION%.*}${CYAN} - DISPLAY on ${RED}$DISPLAY${NC}\n"

# Source other libraries
source ~/.bashrc

# For Amazon AWS access
export AWS_ACCESS_KEY=
export AWS_SECRET_KEY=
# Complete keys in AWS CLI
complete -C aws_completer aws

function aws_secret() {
	export AWS_SECRET_KEY=$1
}

function newtab {
    TAB_NAME=$1
    COMMAND=$2
	
	osascript \
		-e 'tell application "Terminal" to activate' \
		-e "tell application \"System Events\" to keystroke \"t\" using {command down}" \
		-e "do script \"printf '\\\e]1;$TAB_NAME\\\a'; $COMMAND\" in front window" \
		-e "end tell" > /dev/null
}

function newwindow {
	open -a Terminal "`pwd`"
}

function tabname {
  printf "\e]1;$1\a"
}

function title {
  printf "\e]2;$1\a"
}

# For Amazon EC2 Command Line
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
export EC2_CERT=`ls $EC2_HOME/cert-*.pem`

# Aliases
alias ls='ls -G -F' # add colors and file type extensions
alias ll="ls -l -F"

function phpi() {
	echo "PHP Interactive with Autoloader"
	php -d auto_prepend_file=~/interactive -a
}
function f() {
     find . -type f -exec grep -l $1 {} + ;
}

function breakfast() {
	brunch new https://github.com/ksnyde/brunch-with-ember-sideloaded $1;
	cd $1;
	npm install;
	bower install;
	bower list;
	brunch build;
}

# utility shortcut to display WIFI connection information
function wifi_info () {
	/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I
}

function wifi_diag () {
	open /System/Library/CoreServices/Wi-Fi\ Diagnostics.app
}

# add to path the opt/local/bin for Macports and GIT to the end
PATH=.:/usr/local/sbin:/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH:/Developer/usr/bin:~/pear/bin:/usr/local/share/npm/bin:/Applications/Couchbase\ Server.app/Contents/Resources/couchbase-core/bin:~/lg/api/commandline/bin
export PATH=$PATH

function logging() {
	log.io-server & 
	log.io-harvester &
	open http://localhost:28778
}

function running() {
	SERVICE=$1

	ps -a | grep -v grep | grep $1
	if [ "$?" -ne "0" ]; then
		echo "no processes matching the grep pattern '$SERVICE' are running"
	fi
}

function isRunning() {
	SERVICE=$1

	ps -a | grep -v grep | grep $1  >/dev/null
	if [ "$?" -ne "0" ]; then
		echo "false"
		return 0;
	else
		echo "true"
		return 1;
	fi
}

function listening() {
		lsof -i:$1;
}

function killListener() {
	kill -9 `lsof -i:$1 -t`
}

function pkg-list() {
	echo "PACKAGES INSTALLED"
	pear list -a
	port installed
	#gem list --local
}

function couch-buckets() {
	SERVER=localhost:8091
	echo "Coachbase information for server $SERVER"
	couchbase-cli bucket-list -c $SERVER
}


function path() {
	env | grep PATH
}

function fpm-start() {
	MAJOR=`php-fpm -v | sed 1q | cut -d' ' -f2 | cut -d'.' -f1`
	MINOR=`php-fpm -v | sed 1q | cut -d' ' -f2 | cut -d'.' -f2`
	BUILD_NUM=`php-fpm -v | sed 1q | cut -d' ' -f2 | cut -d'.' -f3`
	echo "Starting PHP FPM server"
	echo "using version $MAJOR.$MINOR of PHP (build $BUILD_NUM)"
	launchctl load -w ~/Library/LaunchAgents/php$MAJOR$MINOR.plist
	echo "---------------------------------------------"
	sleep 1
	ps -ae | grep php-fpm | grep -v grep | grep -v tail
}

function fpm-stop() {
	MAJOR=`php-fpm -v | sed 1q | cut -d' ' -f2 | cut -d'.' -f1`
	MINOR=`php-fpm -v | sed 1q | cut -d' ' -f2 | cut -d'.' -f2`
	BUILD_NUM=`php-fpm -v | sed 1q | cut -d' ' -f2 | cut -d'.' -f3`
	echo "Stopping PHP FPM server"
	launchctl unload -w ~/Library/LaunchAgents/php$MAJOR$MINOR.plist
}

function switch-php() {
	if [ -z "$1" ]; then
		echo "usage: switch-php [major].[minor]"
	else 
		CURRENT_MAJOR=`php-fpm -v | sed 1q | cut -d' ' -f2 | cut -d'.' -f1`
		CURRENT_MINOR=`php-fpm -v | sed 1q | cut -d' ' -f2 | cut -d'.' -f2`
		CURRENT_BUILD_NUM=`php-fpm -v | sed 1q | cut -d' ' -f2 | cut -d'.' -f3`
		echo "Switching versions of PHP from $CURRENT_MAJOR.$CURRENT_MINOR to $1"
		if [ "$1" = "$CURRENT_MAJOR.$CURRENT_MINOR" ]; then
			echo "Already at version $CURRENT_MAJOR.$CURRENT_MINOR. Nothing to do."
		else
			NEW_MAJOR=`echo $1 | cut -d'.' -f1`
			NEW_MINOR=`echo $1 | cut -d'.' -f2`
			brew unlink php$CURRENT_MAJOR$CURRENT_MINOR && brew unlink php$NEW_MAJOR$NEW_MINOR
			brew link --overwrite php$NEW_MAJOR$NEW_MINOR
		fi
	fi
}


function short() {

     echo "Shortcuts:"
     echo "----------"
     echo "f()                 - find grep expressions recursively through the file system starting in working directory"
	 echo "pkg-list            - list all packages installed by port or pear"
     echo "h                   - history"
     echo "chmod_dirs()        - a function that recursively changes ownership of directories (not files) from working directory downward"
	 echo "wifi_info           - find out information about your current WIFI connection including channel used"
	 echo "wifi_diag           - launches GUI tool that can perform various WIFI diagnostics; press CMD-6 to scan WIFI hotspots"
	 echo "breakfast           - creates a brunch project using ember-sideloaded project"
	 echo "couch-info          - displays information about the couchbase server"
	 echo "couch-buckets       - displays information about the couchbase buckets"
	 echo "outdated            - shows all outdated packages (port, brew, pear, npm)"
	 echo "updated             - updates all package managers (port, brew, pear, npm)"
	 echo "status              - gives the status of all AWS instances"
	 echo "running             - lists processes with given name pattern"
	 echo "listening           - lists process which is listening on a given port"
     echo ""
     echo "short               - show this menu"
     echo ""

}

function outdated() {
	echo "PORT"
	echo "-------"
	port outdated
	echo "BREW"
	echo "-------"
	brew outdated
	echo "PEAR"
	echo "-------"
	pear list-upgrades
	echo "NPM"
	echo "-------"
	npm outdated
	echo " "
	echo -e "Run \033[4mupdated\033[0m to upgrade all dependencies"
	echo ""
}
function updated() {
	echo -e "\033[1mPORT: \033[2msudo port selfupdate\033[0m"
	sudo port selfupdate
	echo -e "\033[1mPORT: \033[2msudo port upgrade outdated\033[0m"
	sudo port upgrade outdated
	echo -e "\033[1mBREW: \033[2mbrew update\033[0m"
	brew update
	echo -e "\033[1mBREW: \033[2mbrew update \`brew outdated\` \033[0m"
	brew upgrade `brew outdated`
	echo -e "\033[1mPEAR: \033[2msudo pear upgrade-all\033[0m"
	sudo pear upgrade-all
	echo -e "\033[1mNPM(global): \033[2mnpm update -g\033[0m"
	npm update -g
	echo ""
	echo "All done. Happy trails."
	echo ""
}
# show the menu
short
# list available updates if terminal hasn't been openned recently
if test `find ~/.terminal.mutex -mmin +120`
then
    echo "Checking what updates are available"
	outdated
else
	echo 
	echo "You can check for updates by typing 'outdated' or 'updated' to run the updates."
	echo
	touch ~/.terminal.mutex
fi
