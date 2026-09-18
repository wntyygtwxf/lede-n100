#!/bin/bash
# Description: OpenWrt DIY script part 2 (After Update & Install feeds)

# 1. 设置后台默认 IP 为 192.168.50.2
sed -i 's/192.168.1.1/192.168.50.2/g' package/base-files/files/bin/config_generate

# 2. 将源码中写死的 24.10.5 彻底修正为真正的 25.12
sed -i 's/24.10.5/25.12/g' include/version.mk
sed -i 's/24.10.5/25.12/g' package/base-files/image-config.in

# 3. 将 zzz-default-settings 中停留在 5 月写死的 R26.05.20 自动替换为当前编译日期的最新版本号 (如 R26.09.18)
CURRENT_REVISION="R$(date +%y.%m.%d)"
sed -i "s/R26.05.20/${CURRENT_REVISION}/g" package/lean/default-settings/files/zzz-default-settings

# 4. 预置 OpenClash 运行所需的 Mihomo (Clash.Meta) 核心，免去初次开机手动下载核心
mkdir -p files/etc/openclash/core
curl -sL https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64.tar.gz -o /tmp/meta.tar.gz
if [ -s /tmp/meta.tar.gz ]; then
    tar -zxvf /tmp/meta.tar.gz -C /tmp/
    chmod +x /tmp/clash
    mv /tmp/clash files/etc/openclash/core/clash_meta
    rm -f /tmp/meta.tar.gz
fi
