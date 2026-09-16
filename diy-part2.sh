#!/bin/bash
# Description: OpenWrt DIY script part 2 (After Update & Install feeds)

# Modify default IP (默认 192.168.1.1，如需修改为 192.168.10.1 可解开下行注释)
# sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# Set default theme to Argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile || true
