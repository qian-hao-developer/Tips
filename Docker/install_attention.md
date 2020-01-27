# Install
Follow offical document
https://docs.docker.com/install/linux/docker-ce/ubuntu/

# execute as root
Also mentioned in offical document above
    $ sudo usermod -aG docker $USER

# proxy environment
## error msg [$ docker search registry]
Error response from daemon: Get https://index.docker.io/v1/search?q=registry&n=25: dial tcp: lookup index.docker.io on 10.70.175.220:53: no such host
## resolve measure
1. create systemd service for setting proxy environment
    $ sudo mkdir /etc/systemd/system/docker.service.d
    $ sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf
2. write service content [http-proxy.conf] with below:
    [Service]
    Environment="HTTP_PROXY=http://proxy.avc.co.jp:8080/"
3. restart systemd
    $ sudo systemctl daemon-reload
    $ sudo systemctl restart docker
## unrecommand measure
    $ echo "nameserver 8.8.8.8" > /etc/resolv.conf
    ATTENTION:do not use this one

