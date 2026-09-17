# LEDE (OpenWrt) N100 (x86_64) 固件编译仓库

专为 **Intel N100 小主机**（适配 PVE 虚拟化或物理机安装）定制的 LEDE / OpenWrt 固件，基于 [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede) 源码。

---

## 固件特性

- **根分区大小 (Rootfs)**：已设置为 **2048 MB (2G)**，满足后续安装大型软件、下载缓存需求。
- **固件格式与引导**：
  - 格式：`squashfs-combined-efi.img.gz`（支持恢复出厂设置）
  - 引导：支持 **UEFI (OVMF)** 与 **Legacy BIOS** 双引导。
- **网卡与虚拟化驱动**：
  - Intel 2.5G 网卡驱动：`kmod-igc`（针对 N100 常用的 i225-V / i226-V）
  - Realtek 网卡驱动：`kmod-r8125` (2.5G) / `kmod-r8169` (千兆)
  - PVE 虚拟化驱动：`kmod-virtio-net`（半虚拟化网卡）、`virtio-scsi`、`virtio-balloon`
- **磁盘与存储共享**：
  - 文件系统：支持 EXT4、NTFS3、FAT32、exFAT
  - 自动挂载：集成 `automount`
  - 文件共享：集成 `luci-app-samba4` (Samba 4)
- **网络与代理工具**：
  - 科学上网：`luci-app-ssr-plus`、`luci-app-openclash`（含常用内核与依赖）
  - 组网穿透：`luci-app-tailscale-community` / `tailscale`
  - 网络优化加速：`luci-app-turboacc`（Turbo ACC 网络加速，支持 Flow Offloading、BBR 等）
- **外观界面**：官方默认主题 `luci-theme-bootstrap`

---

## 默认访问信息

- **管理后台 IP**：`192.168.50.2`
- **默认用户名**：`root`
- **默认密码**：`password`

---

## 如何使用 GitHub Actions 自动编译？

### 第一步：创建 GitHub 仓库
1. 登录你的 GitHub 账号，点击右上角 `+` -> **New repository**。
2. 仓库名随意填（例如 `lede-n100`），公开（Public）或私有（Private）均可。

### 第二步：开启 GitHub Actions 写权限（用于自动发布 Releases）
1. 打开该仓库的 **Settings** -> **Actions** -> **General**。
2. 滚动到底部找到 **Workflow permissions**。
3. 选择 **Read and write permissions** 并点击 **Save** 保存。

### 第三步：将本地目录文件上传到 GitHub
在当前本地目录 `/home/karamazov/lede-build` 中执行：
```bash
cd /home/karamazov/lede-build
git init
git add .
git commit -m "feat: init lede config for n100 with 2G rootfs"
git branch -M main
git remote add origin https://github.com/<你的GitHub用户名>/<你的仓库名>.git
git push -u origin main
```

### 第四步：触发编译
1. 打开 GitHub 仓库页面，点击顶部的 **Actions** 标签。
2. 在左侧选择 **Build OpenWrt LEDE for N100 (x86_64)**。
3. 点击右侧 **Run workflow** 下拉按钮，点击绿色的 **Run workflow**。
4. GitHub 云端服务器将自动开始执行（一般 40~50 分钟内完成）。

### 第五步：下载固件并导入 PVE
编译完成后，可以在仓库右侧的 **Releases** 或 Actions 的 **Artifacts** 中下载固件压缩包：
- 解压后得到：`openwrt-x86-64-generic-squashfs-combined-efi.img`
- 在 PVE 中创建好 Linux 虚拟机后（BIOS 选 OVMF UEFI，网卡选 VirtIO 或硬件直通）：
  ```bash
  # 将解压后的 img 文件上传至 PVE，执行导入磁盘：
  qm importdisk <VM_ID> openwrt-x86-64-generic-squashfs-combined-efi.img local-lvm
  ```
- 导入后在 PVE 虚拟机硬件中双击未挂载的磁盘，总线选 SCSI 并添加到开机引导项中即可开机。
