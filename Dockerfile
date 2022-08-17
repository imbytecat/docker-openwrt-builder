FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
        sudo build-essential gawk gcc-multilib flex git gettext \
        libncurses5-dev libssl-dev python3-distutils rsync \
        unzip zlib1g-dev subversion wget file && \
    apt-get clean && \
    useradd -m openwrt && \
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

USER openwrt

RUN git clone git://git.openwrt.org/openwrt/openwrt.git -b openwrt-22.03 /home/openwrt/openwrt

WORKDIR /home/openwrt/openwrt

RUN svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash && \
    git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon && \
    git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config && \
    scripts/feeds update -a && \
    scripts/feeds install -a

RUN mkdir -p files/etc/openclash/core && \
    wget https://github.com/vernesong/OpenClash/releases/download/Clash/clash-linux-amd64.tar.gz && \
    tar -zxvf clash-linux-amd64.tar.gz && \
    rm -f clash-linux-amd64.tar.gz && \
    mv clash files/etc/openclash/core/clash && \
    rm -rf clash-linux-amd64

RUN sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

COPY .config .
COPY --chmod=0777 build.sh .
