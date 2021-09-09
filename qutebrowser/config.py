config.load_autoconfig()
config.source("modules/bindings.py")
config.source("modules/search_engines.py")
config.source("themes/base16-gruvbox-light-medium.config.py")

c.downloads.location.directory = "~/Downloads"
c.colors.webpage.preferred_color_scheme = "dark"

c.keyhint.delay = 100
c.editor.command = ['codium', '{file}']
c.auto_save.session = False
c.completion.web_history.max_items = 10000
c.scrolling.smooth = True

#fonts
c.fonts.default_family = "Fira Code"
c.fonts.default_size = "15pt"
c.downloads.position = 'bottom'
c.zoom.default = "100%"


c.url.default_page = "~/code/web/start_pages/18_08_2021/index.html"
c.url.start_pages = ["~/code/web/start_pages/18_08_2021/index.html"]

# Content (JS, cookies, encoding, etc)
c.content.autoplay = False
c.content.cookies.accept = "all"
c.content.cookies.store = True #False
c.content.default_encoding = "utf-8"

c.content.javascript.enabled = True #False
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

