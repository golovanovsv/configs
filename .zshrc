setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

cdpath=(~ ..)
fpath=($fpath ~/.zfunc)
path=(/bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /usr/local/samba/bin \
    /usr/local/samba/sbin /usr/X11R6/bin /usr/X11R6/sbin /stand /usr/lib/python-django/bin .)

manpath=(/usr/local/man /usr/share/man)
typeset -U path fpath cdpath manpath
unlimit
limit stack 8192
limit core 0
limit -s
umask 022

autoload -U compinit
compinit

### COLORS ###
fg_green=$'%{\e[0;32m%}'
fg_blue=$'%{\e[0;34m%}'
fg_cyan=$'%{\e[0;36m%}'
fg_red=$'%{\e[0;31m%}'
fg_brown=$'%{\e[0;33m%}'
fg_purple=$'%{\e[0;35m%}'

fg_light_gray=$'%{\e[0;37m%}'
fg_dark_gray=$'%{\e[1;30m%}'
fg_light_blue=$'%{\e[1;34m%}'
fg_light_green=$'%{\e[1;32m%}'
fg_light_cyan=$'%{\e[1;36m%}'
fg_light_red=$'%{\e[1;31m%}'
fg_light_brown=$'%{\e[1;33m%}'
fg_light_purple=$'%{\e[1;35m%}'
fg_no_colour=$'%{\e[0m%}'

fg_white=$'%{\e[1;37m%}'
fg_black=$'%{\e[0;30m%}'

# System prompt setup
if [[ `whoami` == "root" ]];
then
    PROMPT="${fg_light_cyan}[${fg_light_red}%n${fg_light_cyan}:${fg_light_green}%~${fg_light_cyan}]#${fg_no_colour} "
else
    PROMPT="${fg_light_cyan}[${fg_light_green}%n${fg_light_cyan}:${fg_light_green}%~${fg_light_cyan}]#${fg_no_colour} "
fi


[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

HISTFILE=~/.zhistory
SAVEHIST=100
HISTSIZE=100

# Env path
export FTP_PASSIVE_MODE=no
export GREP_COLOR='1;33'

# Aliases defination
os=`uname`
if [[ ${os} == "Linux" ]];
    then
	export LS_COLORS="di=36:ln=35:ex=31:pi=33:so=32"
	alias ls="ls --color"
    else
	export LSCOLORS=gxfxcxdxbxegedBxBxCxGx
	alias ls="ls -G"
fi

alias su="su -m"
alias grep="grep --color=auto"
