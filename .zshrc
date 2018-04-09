setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt AUTOCD

path=(/bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /usr/local/samba/bin \
    /usr/local/samba/sbin /usr/X11R6/bin /usr/X11R6/sbin /stand /usr/lib/python-django/bin .)

typeset -U path
unlimit
limit stack 8192
limit core 0
limit -s
umask 022

autoload -U compinit && compinit
autoload -U colors && colors

### COLORS ###
fg_black=$'%{\e[0;30m%}'
fg_red=$'%{\e[0;31m%}'
fg_green=$'%{\e[0;32m%}'
fg_yellow=$'%{\e[0;33m%}'
fg_blue=$'%{\e[0;34m%}'
fg_magenta=$'%{\e[0;35m%}'
fg_cyan=$'%{\e[0;36m%}'
fg_white=$'%{\e[0;37m%}'

fg_light_gray=$'%{\e[1;30m%}'
fg_light_red=$'%{\e[1;31m%}'
fg_light_green=$'%{\e[1;32m%}'
fg_light_yellow=$'%{\e[1;33m%}'
fg_light_blue=$'%{\e[1;34m%}'
fg_light_magenta=$'%{\e[1;35m%}'
fg_light_cyan=$'%{\e[1;36m%}'
fg_light_white=$'%{\e[1;37m%}'

fg_no_color=$'%{\e[0m%}'

# System prompt setup
if [[ `whoami` == "root" ]];
then
    PROMPT="${fg_light_cyan}[${fg_light_red}%n${fg_light_cyan}:${fg_light_green}%~${fg_light_cyan}]#${fg_no_color} "
else
    PROMPT="${fg_light_cyan}[${fg_light_green}%n${fg_light_cyan}:${fg_light_green}%~${fg_light_cyan}]#${fg_no_color} "
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
export GREP_COLOR=${fg_bold[yellow]}

# Aliases defination
os=`uname`
if [[ ${os} == "Linux" ]];
    then
	export LS_COLORS="di=36:ln=35:ex=31:pi=33:so=32"
	alias ls="ls --color"
    else
	export LSCOLORS="gxfxcxdxbxegedBxBxCxGx"
	alias ls="ls -G"
fi

alias su="su -m"
alias grep="grep --color=auto"
