# Работа с цветом

К сожалению в FreeBSD нельзя просто взять и написать escape последовательности в текстовом редакторе (или я об этом не знаю).

Поэтому единственная возможность - использование echo:

```bash
bash# echo -n "\033[1;31mThis text will be red\033[0m\n" > /etc/motd
```

Где:

* \003 или \e - обозначение escape-последовательности
* [1;31m или [0m - коды цвета

Если теперь сделать:

```bash
bash# cat /etc/motd
```

То можно увидеть красный текст "This text will be red"

Цветовые коды можно посмотреть [тут](https://github.com/golovanovsv/configs/blob/master/.zshrc#L34) или [тут](https://www.linuxquestions.org/questions/linux-software-2/adding-colors-to-your-motd-105038/#post914365)
