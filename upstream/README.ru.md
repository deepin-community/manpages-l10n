# Upstream directory

In this directory, all upstream manpages are collected. For historical
reasons, the *primary* directory is updated from the Debian unstable
manpages. All other directories are considered secondary and can be
created ad libitum.

## Как создать новый дополнительный каталог

### Часть 1

Сценарий *create-new-distribution-1.sh* и
*create-new-distribution-2.sh* в каталоге верхнего уровня вам
немного помогут с этой задачей.

Вы можете выполнить первый скрипт следующим образом:

```
$ ./create-new-distribution-1.sh debian-stretch
```

Имеет смысл использовать название дистрибутива
и (если применимо) кодовое название для данного выпуска.
Например:

* *debian-stretch*
* *ubuntu-artful*
* *netbsd-7.1*
* *opensuse-leap-42.2*
* *gentoo*
* *fedora-26*

После выполнения скрипта был создан новый каталог
с двумя пустыми файлами в нем, которые называются "*update-manpages.sh*"
и "*links.txt*". Оба файла обязательны для каждого дополнительного
каталога.

Скрипт отвечает за создание всех каталогов "man"
, необходимых для справочных страниц дистрибутива. В каталогах "man"
каждая переводимая справочная страница должна быть доступна в несжатом
формате. Для получения некоторых подсказок о том, что должен делать этот скрипт,
взгляните на сам скрипт "*primary/update-manpages.sh*".

Скрипт также должен создать файл с именем "*links.txt*".
В этом файле каждая справочная страница, которая является ссылкой на другую справочную
страницу, указана в одной строке в формате:
```
destination link_name
```

### Часть 2

Затем сценарий "*update-manpages.sh*" выполняет то, что ему нужно,
остальная часть тривиальна. Просто запустите второй скрипт:

```
$ ./create-new-distribution-2.sh debian-stretch
```

Вы уже закончили.
