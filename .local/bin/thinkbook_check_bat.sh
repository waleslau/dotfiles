#!/bin/bash

cat /sys/class/power_supply/BAT1/uevent | grep 'Charging' &>/dev/null && bat_charging=1 || bat_charging=0

cat /sys/class/power_supply/BAT1/uevent | grep 'CAPACITY=\<[0-7][0-9]\>' &>/dev/null && bat_full=0

cat /sys/class/power_supply/BAT1/uevent | grep 'CAPACITY=\<[8-9][0-9]\>' &>/dev/null && bat_full=1

echo -e "\n 当前电量：$(grep 'CAPACITY=' /sys/class/power_supply/BAT1/uevent | sed 's/POWER_SUPPLY_CAPACITY=//')"

[ $bat_charging -eq 0 ] && echo -e '\n 不在充电～'
[ $bat_charging -eq 1 ] && echo -e '\n 正在充电～'

[ $bat_charging -eq 0 ] && [ $bat_full -eq 0 ] && echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode && echo -e '\n 已改为允许充电 \n 请重新插入电源线！'

[ $bat_charging -eq 1 ] && [ $bat_full -eq 1 ] && echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode && echo -e '\n 已开启电池保护！'
