# tmux

tmux ls  - список активных сессий
tmux new-session -s <name> [-d] [command] - создать новую именованную сессию (-d - не подключаться к сессии, command - запустить в сессиий команду)
tmux new-window -t <name>: -n logs [command] - создать новое окно с именем logs (command - запустить в окне команду)
tmux split-window -t <name>:[id|name] [-v] [-h] [command] - разделить сессию на 2 панели и запустить в новой панели команду

tmux attach -t <name>  - войти в сессию с именем <name>
tmux kill-session -t <name>

# tabs

Ctrl + B:
d     - выйти из tmux (без завершения процессов)
C     - создать новое окно
x     - закрыть окно (требует подтверждения y)
n     - перейти на следующее окно
l     - перейти к последнему окну
p     - перейти на предыдущее окно
<num> - перейти к окну <num>

# windows split
Ctrl + B:
%     - Разделить по вертикали
"     - разделить по горизонтали

# windows nav
↑     -
↓     -
←     -
→     -

# settings

## ломает автодополнение
bind-key -n Tab next-window
bind-key -n BTab previous-window
