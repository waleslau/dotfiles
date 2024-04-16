# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# then add rustup to path
if [ -s "$HOME/.cargo/env" ]; then
	source "$HOME/.cargo/env"
fi
