# set ~/.password
if [ ! -s "$HOME/.password" ]; then
	echo "create $HOME/.password ..."
	echo -n 'input sudo password: '
	read tmp_pass
	echo $tmp_pass >$HOME/.password
fi
