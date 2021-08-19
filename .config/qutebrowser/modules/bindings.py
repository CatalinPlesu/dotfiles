bindings = {
    "ao": "download-open",
    "M": "nop",
    "co": "nop",

    ";m": "hint links spawn mpv {hint-url}",
    ';M': 'spawn mpv {url}',
    ';d': 'spawn youtube-dl -o ~/Videos/%(title)s.%(ext)s {url}',
    ";I": "hint images download",

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

    "xx": "config-cycle content.javascript.enabled false true ;; reload",

    ',gr': 'config-cycle content.user_stylesheets ./css/gruvbox-all-sites.css ""',
    ',sd': 'config-cycle content.user_stylesheets ./css/solarized-dark-all-sites.css ""',
    ',sl': 'config-cycle content.user_stylesheets ./css/solarized-light-all-sites.css ""',
    ',ap': 'config-cycle content.user_stylesheets ./css/apprentice-all-sites.css ""',
    ',dr': 'config-cycle content.user_stylesheets ./css/darculized-all-sites.css ""',

    ',t': 'config-cycle statusbar.show always never ;; config-cycle tabs.show always never',

    "cc": "jseval --quiet --file ~/.config/qutebrowser/js/no-cookies.js",

    "ar": "yank ;; spawn --userscript links.sh",
    "<Ctrl-t>": "spawn --userscript random_page.sh" 

}
for key, bind in bindings.items():
    config.bind(key, bind)
