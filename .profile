# functions declared as 'function' take an argument,
# the others do not and just do things more complicated than a one-liner.

# from https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt
prompt_git() {
	local s='';
	local branchName=''

	# check if the current directory is in .git before running git checks
	if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

		# Ensure the index is up to date.
		git update-index --really-refresh -q &>/dev/null;

		# Check for uncommitted changes in the index.
		if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
		fi;

		# Check for unstaged changes.
		if ! $(git diff-files --quiet --ignore-submodules --); then
			s+='!';
		fi;

		# Check for untracked files.
		if [ -n "$(git ls-files --others --exclude-standard)" ]; then
			s+='?';
		fi;

		# Check for stashed files.
		if $(git rev-parse --verify refs/stash &>/dev/null); then
			s+='$';
		fi;

	fi;
	
	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')"

		[ -n "${s}" ] && s=" [${s}]"
		
		echo -e "${1}${branchName}${2}${s}"
	else
		return
	fi
}

violet="\e[1;35m"
white="\e[1;37m"
resetC="\e[0m";

PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h\[\033[0m\](\$(date -j +'%H:%M'), \$(python /usr/local/bin/used-mem.py))"
PS1+=":\[\033[33;1m\]\w\[\033[m\]"
PS1+="\$(prompt_git \" on \[${violet}\]\" \"\[${white}\]\")"
PS1+="\[${resetC}\]\n\$ "
export PS1
export CLICOLOR=1
export LSCOLORS=GxFxBxDxCxegedabagacad

export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
export PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"


# Use this to output any error-related text to stdout
# (lolcat should be reserved for the bright things in life!)
alias redText='echo -en "\033[31m"'
alias redOutput='while read line; do redText; echo $line; done'


alias reload='source ~/.profile'
alias clear='clear; date | lolcat; cal | lolcat'


# cd-related
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .2='cd ..'
alias .3='cd ../..'
alias .4='cd ../../..'
alias hiwi='cd ~/Desktop/Privat/Uni/HiWi'
alias sd='cd /Volumes/Leo\ Born\ HD\ Extension/'
alias g='cd ~/Documents/git'

alias gi='git init'
alias grao='git remote add origin'
alias ga='git add'
alias gcm='git commit -m'
alias gp='git push'
alias gpsu='git push --set-upstream' ## ONLY NEEDED FOR FIRST PUSH OF A BRANCH!
alias gpu='git pull'
alias gst='git status'

# Display commit history over the day of leoborn
# from https://github.com/holman/spark/wiki/Wicked-Cool-Usage
ghd(){
	git log --pretty=format:'%an: %at' --author="leoborn" | awk '{system("date -r "$NF" '+%H'")}' | sort | uniq -c | ruby -e 'puts STDIN.readlines.inject(Hash[Array("00".."23").map{|x| [x,0]}]) {|h, x| h.merge(Hash[*x.split(" ").reverse])}.sort.map(&:last)' | spark | lolcat
}

# Call from a local repo to open the repository on github/bitbucket in browser
# from https://github.com/jfrazelle/dotfiles/blob/master/.functions
orepo() {
	# this one currently works with BitBucket, not tested for GitHub yet! 
	local giturl=$(git config --get remote.origin.url | sed 's/git@/\/\//g' | sed 's/.git$//' | sed 's/https://g' | sed 's/:/\//g' | sed 's/\/\/.*@//g')
	
	#local giturl=$(git config --get remote.origin.url | sed 's/git@/\/\//g' | sed 's/.git$//' | sed 's/https://g' | sed 's/:/\//g')
	if [[ $giturl == "" ]]; then
		echo "Not a git repository or no remote.origin.url is set."
	else
		local gitbranch=$(git rev-parse --abbrev-ref HEAD)
		local giturl="https:${giturl}"

		if [[ $gitbranch != "master" ]]; then
			if echo "${giturl}" | grep -i "bitbucket" > /dev/null ; then
				local giturl="${giturl}/branch/${gitbranch}"
                    	else
                    		local giturl="${giturl}/tree/${gitbranch}"
                    	fi
		fi

		echo Open $giturl
		open $giturl
	fi
}


# Enable aliases to be sudo'ed
alias sudo='sudo '

alias sha256sum='shasum -a 256'
alias md5sum='md5'

alias twopen='open -a "TextWrangler"'
alias xopen='open -a "XCode"'
alias veracrypt='open -a "VeraCrypt"'
alias yoink='open -a "Yoink"'
alias finder='open .'

# ps with grep
# from http://hiltmon.com/blog/2013/07/30/quick-process-search/
function psax() {
    ps auxwww | grep "$@"  | grep -v grep
}

alias ctop='top -o cpu'
alias rtop='top -o MEM'
alias cwd='pwd | tr -d "\r\n" | pbcopy | echo "==> \"`pwd`\" copied to clipboard"'
alias rrm='rm -rf'
alias cpv='rsync -WavP --human-readable --progress'
alias grep='grep --color=auto'
alias ls='ls -FG'
alias lsf='ls -flhFG'
alias lsl='ls -lFG'
alias countfiles='ls -1 . | wc -l'

# Use Mac OSX Preview to open a man page
# from https://github.com/atomantic/dotfiles/blob/master/.shellfn
function pman() {
  man -t $1 | open -f -a /Applications/Preview.app
}

alias update='echo Updating Homebrew... | lolcat -a; brew update; brew upgrade; echo ; echo Updating MacPorts... | lolcat -a; sudo port selfupdate; port outdated; sudo port upgrade outdated'

sdmount(){
	if mount | grep osxfuse > /dev/null; then
    	echo $'Another OSXFUSE volume is already mounted!\nUnmount it first!' | redOutput
	else
		if [[ ! -d "/Volumes/Leo Born HD Extension/Data" ]]
		then
			mkdir /Volumes/Leo\ Born\ HD\ Extension/Data
		fi
		encfs /Volumes/Leo\ Born\ HD\ Extension/.Data/ /Volumes/Leo\ Born\ HD\ Extension/Data
	fi
}

sdunmount(){
	if [[ $(ismounted sd) == "true" ]]; then
		umount -f /Volumes/Leo\ Born\ HD\ Extension/Data
		rm -rf /Volumes/Leo\ Born\ HD\ Extension/Data
	else
		echo "SD-Data currently not mounted!" | redOutput
	fi
}

ntfsmount(){
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
		#osascript -e 'tell application "Finder"' -e 'make new alias to folder "Leo Born SSD:Volumes:NTFS" at desktop' -e 'end tell'
	
		echo "NTFS drive successfully mounted!" | lolcat
	fi
}

#find ~/Desktop/ -type f -name '*ntfs-3g*' -exec rm {} +;
ntfsunmount(){
	if [[ $(ismounted ntfs) == "true" ]]; then
		echo "NOTE: May prompt for admin password."
		sudo umount /Volumes/NTFS
		sudo rm -rf /Volumes/NTFS
		echo "NTFS drive successfully unmounted!" | lolcat
	else
		echo "No NTFS volume currently mounted!" | redOutput
	fi
}


# This is university vpn
# input credentials
alias vpnconnect='/opt/cisco/anyconnect/bin/vpn connect vpnsrv0.urz.uni-heidelberg.de; open -a "Cisco AnyConnect Secure Mobility Client"' # open app for menu bar item
alias cvpn=vpnconnect
alias vpndisconnect='/opt/cisco/anyconnect/bin/vpn disconnect vpnsrv0.urz.uni-heidelberg.de; killall "Cisco AnyConnect Secure Mobility Client"'
alias dvpn=vpndisconnect
alias vpnstatus='/opt/cisco/anyconnect/bin/vpn state'
alias svpn=vpnstatus

spmount(){
	echo "Start connecting to sharepoint..."
	echo
	vpnStatus=`vpnstatus | grep state | tail -n1 | cut -d' ' -f5`
	if [[ "$vpnStatus" == "Disconnected" ]]
	then
		echo "VPN to university is not established!" | lolcat
		echo "Must. Connect. First." | lolcat -a
		echo
		vpnconnect
	fi
	echo "Now we're mounting!"
	osascript -e 'tell application "Finder" to open location "smb://leo.born:bVx83.f9@zo-puck.zo.uni-heidelberg.de/Proj-Literaturgeographie"'
	sleep 20
	echo "Mounted at /Volumes/Proj-Literaturgeographie" | lolcat -a
}

spunmount(){
	if [[ $(ismounted sp) == "true" ]]; then
		umount /Volumes/Proj-Literaturgeographie
		echo "SharePoint drive successfully unmounted!" | lolcat
	else
		echo "SharePoint currently not mounted!" | redOutput
	fi
}


# Checks mount status for:
# SD card,
# a NTFS volume, or
# Proj-Literaturgeographie on sharepoint
function ismounted(){
	if [[ "$1" == "SD" ]] || [[ "$1" == "sd" ]] || [[ "$1" == "Sd" ]]
	then
    	if mount | grep encfs > /dev/null; then
        	echo "true"
    	else
        	echo "false"
    	fi
	elif [[ "$1" == "NTFS" ]] || [[ "$1" == "ntfs" ]] || [[ "$1" == "Ntfs" ]]
	then
    	if mount | grep NTFS > /dev/null; then
        	echo "true"
    	else
        	echo "false"
    	fi
    elif [[ "$1" == "SP" ]] || [[ "$1" == "sp" ]] || [[ "$1" == "Sp" ]] || [[ "$1" == "sharepoint" ]]
    then	
    	if mount | grep Proj-Literaturgeographie > /dev/null; then
    		echo "true"
    	else
    		echo "false"
    	fi
    else
    	echo "Not recognized!" | redOutput
	fi
}

alias getexternalip='curl ipecho.net/plain ; echo'
alias getlocalip='ipconfig getifaddr en1'

# away from keyboard activates screensaver
alias afk='open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'

# invokes a 'oblivious' sudo, i.e. password doesn't get cached
function ksudo(){ sudo "$@"; sudo -K; }

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$_";
}

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

