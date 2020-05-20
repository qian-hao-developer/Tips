#!/bin/bash

src="/media/m2/servers/gitlab/volumes"
dest_parent="/opt/aircon/backups/gitlab"
dest="$dest_parent/$(date +%Y%m%d-%H%M%S)"
last="$dest_parent/$(ls $dest_parent | tail -n 1)"

do_list="find $dest_parent/* -maxdepth 0 -type d"
do_count="eval $do_list | wc -l"
max_backup=30

if [ -z "$last" ]; then
    rsync -a --delete $src $dest
else
    while [ `eval $do_count` -ge $max_backup ]
    do
        drop=`eval $do_list | head -n 1`
        rm -rf $drop
    done
    rsync -a --delete --link-dest=$last $src $dest
fi

