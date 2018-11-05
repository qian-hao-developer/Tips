# cobra ミラーリポジトリ
cobra=10.73.174.107
cobra(ミラー)からの取得
repo init -u gitosis@cobra:galileo/platform/manifest.git -b galileo-pf-dev --no-repo-verify
repo sync -j8

# pmc サーバーリポジトリ
repo init -u gitosis@10.68.37.29:galileo/platform/manifest.git -b galileo-pf-dev --no-repo-verify

# tftp
## error Access Violation (2)
comment out below line at "/etc/inetd.conf"
    tftp    dgram   udp wait    nobody  /usr/sbin/tcpd  /usr/sbin/in.tftpd  /srv/tftp
## get file from remote
tftp -gr filename remote-ip
## write-image
in build folder of poky
$ ../meta-brcm/scripts/brcm-copy-images.sh -d /tftpboot
in brb
$run tftp_update
