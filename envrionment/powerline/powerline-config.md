# create config folder
    mkdir ~/.config/powerline

# copy config files
## Ubuntu
    cp -r ~/usr/local/lib/python2.7/dist-packages/powerline/config_files/* ~/.config/powerline/
## macOS
    cp -r ~/usr/local/lib/python2.7/site-packages/powerline/config_files/* ~/.config/powerline/

# modify config.json
    .config/powerline/config.json

    "shell": {
		"colorscheme": "default",
		"theme": "default_leftonly"
	},

    default: git status will shown on the right side
    default_leftonly: git status will shown on the left side before path

# modify theme
    .config/powerline/themes/shell/default_leftonly.json

    {
		"function": "powerline.segments.common.vcs.branch",
		"priority": 40,
		"args": {
			"status_colors": true
		}
	},

    git status will change its color with real status

# reload config
    powerline-daemon --replace
