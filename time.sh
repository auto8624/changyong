#!/usr/bin/env bash

set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "请用 root 身份运行此脚本。"
  exit 1
fi

echo "=============================="
echo " 时区与时间同步设置脚本"
echo "=============================="
echo

echo "请选择时区："
echo "1) 北京时间    (Asia/Shanghai)"
echo "2) 日本时间    (Asia/Tokyo)"
echo "3) 洛杉矶时间  (America/Los_Angeles)"
echo "4) 新加坡时间  (Asia/Singapore)"
echo "5) 德国时间    (Europe/Berlin)"
echo "6) 英国时间    (Europe/London)"
echo "7) 阿联酋时间  (Asia/Dubai)"
echo

read -rp "请输入选项数字 [1-7]: " choice

case "$choice" in
  1) TZ_NAME="Asia/Shanghai"; LABEL="北京时间" ;;
  2) TZ_NAME="Asia/Tokyo"; LABEL="日本时间" ;;
  3) TZ_NAME="America/Los_Angeles"; LABEL="洛杉矶时间" ;;
  4) TZ_NAME="Asia/Singapore"; LABEL="新加坡时间" ;;
  5) TZ_NAME="Europe/Berlin"; LABEL="德国时间" ;;
  6) TZ_NAME="Europe/London"; LABEL="英国时间" ;;
  7) TZ_NAME="Asia/Dubai"; LABEL="阿联酋时间" ;;
  *)
    echo "无效选项，脚本退出。"
    exit 1
    ;;
esac

echo
echo "你选择的是：$LABEL ($TZ_NAME)"
echo

if command -v apt >/dev/null 2>&1; then
  echo "检测到 apt，开始安装/更新 systemd-timesyncd..."
  apt update
  apt install -y systemd-timesyncd
else
  echo "未检测到 apt，跳过安装步骤。请确认系统已安装 systemd-timesyncd。"
fi

echo
echo "设置时区为 $TZ_NAME ..."
timedatectl set-timezone "$TZ_NAME"

echo "启用自动时间同步 ..."
systemctl enable --now systemd-timesyncd

echo
echo "当前时间状态："
timedatectl

echo
echo "如果你的系统支持 timesync-status，将显示更详细的同步信息："
timedatectl timesync-status 2>/dev/null || echo "当前系统不支持 timedatectl timesync-status 或暂无详细信息。"

echo
echo "设置完成。"
