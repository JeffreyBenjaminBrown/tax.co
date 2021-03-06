# PITFALL: This is not a script.
# It is a collection of one-liners,
# each to be run from the command line individually as needed.

# A trick to quickly edit a Docker-locked file from the host system:
# https://stackoverflow.com/a/26915343

DOCKER_IMAGE_SUFFIX="2021-06-22.tex"

# Start a docker container based on the latest image.
docker run --name tax -itd                   \
  -v /home/jeff/of/tax.co/master:/mnt/tax_co \
  -p 8888:8888 -h 127.0.0.1                  \
  ofiscal/tax.co:latest

# Start a docker container and run jupyter from within it.
docker run --name tax -itd                   \
  --entrypoint=/root/run-jupyter.sh          \
  -v /home/jeff/of/tax.co/master:/mnt/tax_co \
  -p 8888:8888 -h 127.0.0.1                  \
  ofiscal/tax.co:$DOCKER_IMAGE_SUFFIX

# Start a shell within a running container.
# (Once inside, go to the root of the project to do useful stuff,
# like running `python` or `bash/run-makefile.py`.)
docker start tax
docker exec -it tax bash # add -u to do it as root
cd mnt/tax_co/

docker stop tax && docker rm tax

# Build a new image. Do this after making changes to the Dockerfile
# or any of its dependencies.
docker build -f Dockerfile -t \
  ofiscal/tax.co:new .        \
  | tee logs/"build-log.`date`.txt"
tput bel # Make a noise to indicate termination.

# Change the name of the new image.
docker tag ofiscal/tax.co:new ofiscal/tax.co:latest
docker tag ofiscal/tax.co:new ofiscal/tax.co:$DOCKER_IMAGE_SUFFIX
docker rmi ofiscal/tax.co:new

# Upload to DockerHub.
docker push ofiscal/tax.co:latest
docker push ofiscal/tax.co:$DOCKER_IMAGE_SUFFIX
