bindings = {
    "ao": "download-open",
    "co": "nop",

    ';d': 'set downloads.location.directory ~/Downloads/ ;; download',
    ';p': "set downloads.location.directory ~/Pictures/ ;; hint images download",
    ';w': "set downloads.location.directory ~/Pictures/wallpapers/",
    ';f': "set downloads.location.directory ~/Documents/",

    '"m': "hint links spawn mpv {hint-url}",
    '"M': 'spawn mpv {url}',
    'yM': 'yank ;; spawn mpv {url}',
    '"v': 'spawn youtube-dl -o ~/Videos/%(title)s.%(ext)s {url}',
    'aa': "yank ;; spawn --userscript muzd {url}",
    '"si': "hint images spawn --userscript tab.sh https://www.google.com/imghp?q={hint-url}",

    '<Ctrl-i>': "hint images spawn --userscript tab.sh https://www.google.com/imghp?q={hint-url}",
    '<Ctrl-s>': "set-cmd-text :open ;; command-history-prev ;; rl-beginning-of-line ;; rl-forward-word ;; rl-forward-word ;; rl-backward-kill-word",

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
