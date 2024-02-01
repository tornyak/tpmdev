FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

RUN sed -i 's:^path-exclude=/usr/share/man:#path-exclude=/usr/share/man:' \
    /etc/dpkg/dpkg.cfg.d/excludes && \
    apt update && export DEBIAN_FRONTEND=noninteractive && \
    apt install -y \
    autoconf-archive \
    libcmocka0 \
    libcmocka-dev \
    procps \
    iproute2 \
    build-essential \
    git \
    pkg-config \
    gcc \
    libtool \
    automake \
    libssl-dev \
    uthash-dev \
    autoconf \
    doxygen \
    libjson-c-dev \
    libini-config-dev \
    libcurl4-openssl-dev \
    uuid-dev \
    pandoc \
    acl \
    libltdl-dev \
    libusb-1.0-0-dev \
    libftdi-dev \
    libglib2.0-dev \
    dbus \
    xxd \
    vim \
    man \
    manpages-posix \
    wget \
    dh-autoreconf \
    libtasn1-6-dev \
    net-tools \
    libgnutls28-dev \
    expect \
    gawk \
    socat \
    libfuse-dev \
    libseccomp-dev \
    libjson-glib-dev \
    gnutls-bin

RUN mkdir /tpm
WORKDIR /tpm
RUN git clone https://github.com/tpm2-software/tpm2-tss.git && \
    git clone https://github.com/tpm2-software/tpm2-abrmd.git && \
    git clone https://github.com/tpm2-software/tpm2-tools.git && \
    git clone https://github.com/tpm2-software/tpm2-openssl && \
    git clone https://github.com/stefanberger/libtpms && \
    git clone https://github.com/stefanberger/swtpm


WORKDIR /tpm/tpm2-tss
RUN git checkout 3.2.0 && \
    ./bootstrap && \
    ./configure --with-udevrulesdir=/etc/udev/rules.d --with-udevrulesprefix && \
    make -j4 && \
    make install && \
    ldconfig && \
    ./configure --enable-doxygen-doc && \
    make doxygen-doc

WORKDIR /tpm/tpm2-abrmd
RUN git checkout 2.4.1 && \
    ./bootstrap && \
    ./configure --with-dbuspolicydir=/etc/dbus-1/system.d && \
    make -j4 && \
    make install

WORKDIR /tpm/tpm2-tools
RUN git checkout 5.2 && \
    ./bootstrap && \
    ./configure && \
    make -j4 && \
    make install && \
    ldconfig

WORKDIR /tpm/tpm2-openssl
RUN git checkout 1.1.0 && \
    ./bootstrap && \
    ./configure && \
    make -j4 && \
    make install && \
    ldconfig

WORKDIR /tpm/libtpms
# RUN git checkout v0.9.5 && \
RUN ./autogen.sh --with-tpm2 --with-openssl && \
    make -j4 && \
    make install && \
    ldconfig

WORKDIR /tpm/swtpm
RUN git checkout v0.7.3 && \
    ./autogen.sh --with-openssl --prefix=/usr && \
    make -j4 && \
    make install && \
    ldconfig

WORKDIR /
COPY run.sh /bin/
RUN chmod +x /bin/run.sh
CMD ["run.sh"]

