config.bind('<Ctrl-h>', 'history')
config.bind('<Shift-j>', 'tab-prev')
config.bind('<Shift-k>', 'tab-next')


config.bind('h', 'run-with-count 2 scroll left')
config.bind('j', 'run-with-count 2 scroll down')
config.bind('k', 'run-with-count 2 scroll up')
config.bind('l', 'run-with-count 2 scroll right')


config.bind("xjt", "set content.javascript.enabled true")
config.bind("xjf", "set content.javascript.enabled false")

config.bind(';m', 'hint links spawn mpv {hint-url}')

config.bind(',d', 'spawn youtube-dl -o ~/Videos/%(title)s.%(ext)s {url}')
config.bind(',m', 'spawn mpv {url}')


css = "./themes/gruvbox-all-sites.css"
config.bind(',n', f'config-cycle content.user_stylesheets {css} ""')
