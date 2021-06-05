# init with default
## without -m which specifies manifest file,
## repo will use default.xml if it has instance or link target
$ repo init -u <url> -b <branch>
$ repo init -u <url> -b <branch> -m <manifest>

# clone repositories with repo
$ repo init -u <url> -b <branch> -m <manifest> --mirror
$ repo sync

