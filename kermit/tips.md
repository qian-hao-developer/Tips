# switch to command mode
CTRL-\
c

# completion
use [?], works like [tab] in linus

# log to file
in command mode, use below cmd
log session <file>
## log will stop when kermit quit

# transfer files
## send
send [options] filename
### via xmodem protocol
send /protocol:xmodem <filename>
## receive
receive [options]
