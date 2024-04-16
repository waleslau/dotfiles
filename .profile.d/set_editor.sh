# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)

if hash vim &>/dev/null; then
	export EDITOR=/usr/bin/vim
fi

if hash nvim &>/dev/null; then
	export EDITOR=/usr/bin/nvim
fi
