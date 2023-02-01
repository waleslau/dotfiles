# Manage my dotfiles

> You can also use [yadm](https://github.com/TheLocehiliosan/yadm) to manage dotfiles without writing aliases. These two methods are compatible (both based on Bare Git Repository).

## start on a new system (migrate to this setup)

```bash
git clone --bare https://github.com/waleslau/dotfiles.git $HOME/.cfg

alias cfgit='/usr/bin/git --git-dir=$HOME/.local/share/dotfiles.GitBareRepo --work-tree=$HOME'

# move all the offending files to ~/.cfg-backup
mkdir -p $HOME/.cfg-backup && cfgit checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.cfg-backup/{}

cfgit checkout
# There may be error messages, need to create some subdirectories manually, then execute the above script again to move the old configuration file, and then checkout again
```

then enjoy it.

## if want to set a new dotfile repo

### 1. Initialize a new repo

```bash
git init --bare $HOME/.local/share/dotfiles.GitBareRepo
alias cfgit='/usr/bin/git --git-dir=$HOME/.local/share/dotfiles.GitBareRepo --work-tree=$HOME'
echo "alias cfgit='/usr/bin/git --git-dir=$HOME/.local/share/dotfiles.GitBareRepo --work-tree=$HOME'" >> $HOME/.bashrc
echo "alias cfgit='/usr/bin/git --git-dir=$HOME/.local/share/dotfiles.GitBareRepo --work-tree=$HOME'" >> $HOME/.zshrc
```

### 2. Add the following to `.gitignote`

```bash
# ignore everything
*
# if want to tracking some file, must be added manually, like this:
# cfgit add -f filename
```

### 3. first commit

```bash
cfgit add -f .gitignore
cfgit commit -m "first commit"
```

Then it can be pushed to the remote repo

```bash
cfgit remote add xxx xxxxx.git
cfgit push -u xxx <branch>
```

enjoy it.

## Inspired by：

- [https://news.ycombinator.com/item?id=11070797](https://news.ycombinator.com/item?id=11070797)
- [https://www.atlassian.com/git/tutorials/dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
- [https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git](https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git)
- [https://catcat.cc/post/diyo4/](https://catcat.cc/post/diyo4/)
