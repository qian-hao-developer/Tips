#1 location
## add to .ssh/config
    Host cobra
     HostName 10.73.174.101
     User gitosis
     IdentityFile ~/.ssh/(key)
     Port 22

#2 ssh mms_admin@cobra
    Account: mms_admin
    PW: avcmms

#3 su gitosis
    super: gitosis
    PW: gitosis

#4 repository for sync
    cd /var/opengrok/ps152o_pf_dev_orig
    rm -rf *
    repo init ... -m C30-xxx-xx ...
    repo sync

#5 copy
    cp -r ps152o_pf_dev_orig /var/opengrok/src/PS152-C30-XX-XX

#6 delete .repo .git
    cd /var/opengrok/src/PS152-C30-XX-XX
    find . -name ".git" -type d -exec rm -rf {} \;
    rm -rf .repo

#7 update
    sudo /usr/opengrok/bin/OpenGrok update