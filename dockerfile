FROM debian:bookworm-slim AS builder
WORKDIR /build

RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev

COPY ./pfdtool /build/pfdtool
COPY ./sfopatcher /build/sfopatcher

RUN cd /build/pfdtool/src && make
RUN cd /build/sfopatcher/src && make


FROM debian:bookworm-slim
COPY --from=builder /build/pfdtool/src/pfdtool /usr/local/bin/
COPY --from=builder /build/sfopatcher/src/sfopatcher /usr/local/bin/