docker build --platform linux/amd64 -t mac-setup-test -f docker/Dockerfile .
docker run --rm -it mac-setup-test