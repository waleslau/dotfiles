# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

test -z "$PROFILEREAD" && . /etc/profile || true

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

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
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
    export HISTTIMEFORMAT='%F %T ⚡ '
fi

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
    . "$HOME/.cargo/env"
fi

# curl -o- https://cdn.jsdelivr.net/gh/nvm-sh/nvm/install.sh | bash
if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
if [ -n "$BASH_VERSION" ]; then
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi
# nvm install --lts
# nvm use --lts
# nvm alias default node