function calc(){
	awk "BEGIN { print "$*" }"
}

wifiquality(){
	if [[ $(ifconfig en1 | grep UP | wc -l) -eq 1 ]]; then
    	_linkQual="`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I en1 | grep agrCtlRSSI | cut -d':' -f2 | cut -d'-' -f2`"

    	if [[ $_linkQual -lt 10 ]] # >90% link qual
     	then
       		_linkSparked=$(spark 1 2 3 4)
     	elif [[ $_linkQual -lt 26 ]] # 75~90% link qual
     	then
       		_linkSparked=$(spark 1 2 3 0)
     	elif [[ $_linkQual -lt 51 ]] # 50~75% link qual
     	then
       		_linkSparked=$(spark 1 2 0 0)
     	elif [[ $_linkQual -lt 76 ]] # 25~50% link qual
     	then
       		_linkSparked=$(spark 1 0 0 0)
     	else # < 25%
       		_linkSparked=$(spark 0 0 0 0)
     	fi

	 	percentage=`calc "$_linkQual"/100`
	 	temp="${percentage/,/"."}"
	 	temp2=`calc 1-"$temp"`
	 	temp3="${temp2/,/"."}"
	 	result=`calc "$temp3"*100`

     	echo $_linkSparked $result% | lolcat
	fi
}

