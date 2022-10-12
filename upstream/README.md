# Upstream directory

In this directory, all upstream manpages are collected. For historical
reasons, the *primary* directory is updated from the Debian unstable
manpages. All other directories are considered secondary and can be
created ad libitum.

## How to create a new secondary directory

### Part 1

The scripts *create-new-distribution-1.sh* and
*create-new-distribution-2.sh* in the toplevel directory help you
a bit with this task.

You can execute the first script like this:

```
$ ./create-new-distribution-1.sh debian-stretch
```

It makes sense to use the distribution's name
and (if applicable) codename for the given release.

Examples:

* *debian-stretch*
* *ubuntu-artful*
* *netbsd-7.1*
* *opensuse-leap-42.2*
* *gentoo*
* *fedora-26*

After the script has been executed, a new directory has been
created with two empty files in it, called "*update-manpages.sh*"
and "*links.txt*". Both are mandatory in each secondary
directory.

The script is responsible for creating all "man" directories
needed for the distribution's manpages. In the "man" directories,
every translatable manpage must be available in an uncompressed
format. For some hints what this script needs to do, take a
look at the script "*primary/update-manpages.sh*".

The script must also create the file called "*links.txt*".
In that file, every manpage which is a link to another manpage
is listed on a single line in the format:

```
destination link_name
```

### Part 2

After the script "*update-manpages.sh*" does what it needs to do,
the remaing part is trivial. Just execute the second script:

```
$ ./create-new-distribution-2.sh debian-stretch
```

You should be done now.
