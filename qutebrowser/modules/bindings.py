keys_to_unbind = [
    'b',  # open quickmark prompt
    'B',  'm', 'M'
]

for key in keys_to_unbind:
    config.unbind(key)

bindings = {
    "co": "download-open",
    "ad": "nop",
    "cD": "download-cancel",

    ';d': 'hint all download',
    ';p': "hint images download",

    '<d': "set downloads.location.directory ~/Downloads/",
    '<D': "set downloads.location.directory ~/Documents/",
    '<p': "set downloads.location.directory ~/Pictures/",
    '<w': "set downloads.location.directory ~/Pictures/wallpapers",
    '<a': "set downloads.location.directory ~/Pictures/art",
    '<b': "set downloads.location.directory ~/Books/",
    '<s': "set downloads.location.directory ~/sync/",
    '<u': "set downloads.location.directory ~/UTM/",

    '"m': "hint links spawn mpv {hint-url}",
    '"M': 'spawn mpv {url}',
    'yM': 'yank ;; spawn mpv {url}',
    '"v': 'spawn youtube-dl -o ~/Videos/%(title)s.%(ext)s {url}',
    'aa': "spawn --userscript muzd",
    'aA': "spawn --userscript muzd 2",

    'sl': 'set-cmd-text :open localhost:3000/',
    'sL': 'set-cmd-text :open -t localhost:3000/',

    "<Ctrl-Shift-J>": "tab-move -",
    "<Ctrl-Shift-K>": "tab-move +",
    "<Shift-Escape>": "fake-key <Escape>",
    '<Ctrl-h>': 'history',
    '<Shift-j>': 'tab-prev',
    '<Shift-k>': 'tab-next',
    'h': 'run-with-count 2 scroll left',
    'j': 'scroll-px 0 75',
    'k': 'scroll-px 0 -75',
    'l': 'run-with-count 2 scroll right',
    'ww': 'open -w {url:pretty};;tab-close',

    ',gl': 'config-cycle content.user_stylesheets ./css/gruvbox-light-all-sites.css ""',
    ',gd': 'config-cycle content.user_stylesheets ./css/gruvbox-dark-all-sites.css ""',
    ',sd': 'config-cycle content.user_stylesheets ./css/solarized-dark-all-sites.css ""',
    ',sl': 'config-cycle content.user_stylesheets ./css/solarized-light-all-sites.css ""',
    ',ap': 'config-cycle content.user_stylesheets ./css/apprentice-all-sites.css ""',
    ',dr': 'config-cycle content.user_stylesheets ./css/darculized-all-sites.css ""',

    ',d': "jseval --quiet --file ~/.config/qutebrowser/js/discord_colapse.js",
    ',f': "jseval --quiet --file ~/.config/qutebrowser/js/read-font.js",
    ',t': 'config-cycle tabs.show always never',
    ',b': 'config-cycle statusbar.show always never',
    ',c': 'spawn --userscript theme.sh',

    "cc": "jseval --quiet --file ~/.config/qutebrowser/js/no-cookies.js",
    "xx": "config-cycle content.javascript.enabled false true ;; reload",
    "xr": "hint all right-click",
    "xh": "hint all hover",


    # My custom bookmarks
    "bo": "spawn --userscript qute_bookmarks.py --open",
    "bO": "spawn --userscript qute_bookmarks.py --open --new_tab",
    "bW": "spawn --userscript qute_bookmarks.py --open --new_window",
    "bs": "spawn --userscript qute_bookmarks.py --save",
    "bS": "spawn --userscript qute_bookmarks.py --save --focuspath 'Development'",
    "bR": "spawn --userscript qute_bookmarks.py --remove",
    "bHR": "spawn --userscript qute_bookmarks.py --remove --hard_delete",
    "bx": "spawn --userscript qute_bookmarks.py --random",
    "bXTo": "spawn --userscript qute_bookmarks.py --random --focuspath 'THING'",
    "bXTw": "spawn --userscript qute_bookmarks.py --random --focuspath 'THING' --new_window",
    "bXTt": "spawn --userscript qute_bookmarks.py --random --focuspath 'THING' --new_tab",
    "bl": "spawn --userscript qute_bookmarks.py --list_all",
}

for key, bind in bindings.items():
    config.bind(key, bind)
