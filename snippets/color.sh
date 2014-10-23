# Define terminal color variables
BLACK='\033[0;30m'
BLUE='\033[0;34m'
export GREEN='\033[0;32m'
CYAN='\033[0;36m'
export RED='\033[0;31m'
PURPLE='\033[0;35m'
BROWN='\033[0;33m'
export LIGHTGRAY='\e[0;37m'
DARKGRAY='\033[1;30m'
LIGHTBLUE='\033[1;34m'
LIGHTGREEN='\033[1;32m'
LIGHTCYAN='\033[1;36m'
LIGHTRED='\033[1;31m'
LIGHTPURPLE='\033[1;35m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'        

export BOLD="\033[1m"
export RESET="\033[0m"
export NORMAL="\033[0m"
export DIM="\033[2m"

# Allow for Color prompt
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="${debian_chroot:+($debian_chroot)}\u${DIM}@${LIGHTGRAY}\h [ ${DIM}\w\a\]${RESET} ] "
    ;;
*)
    ;;
esac

# enable color support to *nix commands that have support for it
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi