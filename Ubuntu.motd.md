# Где найти motd в Ubuntu

motd в ubuntu динамический и формируется путем последовательного выполнения файлов из папки /etc/update-motd.d

## Работа с цветом

Чтобы получить цветной motd достаточно сформировать файл как в примере, поместить его в папку /etc/update-motd.d и сделать его исполняемым.

Пример:

```bash
#!/bin/dash
echo "
\033[1;32mВнимание!
==========\033[0m
\033[1;32m1. Эта строка будет зеленой\033[0m
\033[1;31m2. Эта строка будет красной\033[0m
\033[1;32m==========\033[0m
"
```

Цветовые коды можно посмотреть [тут](https://github.com/golovanovsv/configs/blob/master/.zshrc#L34) или [тут](https://www.linuxquestions.org/questions/linux-software-2/adding-colors-to-your-motd-105038/#post914365)

## pam

Чтобы motd показывался при логине по ssh нужно, чтобы в /etc/pam.d/sshd были следующие параметры:

```bash
session    optional     pam_motd.so motd=/run/motd.dynamic
session    optional     pam_motd.so noupdate
```

И включить использование PAM в sshd:
1. /etc/ssh/sshd_config: `UsePAM yes`
