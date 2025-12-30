FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    build-essential \
    meson \
    ninja-build \
    pkg-config \
    libglib2.0-dev \
    libssl-dev \
    libncursesw5-dev \
    libperl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN git clone https://github.com/irssi/irssi.git .
RUN git rev-parse HEAD > /irssi-version.txt

COPY irssi-user-hostname-servername.patch /src/
RUN git apply --verbose --whitespace=nowarn irssi-user-hostname-servername.patch

RUN meson setup build && \
    meson compile -C build && \
    meson install -C build --destdir /install

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libssl3 \
    libncursesw6 \
    libtinfo6 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /
COPY --from=builder /irssi-version.txt /irssi-version.txt

RUN useradd -m -s /bin/bash irssi

USER irssi
WORKDIR /home/irssi

CMD ["irssi"]
