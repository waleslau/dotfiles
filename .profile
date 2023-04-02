# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

test -z "$PROFILEREAD" && source /etc/profile || true

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
if hash nvim 2>/dev/null; then
    export EDITOR=/usr/bin/nvim
fi
# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# Some people don't like fortune. If you uncomment the following lines,
# you will have a fortune each time you log in ;-)

#if [ -x /usr/bin/fortune ] ; then
#    echo
#    /usr/bin/fortune
#    echo
#fi

# -- waleslau --

# if running bash
# if [ -n "$BASH_VERSION" ]; then
#     echo "fine!"
# fi

# set $PATH
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# then add rustup to path
if [ -s "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# starship
if [ $TERM = 'linux' ]; then
    export LANG='en_US.UTF-8'
else
    if [ -s /usr/bin/starship ]; then
        if [ -n "$BASH_VERSION" ]; then
            eval "$(starship init bash)"
        fi
        if [ -n "$ZSH_VERSION" ]; then
            eval "$(starship init zsh)"
        fi
    else
        echo 'you need install starship'
    fi
fi

# set ~/.password
if [ ! -s "$HOME/.password" ]; then
    echo "create $HOME/.password ..."
    echo -n 'input sudo password: '
    read tmp_pass
    echo $tmp_pass >$HOME/.password
fi

# git config
if hash git 2>/dev/null && [ ! -s ~/.gitconfig ]; then
    git config --global user.name waleslau
    git config --global user.email waleslau@foxmail.com
    git config --global init.defaultBranch main
    git config --global core.editor vim
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global delta.line-numbers true
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default
    git config --global alias.last 'log -1 HEAD'
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.co checkout
    git config --global alias.ci commit
    git config --global alias.st status
    git config --global alias.sw switch
    git config --global alias.lo "log --format=oneline"
fi

# pypi mirror
if hash pip 2>/dev/null && [ ! -s $HOME/.config/pip/pip.conf ]; then
    pip config set global.index-url https://mirrors.bfsu.edu.cn/pypi/web/simple
fi

# https://github.com/tj/n
export N_PREFIX=$HOME/.n
export PATH="$HOME/.n/bin:$PATH"

# npmmirror
if hash npm 2>/dev/null && [ ! -s ~/.npmrc ]; then
    npm config set registry='https://registry.npmmirror.com'
fi
