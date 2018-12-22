# my trivial solution

* 使い方
    * 今日 15:00 に remind me.
    ```Shell
    $ mynotify.sh title "test messages." 15:00
    ```
    * 明日の 15:00 に remind me.
    ```Shell
    $ mynotify.sh title "test messages." 15:00 "+1 day"
    ```

* mynotify.sh
```sh
#!/bin/sh
 
# This script require following preparation :
#   [installation]
#     $ sudo apt install at
#
#   [start service]
#     $ sudo service atd restart
#   or
#     $ sudo /etc/init.d/atd restart
 
if [ $# -lt 3 ]
then
    echo "[USAGE] ${0##*/} [title] [message] [time (hh:mm)] [date (optional)]"
    exit 1
fi
 
TITLE=$1
MSG=$2
 
if [ $# -gt 3 ]
then
    DATE=`date "+%d.%m.%y" -d "$4"`
    DATE="$3 $DATE"
else
    DATE="$3 `date '+%d.%m.%y'`"
fi
#echo $DATE
 
# confirm atd service is already exist.
ps ax | grep "[/]usr/sbin/atd" > /dev/null
if [ $? -ne 0 ]
then
    echo "Was atd service started ?"
    sudo service atd restart
#   sudo /etc/init.d/atd restart
fi
 
LOG=/tmp/reminder.txt
echo -n "notify-send ${TITLE} \"${MSG}\" && ringbell.sh && echo ${MSG} > ${LOG}" | at ${DATE}
```

* ringbell.sh
```sh
#!/bin/sh
 
# This script require following preparation :
#   [installation]
#     $ sudo apt install vorbis-tools
ogg123 -q /usr/share/sounds/ubuntu/stereo/dialog-question.oga 2> /dev/null
#ogg123 -q /usr/share/sounds/freedesktop/stereo/complete.oga 2> /dev/null
```