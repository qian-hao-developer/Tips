#esc
C-c

#terminal
:term / :terminal

#close terminal
C-w C-c

#command mode in terminal
C-w N

#back to terminal from command mode
i / a

#change window
C-w C-w

#split horizonal
C-w s

#split vertical
C-w v

#close window
C-w c

#undo to change number
:u <number>

#undo all
:u1|u   (undo to change number one and undo again)

#yank clipboard
"*y

#paste clipboard
"*p

#insert ; to the end of all line
:%s/$/;/g
#insert ; to end of current line
:s/$/;/g
#insert ; to specific line's end from No.3-No.7
:3,7s/$/;/g
