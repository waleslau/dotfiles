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

if [ -s /usr/bin/starship ] && [[ $- = *i* ]];then
    if [ -n "$BASH_VERSION" ]; then
        eval "$(starship init bash)"
    fi
    if [ -n "$ZSH_VERSION" ]; then
        eval "$(starship init zsh)"
    fi
else
    echo 'you need install starship'
fi

if hash pnpm 2>/dev/null; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
fi

command -v set-proxy >/dev/null 2>&1 && set-proxy >/dev/null 2>&1

