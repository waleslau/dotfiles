# Manage my dotfile

## start on a new system (migrate to this setup)

```bash
git clone --bare https://github.com/waleslau/dotfiles.git $HOME/.cfg

alias cfgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

cfgit config --local status.showUntrackedFiles no

# move all the offending files to ~/.cfg-backup
mkdir -p $HOME/.cfg-backup && cfgit checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.cfg-backup/{}

cfgit checkout
# There may be error messages, need to create some subdirectories manually, then execute the above script again to move the old configuration file, and then checkout again
```

then enjoy it.

## if want to set a new dotfile repo

```bash
git init --bare $HOME/.cfg
alias cfgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
cfgit config --local status.showUntrackedFiles no
echo "alias cfgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
echo "alias cfgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.zshrc
```

### how to use

```bash
cfgit status
cfgit add .vimrc
cfgit commit -m "Add vimrc"
cfgit add .bashrc
cfgit commit -m "Add bashrc"
cfgit remote add xxx xxxxx.git
cfgit push -u xxx main
```

enjoy it.

## Inspired by：

- <https://news.ycombinator.com/item?id=11070797>
- <https://www.atlassian.com/git/tutorials/dotfiles>
- <https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git>
- <https://catcat.cc/post/diyo4/>
