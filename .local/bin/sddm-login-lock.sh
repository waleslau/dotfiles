#!/bin/bash
#sleep 1 && loginctl lock-session
loginctl lock-session
# 设置了开机自动登入系统后可能会带来一些安全方面的问题
# 把本脚本加入 ~/.config/autostart 即可在开机后自动登录进桌面环境后立即锁屏(有个缺陷是每次从注销后重新登录也都会触发锁屏，不过无伤大雅)
# KDE里GUI配置入口：设置->开机与关机->自动启动->添加脚本
