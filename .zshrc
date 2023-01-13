# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

test -s $HOME/.alias && . $HOME/.alias
test -s $HOME/.profile && . $HOME/.profile

test -x /usr/bin/starship || echo 'you need run "sudo zypper in starship"'
test -x /usr/bin/starship && eval "$(starship init zsh)"
