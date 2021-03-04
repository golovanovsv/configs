# Общие параметры
path=( /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /usr/local/samba/bin \
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
# Все опции - http://zsh.sourceforge.net/Doc/Release/Options.html
setopt APPEND_HISTORY       # Писать одну историю в рамках нескольких сессий zsh
setopt INC_APPEND_HISTORY   # Дописывать историю сразу, не ждать завершения оболочки
# setopt HIST_IGNORE_ALL_DUPS # Если в файле истории уже есть такая команда, то предыдущая запись удаляется, а новая записывается в конец
setopt HIST_IGNORE_DUPS     # Не писать посторяющиеся команды, идущие подряд
setopt HIST_IGNORE_SPACE    # Не писать строки, начинающиеся с пробелов
setopt HIST_REDUCE_BLANKS   # Убирать лишние пробелы
setopt PROMPT_SUBST
setopt AUTOCD

# Установка переменных zsh
HISTFILE=~/.zhistory  # Путь к файлу истории
SAVEHIST=1000         # Число строк в файле истории
HISTSIZE=1000         # Число строк в памяти

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
# Чтобы получить нужные коды запусти zkbd
typeset -A key
key[F1]='^[OP'
key[F2]='^[OQ'
key[F3]='^[OR'
key[F4]='^[OS'
key[F5]='^[[15~'
key[F6]='^[[17~'
key[F7]='^[[18~'
key[F8]='^[[19~'
key[F9]='^[[20~'
key[F10]='^[[21~'
key[F11]='^[[23~'
key[F12]='^[[24~'
key[Backspace]='^H'
key[Insert]='^[[2~'
key[Home]='^[[1~'
key[PageUp]='^[[5~'
key[Delete]='^[[3~'
key[End]='^[[4~'
key[PageDown]='^[[6~'
key[Up]='^[[A'
key[Left]='^[[D'
key[Down]='^[[B'
key[Right]='^[[C'
# key[Menu]=''''

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
    branch=`git symbolic-ref HEAD 2>/dev/null | sed 's/refs\/heads\///g'`
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
if [[ -f /usr/bin/git ]]; then
    PROMPT="${fg_light_cyan}[${user_part}${fg_light_cyan}:${fg_light_green}%~${fg_light_cyan}]${supp_part}${eop_part}"
else
    PROMPT="${fg_light_cyan}[${user_part}${fg_light_cyan}:${fg_light_green}%~${fg_light_cyan}]${eop_part}"
fi

# Настройка альясов
alias su="su -m"
alias grep="grep --color=auto"
alias ip="ip -color=auto"

if [[ -f /usr/bin/bat ]]; then
    alias cat="/usr/bin/bat -n"
fi

if [[ ${os} == "Linux" ]]; then
    alias ls="ls -allh --color"
elif [[ ${os} == "FreeBSD" ]]; then
	alias ls="ls -allh -G"
else
	alias ls="ls -allh"
fi

# Заголовки для терминала
precmd() {
    print -Pn "\e]2;%n@%M\a"
    print -Pn "\e]1;%n@%M\a"
}

## Экзотические автодополнения
if [[ -f /usr/local/bin/kubectl || -f /usr/bin/kubectl ]]; then
    source <(kubectl completion zsh);
    # Игнорируем часть команд в автодополнении
    zstyle ':completion:*' ignored-patterns 'kubeadm|kubelet|kubernetes-scripts';
fi

if [[ -f /usr/local/bin/helm || -f /usr/bin/helm ]]; then
    source <(helm completion zsh)
fi

appsh_args=(stop start reload)
compctl -k appsh_args app.sh
