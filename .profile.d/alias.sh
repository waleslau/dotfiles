# To detect whether the command exists in the system
# use `command -v command` or `hash command`
# `hash` can detect binary only

function init-atuin {
	hash atuin || sudo pacman -S atuin
	atuin import auto
	rm -rf ~/.local/share/blesh_git_repo
	mkdir -p ~/.local/share/blesh_git_repo
	bash -c 'cd ~/.local/share/blesh_git_repo \
	  && git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git \
	  && make -C ble.sh install PREFIX=~/.local'
  }

function set-proxy {
	host_port=10.0.2.2:7897
	socks5_url=socks5h://$host_port
	http_url=http://$host_port

	# git
	git config --global http.proxy $http_url
	# git config --global http.https://github.com.proxy $socks5_url
	# git config --global http.https://codeberg.org.proxy $socks5_url

	# ssh
	echo "Host github.com
    Hostname ssh.github.com
    Port 443
    User git
    ProxyCommand nc -v -x $host_port %h %p" >$HOME/.ssh/config
	# ProxyCommand nc -v -x $url %h %p" | tee $HOME/.ssh/config

	# env
	export all_proxy=$socks5_url
	export http_proxy=$http_url
	export https_proxy=$http_url
	export no_proxy=192.168.*.*,172.16.*.*,*.local,localhost,127.0.0.1
	export ALL_PROXY=$socks5_url
	export HTTP_PROXY=$http_url
	export HTTPS_PROXY=$http_url
	export NO_PROXY=$no_proxy
	env | grep $host_port
}

## 让代理对 Docker 也生效的方法（未验证）
#     /etc/systemd/system/docker.service.d/http-proxy.conf
#        [Service]
#        Environment=http_proxy=http://proxyip:8118 https_proxy=http://proxyip:8118
#     然后热重载
#         systemctl daemon-reload
#         systemctl restart docker.service
#     这个法子好硬核的样子，来源：https://cloud.tencent.com/developer/article/1627708
# 其他：https://dockerproxy.com/docs

function unset-proxy {
	# git
	git config --global --unset http.proxy
	# git config --global --unset http.https://github.com.proxy
	# git config --global --unset http.https://codeberg.org.proxy
	# sed -i '/http/d;/proxy/d' .gitconfig

	# ssh
	sed -i '/ProxyCommand/d' ~/.ssh/config

	# env
	unset all_proxy
	unset ALL_PROXY
	unset http_proxy
	unset https_proxy
	unset HTTP_PROXY
	unset HTTPS_PROXY
	unset no_proxy
	unset NO_PROXY
	env | grep PROXY
	env | grep proxy
	echo "ok"
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
if hash notify-send &>/dev/null; then
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

if hash nvim &>/dev/null; then
	alias vim="nvim"
fi

rg-fzf() {
	RG_PREFIX="rg --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort \
			--preview="[[ ! -z {} ]] && rg --pretty --context 5 {q} {}" \
			--phony -q "$1" \
			--bind "change:reload:$RG_PREFIX {q}" \
			--preview-window="70%:wrap"
	)" &&
		if hash xdg-open &>/dev/null; then
			echo "opening $file"
			xdg-open "$file"
		else
			echo "fileName: $file"
		fi
}

alias fcd='cd $(fd -HI -t d | fzf)'
alias fvi='vim $(fd -HI -t f | fzf)'
alias fvi-sudo='cat ~/.password | sudo -S vim $(fd -HI -t f | fzf)'

if hash exa &>/dev/null; then
	alias ls='exa'
	alias l='exa -l --all --group-directories-first --git'
	alias ll='exa -l --all --all --group-directories-first --git'
	alias lt='exa -T --git-ignore --level=2 --group-directories-first'
	alias llt='exa -lT --git-ignore --level=2 --group-directories-first'
	alias lT='exa -T --git-ignore --level=4 --group-directories-first'
else
	alias l='ls -lah'
	alias ll='ls -alF'
	alias la='ls -A'
fi

if hash xdg-open &>/dev/null; then
	alias clashui-web1='xdg-open http://yacd.haishan.me/'
	alias clashui-web2='xdg-open http://clash.razord.top/'
fi

if hash wps-office &>/dev/null; then
	alias wps-office="QT_SCREEN_SCALE_FACTORS=1 wps-office"
fi

if hash kquitapp5 &>/dev/null; then
	alias plasmashell-restart="kquitapp5 plasmashell && kstart plasmashell"
fi

if hash nvidia-smi &>/dev/null; then
	alias nvidia_offload='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'
fi

# https://github.com/ystyle/kaf-cli
alias txt_to_epub='kaf-cli -format epub -lang zh -tips=0 -filename'

# http://iscute.cn/chfs
alias chfs='chfs --port=8888'

alias qcow2_compress="qemu-img convert -p -c -o compression_type=zstd -f qcow2 -O qcow2"
alias qcow2_password_init="virt-customize --root-password password:root --run-command 'echo UGVybWl0Um9vdExvZ2luIHllcwo= | base64 -d >> /etc/ssh/sshd_config' -a"
alias ref-dup-dl-only='cat ~/.password | sudo -S proxychains4 zypper ref && sudo zypper dup --no-recommends --download-only'
alias en='LANG="en_US.UTF-8"'
alias git-pushall='git remote | xargs -i git push {}'
alias git-apply-changes='git commit -a -m "update"'
alias yadm-pushall='yadm remote | xargs -i yadm push {}'
alias yadm-apply-changes='yadm commit -a -m "update"'

alias clang-format="clang-format --style=WebKit"
alias paste-farsee='curl -F "c=@-" "https://fars.ee/"'
alias paste-termbin="nc termbin.com 9999"
alias ping='ping -c 5'
alias ip-lan='curl -s http://myip.ipip.net | sd "\n" "\t"'
alias ip-wan='curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 Edg/109.0.1518.52" https://api.ip.sb/geoip | jq ".ip , .country" | sd "\"" "" | sd "\n" "\t"'
alias ip-wan1='curl -s http://ipinfo.io/ip'
#alias www="miniserve --index=index.html -v"
alias www="python3 -m http.server --bind 0.0.0.0 8888"
alias ungit='ungit --port=8888'
alias s-p='sudo proxychains4'
alias zypper='proxychains4 zypper'
alias happyn-stat='netcat -u 127.0.0.1 5644'
