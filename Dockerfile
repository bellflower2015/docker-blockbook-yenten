FROM gostartups/golang-rocksdb-zeromq:andromeda AS build

ARG BLOCKBOOK_VERSION=0.3.6

WORKDIR /home

RUN git clone --depth 1 -b v$BLOCKBOOK_VERSION https://github.com/trezor/blockbook.git

WORKDIR /home/blockbook

RUN go build -tags rocksdb_6_16 -ldflags="-X github.com/trezor/blockbook/common.version=$BLOCKBOOK_VERSION -X github.com/trezor/blockbook/common.gitcommit=$(git describe --always --dirty) -X github.com/trezor/blockbook/common.buildtime=$(date --iso-8601=seconds)" \
    && strip blockbook \
    && ./contrib/scripts/build-blockchaincfg.sh bellcoin

FROM debian:stretch-slim

RUN mkdir -p /blockbook/config \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y libsnappy1v5 libzmq5

COPY --from=build /home/blockbook/blockbook /blockbook/
COPY --from=build /home/blockbook/build/blockchaincfg.json /blockbook/config/
COPY --from=build /home/blockbook/static/ /blockbook/static/

WORKDIR /blockbook

COPY docker-entrypoint.sh /tmp/

RUN chmod +x /tmp/docker-entrypoint.sh

ENTRYPOINT [ "/tmp/docker-entrypoint.sh" ]

CMD [ "-sync" ]