sysinf(){
	screenfetch
	wifistatus=`ifconfig en1 | grep status | cut -d' ' -f2`
	if [[ "$wifistatus" == "active" ]]
	then
		echo
		echo "Wi-Fi quality:"
		wifiquality
	fi
	echo
	echo "RAM status (detailed):"
	python /usr/local/bin/used-mem.py all | lolcat
}

bublog(){
	mountStatus=`ismounted sd`
	if [[ "$mountStatus" == "false" ]]; then
		sdmount
	fi
	
	cd /Volumes/Leo\ Born\ HD\ Extension/Data/Blogs/LI/
	oldname=`ls | grep Aktuelles_WP-BU`
	
	# wget flag -N to skip files that are unchanged
	wget -r --no-verbose --show-progress -N --user="k5499-1" --ask-password ftp://server.febas.net/htdocs/ -P /Volumes/Leo\ Born\ HD\ Extension/Data/Blogs/LI/$oldname
	
	newdate=`date -j +"%d_%m_%y"`
	mv /Volumes/Leo\ Born\ HD\ Extension/Data/Blogs/LI/$oldname /Volumes/Leo\ Born\ HD\ Extension/Data/Blogs/LI/Aktuelles_WP-BU_$newdate
}



## MISC.
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'


function matrix1() {
echo -e "\e[1;40m" ; /usr/bin/clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|gawk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}

function matrix2() {
echo -e "\e[1;40m" ; /usr/bin/clear ; characters=$( jot -c 94 33 | tr -d '\n' ) ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) $characters ;sleep 0.05; done|gawk '{ letters=$5; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}





export JAVA_HOME=$(/usr/libexec/java_home)
export M2_HOME=/opt/apache-maven-3.3.3
export PATH=$PATH:$M2_HOME/bin
export SCALA_HOME=/usr/local/share/scala-2.11.7
export PATH=$PATH:$SCALA_HOME/bin

# MacPorts Installer addition on 2015-10-06_at_20:42:49: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# bash-completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi

# Brew completion
if [ -f /opt/local/etc/profile.d/brew-completion.sh ]; then
    . /opt/local/etc/profile.d/brew-completion.sh
fi