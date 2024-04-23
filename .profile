# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

#test -z "$PROFILEREAD" && source /etc/profile || true

# if running bash
# if [ -n "$BASH_VERSION" ]; then
#     echo "fine!"
# fi

# set $PATH
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/idea/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"

# Load profiles from /etc/profile.d
if test -d ~/.profile.d/; then
	for profile in ~/.profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi
