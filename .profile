# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

test -z "$PROFILEREAD" && \. /etc/profile || true

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

case ":${PATH}:" in
    *:"$HOME/bin":*) ;;
    *)
        export PATH="$HOME/bin:$PATH"
    ;;
esac

case ":${PATH}:" in
    *:"$HOME/.local/bin":*) ;;
    *)
        export PATH="$HOME/.local/bin:$PATH"
    ;;
esac

case ":${PATH}:" in
    *:"/usr/local/bin":*) ;;
    *)
        export PATH="/usr/local/bin:$PATH"
    ;;
esac

# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# then add rustup to path
if [ -s "$HOME/.cargo/env" ]; then
    \. "$HOME/.cargo/env"
fi

# starship
if [ $TERM = 'xterm-256color' ]; then
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

# pnpm
if hash pnpm 2>/dev/null; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
fi

# ~/.proxy-url
if [ ! -s $HOME/.proxy-url ]; then
    echo "~/.proxy-url not found"
    echo 'example: "socks5h://127.0.0.1:7890"'
    echo "input proxy-url: "
    read tmp_proxy_url
    echo $tmp_proxy_url > $HOME/.proxy-url
fi

# git config
if hash git 2>/dev/null && [ ! -s ~/.gitconfig ] && [ -s ~/.proxy-url ]; then
    git config --global user.name waleslau
    git config --global user.email waleslau@foxmail.com
    git config --global http.https://github.com.proxy $(cat ~/.proxy-url)
    git config --global http.https://codeberg.org.proxy $(cat ~/.proxy-url)
    git config --global init.defaultBranch main
    git config --global core.editor vim
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global delta.line-numbers true
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default
fi

# pip
if hash pip 2>/dev/null && [ ! -s ~/.config\pip\pip.conf ]; then
    pip config set global.index-url https://opentuna.cn/pypi/web/simple
fi

command -v set-proxy >/dev/null 2>&1 && set-proxy >/dev/null 2>&1

