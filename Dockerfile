FROM gostartups/golang-rocksdb-zeromq:andromeda AS build

ARG BLOCKBOOK_VERSION=0.3.6

WORKDIR /home

RUN git clone --depth 1 -b v$BLOCKBOOK_VERSION https://github.com/trezor/blockbook.git

COPY diff.patch /home/blockbook/diff.patch
COPY yenten.json /home/blockbook/configs/coins/yenten.json

WORKDIR /home/blockbook

RUN patch -p1 < diff.patch
RUN mkdir -p bchain/coins/yenten

COPY yentenparser.go /home/blockbook/bchain/coins/yenten/yentenparser.go
COPY yentenparser_test.go /home/blockbook/bchain/coins/yenten/yentenparser_test.go
COPY yentenrpc.go /home/blockbook/bchain/coins/yenten/yentenprc.go

RUN go build -tags rocksdb_6_16 -ldflags="-X github.com/trezor/blockbook/common.version=$BLOCKBOOK_VERSION -X github.com/trezor/blockbook/common.gitcommit=$(git describe --always --dirty) -X github.com/trezor/blockbook/common.buildtime=$(date --iso-8601=seconds)" \
    && strip blockbook \
    && ./contrib/scripts/build-blockchaincfg.sh yenten

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
