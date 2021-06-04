# run
docker run --rm -it -v $PWD:$PWD -v $HOME/.ssh:/etc/skel/.ssh:ro crops/poky:u18 --workdir=$PWD
