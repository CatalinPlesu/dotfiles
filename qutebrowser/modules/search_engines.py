from random import randrange
searx = [
        "https://searx.be/",
        "https://searx.tunkki.xyz/searx/",
        "https://searx.bissisoft.com/",
        "https://searx.bar/",
        "https://searx.info/",
        "https://searx.tunkki.xyz/searx/",
        "https://searx.tuxcloud.net/",
        "https://searx.zackptg5.com/",
        "https://searx.sp-codes.de/",
        "https://searx.lnode.net/",
        ]
c.url.searchengines = {
        # search engines
    'DEFAULT': searx[randrange(0,len(searx)-1)]+'search?q={}',
    'd': 'https://duckduckgo.com/?q={}',
    'g': 'https://www.google.com/search?q={}',
    'b': 'https://www.bing.com/search?q={}',
    'i': 'https://yandex.com/search/?text={}',
    's': 'https://swisscows.com/web?culture=en&query={}',
    'y': 'https://www.youtube.com/results?search_query={}&search=Search',
        # entertainment
    'r': 'https://www.reddit.com/r/{}/',
    'p': 'https://www.pinterest.com/search/pins/?q={}',
        # arch linux
    'aur': 'http://aur.archlinux.org/packages.php?O=0&L=0&C=0&K={}',
    'arch': 'https://archlinux.org/packages/?q={}',
    'wiki': 'https://wiki.archlinux.org/index.php/Special:Search?search={}',
        # translate
    't': 'https://translate.google.com/?sl=auto&tl=ro&text={}&op=translate',
    'te': 'https://translate.google.com/?sl=auto&tl=en&text={}&op=translate',
    'tr': 'https://translate.google.com/?sl=auto&tl=ru&text={}&op=translate',
    'tj': 'https://translate.google.com/?sl=auto&tl=ja&text={}&op=translate',
        # language
    'dict': 'https://www.urbandictionary.com/define.php?term={}',
    'dex': 'https://dexonline.ro/definitie/{}',
        #anime
    'z': 'https://zoro.to/search?keyword={}',
        # tech
    'hub': 'http://github.com/search?q={}',
    'lab': 'https://gitlab.com/search?search={}&group_id=&project_id=&snippets=false&repository_ref=&nav_source=navbar',
    'repo': 'http://github.com/catalinplesu/{}',
    'gem': 'https://rubygems.org/search?query={}',
        # md buy
    '999': 'https://999.md/ro/search?query={}'
}
