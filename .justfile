@_default:
    just --choose

fmt:
    just --fmt --unstable

_init_linuxqq-bwrap:
    #!/usr/bin/env bash
    # TODO：目前这坨脚本不太好使了，有时间再继续折腾
    cd /tmp
    curl -O https://dldir1.qq.com/qqfile/qq/QQNT/2355235c/linuxqq_3.1.1-11223_amd64.deb
    test -d linuxqq-nt-bwrap && rm -rf linuxqq-nt-bwrap
    git clone https://aur.archlinux.org/linuxqq-nt-bwrap.git
    cd linuxqq-nt-bwrap
    sed -i '/snapd-xdg-open/d' start.sh
    sed -i '/flatpak-xdg-utils/d' start.sh
    i=1; while [ $i -le 10 ]; do sed -i '$d' start.sh; ((i++)); done
    sudo mkdir -p "/opt/QQ/workarounds"
    sudo cp -vf xdg-open.sh /opt/QQ/workarounds/
    sudo cp -vf config.json /opt/QQ/workarounds/config.json
    sudo cp -vf start.sh /opt/QQ/
    cp -v /usr/share/applications/qq.desktop ~/.local/share/applications
    sed -i "s|/opt/QQ/qq|/opt/QQ/start.sh|" ~/.local/share/applications/qq.desktop
    ln -svf /opt/QQ/start.sh ~/bin/qq

init_wps-bwrap:
    #!/usr/bin/env bash
    cd /tmp
    test -d wps-office-bwrap && rm -rf wps-office-bwrap
    git clone https://aur.archlinux.org/wps-office-bwrap.git
    cd wps-office-bwrap
    sudo cp -vf ~/.local/bin/wps-bwrap /usr/bin/wps-bwrap
    cp -vf ~/.local/bin/wps-bwrap ~/bin/wps
    sudo rm -f /usr/share/applications/wps-office*
    sudo cp -vf wps-office-bwrap.desktop /usr/share/applications/wps-office-bwrap.desktop

sys-init:
    mkdir -p /home/idea/windows/970PLUS
    mkdir -p /home/idea/windows/WinOS
    mkdir -p /home/idea/windows/WinData
    echo '/dev/nvme0n1p3 /home/idea/windows/WinOS   ntfs ro,fmask=333,dmask=222,uid=1000,gid=1000 0  0' | sudo tee -a /etc/fstab
    echo '/dev/nvme0n1p4 /home/idea/windows/WinData ntfs rw,fmask=133,dmask=022,uid=1000,gid=1000 0  0' | sudo tee -a /etc/fstab
    echo '/dev/nvme1n1p1 /home/idea/windows/970PLUS ntfs rw,fmask=133,dmask=022,uid=1000,gid=1000 0  0' | sudo tee -a /etc/fstab
    sudo zypper clean
    sudo zypper mr --disable --all
    sudo zypper ar -cfg 'https://mirrors.bfsu.edu.cn/opensuse/tumbleweed/repo/oss/' mirror-oss
    sudo zypper ar -cfg 'https://mirrors.bfsu.edu.cn/opensuse/tumbleweed/repo/non-oss/' mirror-non-oss
    sudo zypper ref
    sudo zypper in proxychains-ng opi
    sudo usermod -a -G docker idea
    sed -i '$d' /etc/proxychains.conf
    sed -i '$d' /etc/proxychains.conf
    echo 'socks5 127.0.0.1 7890' | sudo tee -a /etc/proxychains.conf
    sudo proxychains4 opi codecs
    sudo proxychains4 opi msedge
    sudo proxychains4 opi vscode
    sudo proxychains4 zypper in zsh fish btop htop dog exa fontweak \
        upx wine yakuake brasero \
        fprintd ouch dust yadm fd fzf ripgrep podman docker gimp jq kamoso kitty \
        peek qps qpwgraph mpv aria2 falkon \
        fcitx5 fcitx5-chinese-addons rime

# examples
_py:
    #!/usr/bin/env python3
    print('Hello from python!')

_js:
    #!/usr/bin/env node
    console.log('Greetings from JavaScript!')

_sh:
    #!/usr/bin/env sh
    set -euxo pipefail # 兼容性配置 https://just.systems/man/zh/chapter_41.html
    hello='Yo'
    echo "$hello from Bash!"

_os:
    @[ {{ os() }} = 'windows' ] && echo 'Hello from Windows'
    @[ {{ os() }} = 'linux' ] && echo 'Hello from Linux'

_test arg:
    echo '{{ arg }}'
