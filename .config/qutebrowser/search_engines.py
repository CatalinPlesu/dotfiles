from random import randrange
searx = [
        "https://searx.bar/",
        "https://search.mdosch.de/",
        "https://searx.info/",
        "https://sx.fedi.tech/",
        "https://searx.tunkki.xyz/searx/",
        "https://searx.tux.land/",
        "https://searx.tuxcloud.net/",
        "https://searx.zackptg5.com/",
        "https://s.zhaocloud.net/",
        "https://searx.divided-by-zero.eu/",
        "https://swag.pw/",
        "https://searx.sp-codes.de/",
        "https://searx.lnode.net/",
        ]
c.url.searchengines = {
    'DEFAULT': searx[randrange(0,len(searx)-1)]+'search?q={}',
    'd': 'https://duckduckgo.com/?q={}',
    'aur': 'http://aur.archlinux.org/packages.php?O=0&L=0&C=0&K={}',
    'arch': 'https://archlinux.org/packages/?q={}',
    'wiki': 'https://wiki.archlinux.org/index.php/Special:Search?search={}',
    'git': 'http://github.com/search?q={}',

    'y': 'https://www.youtube.com/results?search_query={}&search=Search',
    'g': 'https://www.google.com/search?q={}',

    't': 'https://translate.google.com/?sl=auto&tl=ro&text={}&op=translate',
    'te': 'https://translate.google.com/?sl=auto&tl=en&text={}&op=translate',
    'tr': 'https://translate.google.com/?sl=auto&tl=ru&text={}&op=translate'
}
