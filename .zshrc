autoload -U colors && colors
#PROMPT="%{$fg[red]%}%~%{$fg[white]%}$%{$reset_color%} "
PROMPT="%{$fg[white]%}$%{$reset_color%} "

case $TERM in (*xterm*|*rxvt*|(dt|k|E)term)
  precmd () { }
  preexec () { }
  ;;
esac

setopt INTERACTIVE_COMMENTS      
setopt AUTO_LIST
setopt AUTO_MENU

fpath=(~/.zsh/completion $fpath) 

autoload -U compinit
compinit

#zstyle ':completion::complete:*' use-cache on
#zstyle ':completion::complete:*' cache-path .zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'

zle_highlight=(region:bg=magenta 
              special:bold      
              isearch:underline)

user-complete(){
   case $BUFFER in
       "cd --" )                  # "cd --" 替换为 "cd +"
           BUFFER="cd +"
           zle end-of-line
           zle expand-or-complete
           ;;
       "cd +-" )                  # "cd +-" 替换为 "cd -"
           BUFFER="cd -"
           zle end-of-line
           zle expand-or-complete
           ;;
       * )
           zle expand-or-complete
           ;;
   esac
}
zle -N user-complete
bindkey "\t" user-complete

alias -g ls='ls -X -F --color=auto'
alias -g ll='ls -l'
alias -g grep='grep --color=auto'
zstyle ':completion:*:ping:*' hosts 192.168.128.1{38,} www.g.cn \
      192.168.{1,0}.1{{7..9},}

export PATH="${PATH}:/home/guwan/bin:/usr/sbin"
export HISTSIZE=4096
#export PATH="/usr/bin:/bin/:/usr/sbin/:"${PATH}:${WORKDIR}/story:${WORKDIR}/story/tools/bin



alias offenv='cmd /k "E:\\Off\\dev\\otools\\bin\\OpenEnlistment.bat"'
alias ozsh='cmd /k "E:\\Off\\dev\\otools\\bin\\OpenEnlistment.bat && zsh && exit"'

#Because the Batch Scripts actually depends on the non-UNIX commands, so we can not simply change the search path
#Insead, we use command alias which won't pass to the child process

#alias -g sochost=haohou@shell.cs.utah.edu
#alias -g sochost_thebes=haohou@thebes.cs.utah.edu
#alias -g cade=haoh@lab1-13.eng.utah.edu

if [[ ! -f ~/unix_alias.zsh ]]; then
    echo "Updating Command Mapping..."
    updatealias
    echo "Done!"
fi
source ~/unix_alias.zsh

map_unix_path(){
    p=${1}
    if [ -z "$(echo ${p} | grep -E '^/')" ]; then
        p=`pwd`/${p}
    fi
    cat /proc/mounts | PATH_ARG=${p} awk -f ~/bin/get_fs_by_path.awk
}

win_path_to_unix_path(){
    p=$1
    # If it's relative path
    if [ -z "$(echo $1 | grep -E '^[a-zA-Z]:\\')" ]; then
        p=$(unix_path_to_win_path $(pwd) )\\${p}
    fi
    echo /cygdrive/$(echo ${p} | sed -e 's/://g' -e 's/\\/\//g' -e 's/^\(.\)/\l\1/g')
}

#Convert a UNIX dir to windows dir
unix_path_to_win_path(){
    #If this dir is a smybolic link, look for the target first
    p=${1}
    while [ -L ${p} ]; do
        p=$(readlink ${p})
    done
    if [ -z "$(echo ${p} | grep -E '^/')" ]; then
        p=`pwd`/${p}
    fi
    p=/cygdrive/$(map_unix_path ${p} | sed -e 's/^\(.\):/\l\1/g')
    #Finally, we can make a windows p
    echo ${p} | sed -e 's/^\/cygdrive\///g' -e 's/^\(.\)\//\1:\\/g' -e 's/\//\\/g'
}
#We have to set this variable after alias has been changed, otherwise non-UNIX version of sed will break the script
export WORKDIR=$(win_path_to_unix_path ${SRCROOT})

#Set the root dir as named dir
hash -d d=${WORKDIR}
pushd ${USERPROFILE}/AppData/Local/dftmp/Resources > /dev/null
hash -d dep=$(pwd)
popd > /dev/null

export PATH=${PATH}:${WORKDIR}/ols

alias whoru='echo I am ${ENLISTMENT}'

alias ls='/usr/bin/ls --color=auto'
alias ll='/usr/bin/ls --color=auto -l'
alias grep='/usr/bin/grep --color=auto'

function devosi() {
    pushd ~d/otools/bin/osi
    ./devosi.bat $@
    popd
}

alias -g logdir='directory/DataDir/Logs/ULS/'

alias sln='devenv.bat $SRCROOT\\ols\\OLS.sln'
alias storyweb='devenv.bat $SRCROOT\\story\\src\\site\\web.sln'
alias storytest='devenv.bat $SRCROOT\\storytest\\AllStoryTest.sln'
alias SS='sd sync -n $SRCROOT\\...'
alias OND='ohome nosync debug'
alias PD="ohome build 'patchdev*'"
alias DD='deploy debug'
alias OD='ohome debug'
alias MK='obuild debug'
alias CC='sd change'
alias WL='windiff -Lo'
alias B='BBRun -fc'
alias S='swaysubmit.bat'
alias RE='research.bat'
alias OS='ohome sync'
alias PRC='devosi checkout Sway-SingleBox-Cloud -duration'
alias PRD='devosi deploycloud debug Sway-SingleBox-Cloud'
alias CB='quickbuild buddy-c'
alias BU='cygstart ~/bin/BRS/brsutility && echo "For local deps, type UseDevelopmentStorage=true"'
alias start='cygstart'

# Change Woring Directory to 
function cdw(){
    cd $(win_path_to_unix_path $1)
}

command_not_found_handler(){
	found="no"
	for ext in $(echo $PATHEXT | awk 'BEGIN{RS=";"} $1~/^\.[a-zA-Z]{1,3}$/{print tolower($1)}')
	do
		actual=$@[1]${ext}
		for p in $path; do
			if [[ -x $p/$actual ]]; then
				found="yes"
				echo "\e[33mCommand '$@[1]' not found, but found $p/$actual instead\e[0m" > /dev/stderr
				$actual $@[2,-1]
				break
			fi
		done
		if [[ $found == "yes" ]]; then
			break
		fi
	done
	if [[ $found == "no" ]]; then   
		echo -e "\e[33mzsh: \e[32mCommand $@[1] Not Found\e[0m" > /dev/stderr 
	fi
}
