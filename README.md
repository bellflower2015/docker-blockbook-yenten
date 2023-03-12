# docker-blockbook-yenten

Blockbook Dockerfile for Yenten

## Usage (directly from Docker Hub)

```
docker run \
    --hostname blockbook \
    -it \
    -v "$(PWD)/db:/blockbook/db" \
    -p 9163:9163 \
    -e RPC_USER=user \
    -e RPC_PASS=pass \
    -e RPC_HOST=127.0.0.1 \
    -e RPC_PORT= 9982\
    -e MQ_PORT=38363 \
    -e TZ=Asia/Tokyo \
    bellflower2015/blockbook-yenten
```

Blockbook config directory is `/blockbook/config` and database directory is `/blockbook/db`.

You can set environment variables `RPC_USER`, `RPC_PASS`, `RPC_HOST`, `RPC_PORT`, and `MQ_PORT`, and also set `TZ` to change timezone.

If you want to change hostname displayed, you can set it by `--hostname`.

## Build and run instructions

### Build image

Get source code and make docker image:

```
git clone https://github.com/bellflower2015/docker-blockbook-yenten.git
cd docker-blockbook-yenten
docker build -t blockbook-yenten .
```

Docker images are based on Debian 9 (Stretch).

### Run image

Boot from the built image as described below:

```
docker run [options] blockbook-yenten
```
