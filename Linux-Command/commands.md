# compare file or folder
diff <-r> file1 file2
※ -u: git diff format / -c: relate content display

# search file content
grep <-r> "fastboot_menu" .

-r: search include directory
""内に*が検索文字として扱われる

# grep exclude
grep -r --color --exclude-dir={custom,lib,scripts} --exclude={*.xml,error_log} "beta" .

# folder size
du -sh * | sort -hr

list all folder/file under current path (exclude sub files), and sort by size

# use vim to display command's result
vi <(command)
ex. vi <(diff -u file1 file2)

# find & delete file
## use find cmd
find . -name "*.rej" -delete
## use rm
find . -name "<name>" | xargs rm -rf
## exclude
find . -name "<name>" -not -name "<exclusion>"
## find with multiple conditions
find . \( -type f -and -path "*/ssdad/*" -or -path "*hogehoge*" -or -path "*hoge*" \) -exec ls '{}' \;
    result will be like :
        foo test
        foo test/a
        foo test/b
    ('\' in '\;' makes find recognize ';'  '{}' means each search result)
find . \( -type f -and -path "*/ssdad/*" -or -path "*hogehoge*" -or -path "*hoge*" \) -exec ls '{}' +
    result will be like :
        foo test test/a test/b
    ('+' means combine result into one as possible)
## do complex execution
find -name "xxx" -exec sh -c 'ls "{}" && cat "{}" | grep XX' \;
or
find -name "xxx" | xargs -i sh -c 'ls "{}" && cat "{}" | grep XX'

# xargs
## just echo without newline (instead, connect with space)
find -name "xxx" | xargs
## 1 line once
find -name "xxx" | xargs -i echo {}
or
find -name "xxx" | xagrs -I {} echo {}
or
find -name "xxx" | xargs -n 1
## use replace symbol
find -name "xxx" | xargs -i echo {}
or
find -name "xxx" | xargs -I @ echo @

# copy override sym-link
cp -L

# mkdir 再帰的
mkdir -p

# usb device rules
sudo touch /etc/udev/rules.d/50-usb-serial.rules
add devices
    like SUBSYSTEM=="tty", ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", MODE="0666"
    for more attr info, use below
        udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB0)
sudo udevadm control --reload-rules

# auto kermit select
add below to device rules
    SYMLINK+="ttyUSB-kermit"
add below to kermrc
    set line /dev/ttyUSB-kermit

# rpm
## install
rpm -i --force xxx.rpm
### with processing
rpm -ivh --force xxx.rpm
## upgrade
rpm -U --force xxx.rpm
## uninstall
rpm -e <package_name>
## package list
rpm -qa
## target rpm info
rpm -qlp <xxx.rpm>
## unpackage
rpm2cpio xxx.rpm | cpio -id <target_folder>

# make 黙然ルール
make -p -f /dev/null
makeコマンドが定義するものも，自分の環境の環境変数によって定義されるものも表示される

# so info
readelf -d xxx.so
or
objdump -p xxx.so

# o info
ldd xxx.o

# copy to clipboard
xsel -i -b
== xsel --input --clipboard
(this will append with \n)

# copy to clipboard without \n
tr -d '\n' | xsel -i -b

# ag
## exclude file/directory patten
ag -r "hoge" --ignore "*patten*"

# od
od -j32 -N64 -tc xxx.img
(xxx.imgの32byteから、64byteをダンプして、文字に変更して表示する)

# hexdump
## same display with above
hexdump -s 32 -n 32 -C xxx.img

# record all output to file
(cmd) &>(file)
## 1:generic output, 2:generic error &:1+2
## i.e. 2>&1

# check gcc default search path
$CC -v -x c -E /dev/null
    -v      : Enable verbose mode. In the preprocessor's case, print the final form of the include path, among other things
    -x c    : Tell GCC that the input is to be treated as C source code. To find the G++ include path, substitute -x c++ .
    -E      : Stop after preprocessing (it's an empty source file, after all)

# unity
## when launcher icon freezed (can't click)
unity --replace

# create specific size file
# 1G
dd if=/dev/zero of=filename bs=1M count=1000
# 9M
dd if=/dev/zero of=filename bs=1M count=9

# output into file while terminal
<command> | tee <file>

# find all ip addresses connected
netstat -nt | awk '{print $5}'

# tar with permission remained
## use sudo and -p to remain permission
sudo tar -pcxvf <tar file>.tgz <target>
## restore (-p to restore permission, sudo to restore owner)
sudo tar -pxzvf <tar file>.tgz
