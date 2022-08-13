if status is-interactive
	# Commands to run in interactive sessions can go here
	powerline-daemon -q
	set fish_function_path $fish_function_path "/usr/share/powerline/fish"
	powerline-setup
end
