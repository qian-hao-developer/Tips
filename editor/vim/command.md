#esc
C-c

#terminal
:term / :terminal

#terminal vertical
:vert term

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

#insert to begin of line
replace $ with ^

#search whole word
/\<word\>
#search two words
/word1\|word2
#search two whole words
/\<word1\>\|\<word2\>
or
/\<\(word1\|word2\)\>
#less symbol
exp.
/\v<(word1|word2)>

#toggle path to current tab file (nerdtree)
:NerdtreeFind
