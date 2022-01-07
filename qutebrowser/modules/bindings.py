bindings = {
    "ao": "download-open",
    "co": "nop",

    ';d': 'hint all download',
    ';p': "hint images download",

    '<d': "set downloads.location.directory ~/Downloads/",
    '<D': "set downloads.location.directory ~/Documents/",
    '<p': "set downloads.location.directory ~/Pictures/",
    '<w': "set downloads.location.directory ~/Pictures/wallpapers",
    '<a': "set downloads.location.directory ~/Pictures/art",
    '<b': "set downloads.location.directory ~/Books/",

    '"m': "hint links spawn mpv {hint-url}",
    '"M': 'spawn mpv {url}',
    'yM': 'yank ;; spawn mpv {url}',
    '"v': 'spawn youtube-dl -o ~/Videos/%(title)s.%(ext)s {url}',
    'aa': "yank ;; spawn --userscript muzd {url}",
    'aA': "yank ;; spawn --userscript muzd_playlist {url}",
    'aba': "yank ;; spawn --userscript read_later.sh",
    'abo': "spawn --userscript read_later_open.sh",

    'sl': 'set-cmd-text :open -t localhost',

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

    "ar": "yank ;; spawn --userscript links.sh",
    "al": "spawn --userscript open_links.sh",
    "<Ctrl-t>": "spawn --userscript random_page.sh" 

}
for key, bind in bindings.items():
    config.bind(key, bind)
