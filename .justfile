fmt:
    just --fmt --unstable
    shfmt -w .profile
    shfmt -w .profile.d/*

enable_thinkbook_battery_care:
    echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode

disable_thinkbook_battery_care:
    echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode

n-install:
    curl -L https://raw.gitmirror.com/tj/n/master/bin/n >$HOME/.local/bin/n
    chmod +x $HOME/.local/bin/n
    env N_PREFIX=$HOME/.n PATH="$HOME/.n/bin:$PATH" $HOME/.local/bin/n lts

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

init_base-repo:
    sudo zypper clean
    sudo zypper mr --disable --all
    sudo zypper ar -cfg 'https://mirrors.bfsu.edu.cn/opensuse/tumbleweed/repo/oss/' mirror-oss
    sudo zypper ar -cfg 'https://mirrors.bfsu.edu.cn/opensuse/tumbleweed/repo/non-oss/' mirror-non-oss

init_utility:
    sudo zypper ref
    sudo zypper in zsh fish btop htop dog exa pandoc git-delta \
        upx wine yakuake brasero \
        fprintd ouch dust ncdu yadm sd fd fzf ripgrep gimp kamoso kitty \
        qps qpwgraph aria2 falkon mpv filelight flameshot simplescreenrecorder peek\
        fcitx5 fcitx5-chinese-addons fcitx5-rime tealdeer starship \
        papirus-icon-theme keepassxc git-delta font-viewer fontweak proxychains-ng opi \
        tesseract-ocr tesseract-ocr-traineddata-chi_sim tesseract-ocr-traineddata-chi_sim_vert
    sudo zypper in rustup
    rustup default stable
    cargo install dufs
    cargo install xh
    # cargo install miniserver
    # cargo install fselect

init_docker-and-podman:
    sudo zypper in podman docker python311-docker-compose python311-podman-compose jq
    sudo usermod -a -G docker $USER
    cat /etc/docker/daemon.json > /tmp/docker.daemon.json
    echo '{"registry-mirrors":["https://dockerproxy.com","https://mirror.baidubce.com"]}' >> /tmp/docker.daemon.json
    cat /tmp/docker.daemon.json | jq -s add > /tmp/docker.daemon.mirrors.json
    sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.bak
    sudo cp /tmp/docker.daemon.mirrors.json /etc/docker/daemon.json
    sudo cp /etc/containers/registries.conf /etc/containers/registries.conf.bak
    sudo cp .config/containers/registries.conf /etc/containers/registries.conf

init-soft-opi:
    echo 'socks5 127.0.0.1 7890' | sudo tee -a /etc/proxychains.conf
    sudo vim /etc/proxychains.conf
    sudo proxychains4 opi codecs
    sudo sd 'ftp.gwdg.de/pub/linux/misc/packman' 'mirrors.bfsu.edu.cn/packman' /etc/zypp/repos.d/packman.repo
    sudo proxychains4 opi msedge
    sudo proxychains4 opi vscode
    sudo proxychains4 opi sarasa # sarasa-gothic-fonts
    sudo proxychains4 opi sarasa # sarasa-mono-sc-nerd-fonts
    sudo proxychains4 opi joplin

sys-init-fstab_win-disk:
    mkdir -p $HOME/windows/970PLUS
    mkdir -p $HOME/windows/WinOS
    mkdir -p $HOME/windows/WinData
    echo "/dev/nvme0n1p3 $HOME/windows/WinOS   ntfs ro,fmask=333,dmask=222,uid=1000,gid=1000 0  0" | sudo tee -a /etc/fstab
    echo "/dev/nvme0n1p4 /$HOME/windows/WinData ntfs rw,fmask=133,dmask=022,uid=1000,gid=1000 0  0" | sudo tee -a /etc/fstab
    echo "/dev/nvme1n1p1 $HOME/windows/970PLUS ntfs rw,fmask=133,dmask=022,uid=1000,gid=1000 0  0" | sudo tee -a /etc/fstab
    sudo vim /etc/fstab

ssh_gen_pubkey:
    yadm decrypt # password contains 4 characters
    cd ~/.ssh && ssh-keygen -y -f id_rsa > id_rsa.pub

rime-install:
    cd ~/bin && curl -fsSL -O https://raw.githubusercontents.com/rime/plum/master/rime-install
    grep '/usr/bin' ~/bin/rime-install && chmod +x ~/bin/rime-install
    sed -i 's/github.com/ghproxy.com\/github.com/g' ~/bin/rime-install
    env rime_frontend=fcitx5-rime bash rime-install :preset iDvel/rime-ice:others/recipes/full

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
