# To use gpu in docker, there are two points to attention
# 1. X11 support (minimal requirement)
# 2. nvidia support

# ATTENTION:
# even docker can offer gui feature,
# you need run on linux os which docker runs.

# To use X11
#   add option to docker run command
# 1. enable local xhost (this is important)
$ xhost local:
# 2. run docker
$ docker run -it --rm \
    --env="DISPLAY" \
    --net=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    ...(image name)
# Test X11 apps
(in container)
$ sudo apt update && sudo apt install -y x11-apps
$ xcalc

# To use nvidia
#   docker from 19.04 support GPU option via --gpus
# 1. Add nvidia-docker repositories
#    refer to https://nvidia.github.io/nvidia-docker/
$ curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
    sudo apt-key add -
$ distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
$ curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list
$ sudo apt-get update
# 2. install GPU support
$ sudo apt-get install -y nvidia-container-toolkit
# 3. restart docker service
$ sudo systemctl restart docker
# 4. check if --gpus is recognized via nvidia docker image
#    you can delete this image after checking or just skip this step
#    nvidia image refer to https://hub.docker.com/r/nvidia/cuda
#
#    it OK if below displayed
#    Sun Sep 15 22:40:52 2019       
#    +-----------------------------------------------------------------------------+
#    | NVIDIA-SMI 430.26       Driver Version: 430.26       CUDA Version: 10.2     |
#    |-------------------------------+----------------------+----------------------+
#    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
#    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
#    |===============================+======================+======================|
#    |   0  GeForce GTX 106...  Off  | 00000000:01:00.0  On |                  N/A |
#    | 38%   32C    P8     6W / 120W |      2MiB /  3016MiB |      0%      Default |
#    +-------------------------------+----------------------+----------------------+
#    
#    +-----------------------------------------------------------------------------+
#    | Processes:                                                       GPU Memory |
#    |  GPU       PID   Type   Process name                             Usage      |
#    |=============================================================================|
#    |  No running processes found                                                 |
#    +-----------------------------------------------------------------------------+
$ docker pull nvidia/cuda:10.2-runtime-ubuntu18.04
$ docker run --rm --gpus all nvidia/cuda nvidia-smi
# 5. run docker with --gpus option
$ docker run -it --rm \
    --gpus all \
    ...(image name)

# X11 + Nvidia
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ];then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ];then
        touch $XAUTH
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

docker run -it --rm \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --env="XAUTHORITY=$XAUTH" \
    --gpus all \
    -v /media/ssd/ros:/shared \
    -v $HOME/.ssh:/etc/skel/.ssh:ro \
    --workdir=/shared \
    --name rosdev-nvidia-melodic \
    ros-nvidia-melodic \
    bash
