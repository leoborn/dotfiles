# functions declared as 'function' take an argument,
# the others do not and just do things more complicated than a one-liner.

source ~/.bash_prompt
source ~/.bash_aliases
. `brew --prefix`/etc/profile.d/z.sh

# Set default editor
# Especially nice when opening it from less by typing 'v'
export EDITOR=nano

export "LESSOPEN=|emacs --batch -l /opt/e2ansi/e2ansi-silent -l ~/.emacs.d/.emacs -l /opt/e2ansi/bin/e2ansi-cat %s"
export "LESS=-R"
export "MORE=-R"

#alias hless='LESSOPEN="|emacs --batch -l /opt/e2ansi/e2ansi-silent -l ~/.emacs.d/.emacs -l /opt/e2ansi/bin/e2ansi-cat %s" less'

# Use this to output any error-related text to stdout
# (lolcat should be reserved for the bright things in life!)
alias redText='echo -en "\033[31m"'
alias redOutput='while read line; do redText; echo $line; done'

# for quick command-line notificating without remembering all of it
function tn(){ terminal-notifier -message "$@" -title "Terminal"; }

# Display commit history over the day of leoborn
# from https://github.com/holman/spark/wiki/Wicked-Cool-Usage
ghd() {
	git log --pretty=format:'%an: %at' --author="leoborn" | awk '{system("date -r "$NF" '+%H'")}' | sort | uniq -c | ruby -e 'puts STDIN.readlines.inject(Hash[Array("00".."23").map{|x| [x,0]}]) {|h, x| h.merge(Hash[*x.split(" ").reverse])}.sort.map(&:last)' | spark | lolcat
}

export TODOTXT_DEFAULT_ACTION=ls
alias t='todo.sh -d ~/todo.cfg'
complete -F _todo t

# ps with grep
# from http://hiltmon.com/blog/2013/07/30/quick-process-search/
function psax() { ps auxwww | grep "$@"  | grep -v grep; }

ntfsmount() {
	if mount | grep osxfuse > /dev/null; then
    	echo $'Another OSXFUSE volume is already mounted!\nUnmount it first!' | redOutput
	elif [[ $(diskutil list | grep 0x86) == "" ]]
	then
		echo "No NTFS volume detected! Attach/connect one first!" | redOutput
	else
		echo "NOTE: May prompt for admin password."
		if [[ ! -d "/Volumes/NTFS" ]]
		then
			sudo mkdir /Volumes/NTFS
		fi
		diskutil list | grep '0x86' | cut -d: -f2 | sed 's/.*\(disk[1-9].*\)/\1/' | xargs -I{} sudo /opt/local/bin/ntfs-3g /dev/{} /Volumes/NTFS -olocal -oallow_other

		echo "NTFS drive successfully mounted!" | lolcat
	fi
}

ntfsunmount() {
	if [[ $(ismounted ntfs) == "true" ]]; then
		echo "NOTE: May prompt for admin password."
		sudo umount /Volumes/NTFS
		sudo rm -rf /Volumes/NTFS
		echo "NTFS drive successfully unmounted!" | lolcat
	else
		echo "No NTFS volume currently mounted!" | redOutput
	fi
}

# Checks mount status for:
# an NTFS volume
function ismounted() {
	if [[ "$1" == "NTFS" ]] || [[ "$1" == "ntfs" ]] || [[ "$1" == "Ntfs" ]]
	then
    	if mount | grep NTFS > /dev/null; then
        	echo "true"
    	else
        	echo "false"
    	fi
    else
    	echo "Not recognized!" | redOutput
	fi
}

# Invokes an 'oblivious' sudo, i.e. password doesn't get cached
function osudo() { sudo "$@"; sudo -K; }

# Create a new directory and enter it
function mkd() { mkdir -p "$@" && cd "$_"; }

# Determine size of a file or total size of a directory
function getsize() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* *;
    fi;
}

