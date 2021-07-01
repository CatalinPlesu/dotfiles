bindings = {
    "co": "download-open",
    "M": "nop",

    ";m": "hint links spawn mpv {hint-url}",
    ';M': 'spawn mpv {url}',
    ';d': 'spawn youtube-dl -o ~/Videos/%(title)s.%(ext)s {url}',
    ";I": "hint images download",

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

    "xjt": "set content.javascript.enabled true",
    "xjf": "set content.javascript.enabled false",
    "xx": "config-cycle content.javascript.enabled false true ;; reload",

    ';b': 'config-cycle content.user_stylesheets ./themes/gruvbox-all-sites.css ""',
    ';t': 'config-cycle statusbar.show always never ;; config-cycle tabs.show always never',

     "cc": "jseval --quiet --file ~/.config/qutebrowser/no-cookies.js",

}
for key, bind in bindings.items():
    config.bind(key, bind)





