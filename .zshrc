# Общие параметры
path=(/bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /usr/local/samba/bin \
    /usr/local/samba/sbin /usr/X11R6/bin /usr/X11R6/sbin /stand /usr/lib/python-django/bin .)
typeset -U path
umask 022

# Автозагрузка
autoload -U compinit && compinit
autoload -U colors && colors

# Получение фактов
username=`whoami`
os=`uname`

# Установка опций
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt PROMPT_SUBST
setopt AUTOCD

# Установка переменных среды
export FTP_PASSIVE_MODE=no
export GREP_COLOR="01;33"

if [[ ${os} == "Linux" ]]; then
    export LS_COLORS="di=36:ln=35:ex=31:pi=33:so=32"
elif [[ ${os} == "FreeBSD" ]]; then
    export LSCOLORS="gxfxcxdxbxegedBxBxCxGx"
fi

# Параметры цвета
# При нстройке переменой PROMPT при помощи модуля colors почему-то сбивается отступ командной строки при автодополнении
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


# Переопределение фунциональных клавиш
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

# Установка переменных zsh
HISTFILE=~/.zhistory
SAVEHIST=100
HISTSIZE=100

CEPH_CLUSTER="xvers"

# Настройка приглашений
# Общая часть
user_part="undef"
if [[ ${username} == "root" ]]; then
    user_part="${fg_light_red}%n${fg_no_color}"
    eop_part="${fg_light_red}#${fg_no_color} "
else
    user_part="${fg_light_green}%n${fg_no_color}"
    eop_part="${fg_light_cyan}#${fg_no_color} "
fi

# Часть для работы с репозиториями
git_prompt() {
    ret=""
    branch=`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`
    if [[ $branch == "" ]]; then
        rep=""
    elif [[ $branch == "master" ]]; then
        ret="[${fg_light_red}${branch}${fg_light_cyan}]"
    elif [[ $branch == "develop" ]]; then
        ret="[${fg_light_yellow}${branch}${fg_light_cyan}]"
    else
        ret="[${fg_light_green}${branch}${fg_light_cyan}]"
    fi
    echo ${ret}
}

# Собираем служебную часть приглашения
supp_part='$(git_prompt)'
PROMPT="${fg_light_cyan}[${user_part}${fg_light_cyan}:${fg_light_green}%~${fg_light_cyan}]${supp_part}${eop_part}"


# Настройка альясов
alias su="su -m"
alias grep="grep --color=auto"

if [[ -f /usr/bin/bat ]]; then
    alias cat="/usr/bin/bat -n"
fi

if [[ -n "$CEPH_CLUSTER" ]]; then
    alias rbd="rbd --cluster $CEPH_CLUSTER"
    alias ceph="ceph --cluster $CEPH_CLUSTER"
fi

if [[ ${os} == "Linux" ]]; then
    alias ls="ls --color"
elif [[ ${os} == "FreeBSD" ]]; then
	alias ls="ls -G"
else
	alias ls="ls"
fi

# Заголовки для терминала
print -Pn "\e]2;%n@%M\a"
print -Pn "\e]1;%n@%M\a"

# Экзотические автодополнения
ceph_args=(health auth osd crush pg df list ls lspools dump add in rm del out get set export get-or-create get-or-create-key caps print-key import detail pool init )
compctl -k ceph_args ceph

rbd_args=(pool snap mirror init create ls info trash purge resize rm mv restore rollback protect unprotect clone enable disable peer add remove image resync image status)
compctl -l rbd_args rbd

appsh_args=(stop start reload)
compctl -k appsh_args app.sh
