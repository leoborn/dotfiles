alias reload='source ~/.bash_profile'
alias clear='clear; date | lolcat; cal | lolcat'

# cd-related
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias d='cd ~/Desktop'
alias g='cd ~/Documents/git'
alias tx='cd ~/Documents/TeX/LaTeX'

function m(){
	 if [[ $# == 0 ]] && ls -al | grep .meteor > /dev/null; then
	    meteor run
	 elif [[ $# == 0  ]]; then
	    cd ~/Documents/meteor
	 else
	    meteor $@
	 fi
}

# git-related
alias gi='git init'
alias grao='git remote add origin'
alias ga='git add'
alias gaa='git add --all'
alias gcm='git commit -m'
alias gp='git push'
alias gpsu='git push --set-upstream' ## ONLY NEEDED FOR FIRST PUSH OF A BRANCH!
alias gpu='git pull'
alias gst='git status'
alias gch='git checkout'

# Enable aliases to be sudo'ed
alias sudo='sudo '

alias sha256sum='shasum -a 256'
alias md5sum='md5'

# open-related
alias o='open'
alias bro='open -a "Brackets"'
alias twopen='open -a "TextWrangler"'
alias xopen='open -a "XCode"'
alias veracrypt='open -a "VeraCrypt"'
alias yoink='open -a "Yoink"'
alias mendeley='open -a "Mendeley Desktop"'
alias eclipse='open -a "Eclipse"'
alias txmaker='open -a "texmaker"'
alias vbox='open -a "VirtualBox"'
alias 1pass='open -a "1Password"'
alias thunder='open -a "Thunderbird"'
alias finder='open .'

alias diskreport='df -P -kHl'

alias ctop='htop -s PERCENT_CPU -d 10'
alias rtop='htop -s PERCENT_MEM -d 10'
alias cwd='pwd | tr -d "\r\n" | pbcopy | echo "==> \"`pwd`\" copied to clipboard"'
alias rrm='rm -rf'
alias cpv='rsync -WavP --human-readable --progress'
alias grep='grep --color=auto'
alias ls='ls -FG'
alias lsf='ls -flhFG'
alias lsl='ls -lFG'
alias lsd='ls -alt'
alias countfiles='ls -1 . | wc -l'

alias update='echo Updating Homebrew... | lolcat -a; brew update; brew upgrade; echo ; echo Updating MacPorts... | lolcat -a; sudo port selfupdate; port outdated; sudo port upgrade outdated'

alias wifi_activate='networksetup -setairportpower en1 on'

alias wifi_deactivate='networksetup -setairportpower en1 off'

alias wifi_scan='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport -s'

alias getexternalip='curl ipecho.net/plain ; echo'
alias getlocalip='ipconfig getifaddr en1'

# Activates screensaver
alias afk='open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'

alias c='khal agenda'
alias calsync='vdirsyncer sync'

alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

## MISC.

# A bunch of iTunes control aliases
alias mplay="osascript -e 'tell application \"iTunes\" to play'"
alias mpause="osascript -e 'tell application \"iTunes\" to pause'"
alias mnext="osascript -e 'tell application \"iTunes\" to play next track'; echo -n \"Playing \" && minfo"
alias mprevious="osascript -e 'tell application \"iTunes\" to play previous track'; echo -n \"Playing \" && minfo"
alias minfo="osascript -e 'tell application \"iTunes\" to set atrack to artist of current track' -e 'tell application \"iTunes\" to set ntrack to name of current track' -e 'set info to quote & ntrack & quote & \" by \" &  atrack'"

#function mrate(){
#	 osascript -e 'tell application "iTunes" to set rating of current track to \"$@\"'
#}

alias big="osascript -e 'repeat 10 times' -e 'tell application \"Terminal\" to tell application \"System Events\" to keystroke \"+\" using command down' -e 'end repeat'"
alias small="osascript -e 'repeat 10 times' -e 'tell application \"Terminal\" to tell application \"System Events\" to keystroke \"-\" using command down' -e 'end repeat'"

alias day="osascript -e 'tell application \"Terminal\" to set background color of first window to {10240, 10240, 10240, -10240}'"
alias night="osascript -e 'tell application \"Terminal\" to set background color of first window to {1024, 1024, 1024, -10240}'"

alias sniff='cd /usr/local/bin; sudo python net-creds.py; cd - > /dev/null'

alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

alias webserver='python -m SimpleHTTPServer'
