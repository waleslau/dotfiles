# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# export HISTTIMEFORMAT='%F %T ⚡ '

test -s $HOME/.alias && . $HOME/.alias
test -s $HOME/.profile && . $HOME/.profile

test -x /usr/bin/starship || echo 'you need run "sudo zypper in starship"'
test -x /usr/bin/starship && eval "$(starship init bash)"
