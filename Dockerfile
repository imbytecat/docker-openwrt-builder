FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai \
    apt-get install -y \
        sudo build-essential gawk gcc-multilib flex git gettext \
        libncurses5-dev libssl-dev python3-distutils rsync \
        unzip zlib1g-dev subversion wget file && \
    apt-get clean

RUN useradd -m openwrt && \
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

USER openwrt
WORKDIR /home/openwrt

RUN git clone git://git.openwrt.org/openwrt/openwrt.git -b openwrt-22.03 && \
    svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash openwrt/package/luci-app-openclash && \
    openwrt/scripts/feeds update -a && \
    openwrt/scripts/feeds install -a
