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
