# docker 
===================
## run (auto build)
docker run -it --rm <image> <command>

## run in container which is already run
docker exec -it <container> <command>

## attach STDIN/OUT of container which is already run
docker attach <container>

# docker file
===================
## build
docker build -t <new image name>:<tag name> <path to docker file>

# docker-compose
===================
## start
docker-compose -f <docker-compose yml file> up -d

## stop
docker-compose stop

## logs
docker-compose logs -f
