#!/bin/bash

cat /sys/class/power_supply/BAT1/uevent | grep 'Not charging' &>/dev/null && bat_charging=0 || bat_charging=1

cat /sys/class/power_supply/BAT1/uevent | grep 'CAPACITY=\<[0-7][0-9]\>' &>/dev/null && bat_full=0 || bat_full=1

[ $bat_charging -eq 0 ] && [ $bat_full -eq 0 ] && echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode && echo -e '\n 已修改充电状态 \n 请重新插入电源线！'

[ $bat_charging -eq 1 ] && echo -e '\n 正在充电～'

[ $bat_full -eq 1 ] && echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode && echo '\n 已修改充电状态 \n 请重新插入电源线！'
