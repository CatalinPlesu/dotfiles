config.load_autoconfig()
config.source("bindings.py")
config.source("search_engines.py")
config.source('themes/gruvbox.py')

c.colors.webpage.preferred_color_scheme = "dark"

#fonts
c.fonts.default_family = "Fira Code"
c.fonts.default_size = "20pt"

c.downloads.position = 'bottom'
c.zoom.default = "150%"

#new page
c.url.default_page = "~/.config/qutebrowser/blank.html"
c.url.start_pages = ["~/.config/qutebrowser/blank.html"]

