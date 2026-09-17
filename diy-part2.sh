#!/bin/bash
# Description: OpenWrt DIY script part 2 (After Update & Install feeds)

# 1. 设置后台默认 IP 为 192.168.50.2
sed -i 's/192.168.1.1/192.168.50.2/g' package/base-files/files/bin/config_generate

# 2. 预置 OpenClash 运行所需的 Mihomo (Clash.Meta) 核心，免去初次开机手动下载核心
mkdir -p files/etc/openclash/core
curl -sL https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64.tar.gz -o /tmp/meta.tar.gz
if [ -s /tmp/meta.tar.gz ]; then
    tar -zxvf /tmp/meta.tar.gz -C /tmp/
    chmod +x /tmp/clash
    mv /tmp/clash files/etc/openclash/core/clash_meta
    rm -f /tmp/meta.tar.gz
fi
