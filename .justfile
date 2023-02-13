@_default:
    just --choose

fmt_justfile:
    just --fmt --unstable

init_linuxqq-bwrap:
    #!/usr/bin/env bash
    cd /tmp
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
    sudo cp -vf wps-bwrap /usr/bin/wps-bwrap
    sudo rm -f /usr/share/applications/wps-office*
    sd '/usr/bin/wps-bwrap' "$HOME/bin/wps" wps-office-bwrap.desktop
    cp -vf wps-bwrap ~/bin/wps
    cp -vf wps-office-bwrap.desktop ~/.local/share/applications/wps-office-bwrap.desktop

# examples
_python:
    #!/usr/bin/env python3
    print('Hello from python!')

_js:
    #!/usr/bin/env node
    console.log('Greetings from JavaScript!')

_bash:
    #!/usr/bin/env bash
    set -euxo pipefail # 兼容性配置 https://just.systems/man/zh/chapter_41.html
    hello='Yo'
    echo "$hello from Bash!"

_check_os:
    @[ {{ os() }} = 'windows' ] && echo 'Hello from Windows'
    @[ {{ os() }} = 'linux' ] && echo 'Hello from Linux'

_test arg:
    echo '{{ arg }}'
