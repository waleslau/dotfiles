# git config
if hash git &>/dev/null && [ ! -s ~/.gitconfig ]; then
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
