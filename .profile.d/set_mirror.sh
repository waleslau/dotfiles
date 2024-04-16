# npmmirror
if hash npm &>/dev/null && [ ! -s ~/.npmrc ]; then
	npm config set registry='https://registry.npmmirror.com'
fi
# pypi mirror
if hash pip &>/dev/null && [ ! -s $HOME/.config/pip/pip.conf ]; then
	pip config set global.index-url https://mirrors.bfsu.edu.cn/pypi/web/simple
	pip config set install.trusted-host mirrors.bfsu.edu.cn
fi
