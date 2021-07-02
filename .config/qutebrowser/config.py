config.load_autoconfig()
config.source("bindings.py")
config.source("search_engines.py")
config.source("themes/gruvbox.py")
config.source("startpage.py")

c.downloads.location.directory = "~/Downloads"
c.colors.webpage.preferred_color_scheme = "dark"

c.keyhint.delay = 100
c.editor.command = ['codium', '{file}']
c.auto_save.session = False
c.completion.web_history.max_items = 10000
c.scrolling.smooth = True

#fonts
c.fonts.default_family = "Fira Code"
c.fonts.default_size = "20pt"

c.downloads.position = 'bottom'
c.zoom.default = "150%"


# Content (JS, cookies, encoding, etc)
c.content.autoplay = False
c.content.cookies.accept = "all"
c.content.cookies.store = True #False
c.content.default_encoding = "utf-8"
c.content.headers.user_agent = (
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko)"
    " Chrome/80.0.3987.163 Safari/537.36"
)
c.content.javascript.enabled = True #False
# c.content.user_stylesheets = "./themes/gruvbox-all-sites.css"

#new page
c.url.default_page = "~/.config/qutebrowser/blank.html"
# c.url.start_pages = ["~/.config/qutebrowser/blank.html"]


js_whitelist = [
    "*://localhost/*",
    "*://127.0.0.1/*",
    "*://duckduckgo.com/*",
    "*://github.com/*",
    "*://translate.google.com/*",
]
for website in js_whitelist:
    with config.pattern(website) as p:
        p.content.javascript.enabled = True

