#Catppuccin Theme
import catppuccin

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

# set the flavor you'd like to use
# valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
# last argument (optional, default is False): enable the plain look for the menu rows
catppuccin.setup(c, 'mocha', True)

config.bind('jk', 'mode-leave', mode='insert')
config.bind(',c', 'config-edit')
config.bind(',r', 'config-source')
config.bind('pp', 'open {clipboard}')
config.bind('yy', 'yank')
# Darkmode
config.set("colors.webpage.darkmode.enabled", True)
config.set("colors.webpage.darkmode.policy.images", "never")

# Forward keys to webpage (YouTube player shortcuts)
config.bind('F', 'fake-key f')  # fullscreen
config.bind('M', 'fake-key m')  # mute
config.bind('c', 'fake-key c')  # mute

# Exit hint
config.bind('q', 'mode-leave', mode='hint')

config.bind('ee', 'downloads clear')
