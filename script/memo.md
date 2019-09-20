# execute linux cmd directly
` <cmd> `

# progress script

#!/bin/bash

for pc in `seq 1 100`
do
    echo -ne "$pc%\033[0k\r"
    sleepenh 0.1 &> /dev/null
done
echo
