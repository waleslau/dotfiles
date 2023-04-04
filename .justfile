fmt:
    just --fmt --unstable

apply_changes: fmt
    env LANG=en_US.UTF-8 yadm commit -a -m "update"

_init_linuxqq-bwrap:
    #!/usr/bin/env bash
    # 目前这坨脚本不太好使了, 改用 Flatpak 版了
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
    test -d wps-office-bwrap || git clone https://aur.archlinux.org/wps-office-bwrap.git  && cd wps-office-bwrap
    git pull
    sudo cp -vf ~/.local/bin/wps-bwrap /usr/bin/wps-bwrap
    cp -vf ~/.local/bin/wps-bwrap ~/bin/wps
    sudo rm -f /usr/share/applications/wps-office*
    sudo cp -vf wps-office-bwrap.desktop /usr/share/applications/wps-office-bwrap.desktop

sys-init:
    sudo zypper clean
    sudo zypper mr --disable --all
    sudo zypper ar -cfg 'https://mirrors.bfsu.edu.cn/opensuse/tumbleweed/repo/oss/' mirror-oss
    sudo zypper ar -cfg 'https://mirrors.bfsu.edu.cn/opensuse/tumbleweed/repo/non-oss/' mirror-non-oss
    sudo zypper ref

sys-init-soft:
    sudo zypper in proxychains-ng opi
    echo 'socks5 127.0.0.1 7890' | sudo tee -a /etc/proxychains.conf
    sudo vim /etc/proxychains.conf
    sudo proxychains4 opi codecs
    sudo sd 'ftp.gwdg.de/pub/linux/misc/packman' 'mirrors.bfsu.edu.cn/packman' /etc/zypp/repos.d/packman.repo
    sudo proxychains4 opi msedge
    sudo proxychains4 opi vscode
    sudo proxychains4 opi sarasa-mono-sc-nerd-fonts
    sudo proxychains4 zypper in zsh fish btop htop dog exa \
        upx wine yakuake brasero \
        fprintd ouch dust yadm sd fd fzf ripgrep gimp jq kamoso kitty \
        peek qps qpwgraph aria2 falkon mpv \
        fcitx5 fcitx5-chinese-addons rime tealdeer starship \
        podman docker python311-docker-compose python311-podman-compose \
        papirus-icon-theme keepassxc git-delta font-viewer fontweak sarasa-gothic-fonts
    sudo usermod -a -G docker $USER
    sudo usermod -a -G libvirt $USER

sys-init-fstab_win-disk:
    mkdir -p $HOME/windows/970PLUS
    mkdir -p $HOME/windows/WinOS
    mkdir -p $HOME/windows/WinData
    echo "/dev/nvme0n1p3 $HOME/windows/WinOS   ntfs ro,fmask=333,dmask=222,uid=1000,gid=1000 0  0" | sudo tee -a /etc/fstab
    echo "/dev/nvme0n1p4 /$HOME/windows/WinData ntfs rw,fmask=133,dmask=022,uid=1000,gid=1000 0  0" | sudo tee -a /etc/fstab
    echo "/dev/nvme1n1p1 $HOME/windows/970PLUS ntfs rw,fmask=133,dmask=022,uid=1000,gid=1000 0  0" | sudo tee -a /etc/fstab
    sudo vim /etc/fstab

# The decryption password contains 4 characters
ssh_gen_pubkey:
    cd ~/.ssh && ssh-keygen -y -f id_rsa > id_rsa.pub

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
