#!/bin/bash
# Description: OpenWrt DIY script part 1 (Before Update feeds)

# 确保 LuCI feed 明确使用 openwrt-25.12 分支
sed -i 's/^#\(.*openwrt-25.12\)/\1/' feeds.conf.default
sed -i 's/^src-git luci .*openwrt-24.10/#&/' feeds.conf.default || true
sed -i 's/^src-git luci .*openwrt-23.05/#&/' feeds.conf.default || true