function wifi_connect(){
	if [ $# == 0 ]; then
		echo "Usage: wifi_connect SSID password"
	else
		networksetup -setairportnetwork en1
	fi
}

# Show WiFi connectivity as a spark graph
wifi_status() {
	calc() {
		awk "BEGIN { print "$*" }"
	}

	if [[ $(ifconfig en1 | grep UP | wc -l) -eq 1 ]]; then
    	_linkQual="`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I en1 | grep agrCtlRSSI | cut -d':' -f2 | cut -d'-' -f2`"

    	if [[ $_linkQual -lt 20 ]] # >80% link qual
     	then
       		_linkSparked=$(spark 1 2 3 4)
     	elif [[ $_linkQual -lt 41 ]] # 60~80% link qual
     	then
       		_linkSparked=$(spark 1 2 3 0 4 | cut -d'█' -f1)
     	elif [[ $_linkQual -lt 61 ]] # 40~60% link qual
     	then
       		_linkSparked=$(spark 1 2 0 0 4 | cut -d'█' -f1)
     	elif [[ $_linkQual -lt 81 ]] # 20~40% link qual
     	then
       		_linkSparked=$(spark 1 0 0 0 4 | cut -d'█' -f1)
     	else # < 20%
       		_linkSparked=$(spark 0 0 0 0 4 | cut -d'█' -f1)
     	fi

	 	percentage=`calc "$_linkQual"/100`
	 	temp="${percentage/,/"."}"
	 	temp2=`calc 1-"$temp"`
	 	temp3="${temp2/,/"."}"
	 	result=`calc "$temp3"*100`

		if [[ "$1" == "-nocat" ]]; then
     		echo $_linkSparked $result%
     		echo "(`networksetup -getairportnetwork en1`)"
     	else
     		echo $_linkSparked $result% | lolcat
     		echo "(`networksetup -getairportnetwork en1`)" | lolcat
     	fi
	fi
}

# Show SSID and password for the currently connected network (requires sudo)
# adapted from https://github.com/mislav/dotfiles/blob/master/bin/wifi-pass
wifi_password() {
	set -e

	ssid="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | sed -n "/ SSID:/s/^.\\{2,\\}: //p")"
	if [ -n "$ssid" ]; then
  		pw=`security find-generic-password -ga "$ssid" 2>&1 >/dev/null | cut -d\" -f2`
  		osascript -e 'tell app "Terminal" to display dialog "SSID: '"$ssid"'\n'"$pw"'" buttons {"OK"} default button "OK"'
	else
  		echo "No current wifi network name detected" >&2
  		exit 1
	fi
}

# Show some info on the system
function sysinf() {
	screenfetch
	wifistatus=`ifconfig en1 | grep status | cut -d' ' -f2`
	if [[ "$wifistatus" == "active" ]]
	then
		echo
		echo "Wi-Fi status:" | lolcat
		wifi_status -nocat
	fi
	echo
	echo "RAM status (detailed):" | lolcat
	python /usr/local/bin/used-mem.py all #| lolcat
	echo
	echo "Disk status (detailed):" | lolcat
	diskreport #| lolcat
	echo
	echo "Battery status (detailed):" | lolcat
	pmset -g batt | cut -d'p' -f1

	if [ $# == 1 ] && ( [[ "$1" == "-a" ]] || [[ "$1" == "--all" ]] ); then
		echo
		istats | head -n 15
	fi
}

# Function to change bash prompt; acts as a 'switch' for the battery display
batmonitor() {
	if [[ "$SHOW_BATTERY" == "TRUE" ]]; then
		unset SHOW_BATTERY
		export SHOW_BATTERY="FALSE"
	else
		unset SHOW_BATTERY
		export SHOW_BATTERY="TRUE"
	fi
	unset PROMPT_COMMAND
	. ~/.bash_prompt
}

# Short wrapper around nmap
function netmap(){
        _usage(){
	        echo "Usage: netmap [option (arguments)] ip-address"
		echo ""
		echo "Options:"
		echo "    -h, --help		Display this help info."
		echo "    -S, --spoof		Spoof your own ip address by giving a fake ip address as argument."
		echo ""
		echo "(Hint: get ip-address based on ifconfig.)"
	}

	if [ $# == 0 ]; then
		OWN_IP=`getlocalip`
		sudo nmap -sP $OWN_IP/24
	elif [ $# == 1 ] && ( [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] ) ; then
		_usage
	elif [ $# == 2 ] && ( [[ "$1" == "-S" ]] || [[ "$1" == "--spoof" ]] ) ; then
	        OWN_IP=`getlocalip`
		sudo nmap -sP -S $2 -e en1 $OWN_IP/24
	elif [ $# == 3 ] && ( [[ "$1" == "-S" ]] || [[ "$1" == "--spoof" ]] ); then
		sudo nmap -sP -S $2 -e en1 $3/24
	elif [ $# == 1 ]; then
	        sudo nmap -sP $1/24
	else
	        _usage
	fi
}

# Convert either only one Apple Lossless audio file
# or all Apple Lossless files in a directory into .mp3 files
#
# NOTE: Tags (e.g. cover art) will not be preserved!
function tomp3(){
	if [ $# == 1 ] && [[ -f "$1" ]]; then
		x=`basename "$1"`
		name=${x%.*}
		afconvert -d 'LEI16' -f 'WAVE' "$1"
		lame --alt-preset cbr 320 "$name".wav
		rm "$name".wav
	elif [ $# == 1 ] && [[ -d "$1" ]]; then
		 cd $1
		 find . -iname "*.m4a" | while read f; do
		 	x=`basename "$f"`
			name=${x%.*}
			afconvert -d 'LEI16' -f 'WAVE' "$f"
			lame --alt-preset cbr 320 "$name".wav
			rm "$name".wav
		 done
	fi
}

export JAVA_HOME=$(/usr/libexec/java_home)
export M2_HOME=/opt/apache-maven-3.3.3
export PATH=$PATH:$M2_HOME/bin
export SCALA_HOME=/usr/local/share/scala-2.11.7
export PATH=$PATH:$SCALA_HOME/bin

export PATH="/opt/homebrew/bin:$PATH"

# MacPorts Installer addition on 2015-10-06_at_20:42:49: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# No Google Analytics for Homebrew
export HOMEBREW_NO_ANALYTICS=1

# bash-completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi

# Brew completion
if [ -f /opt/local/etc/profile.d/brew-completion.sh ]; then
    . /opt/local/etc/profile.d/brew-completion.sh
fi

# todo-txt completion
if [ -f /opt/local/etc/profile.d/todo_completion ]; then
    . /opt/local/etc/profile.d/todo_completion
fi
