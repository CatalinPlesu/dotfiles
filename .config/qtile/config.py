from typing import List
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
###gruvbox
black='#282828'
black0='#7c6f64'
red='#cc241d'
red0='#fb4934'
green='#98971a'
green0='#b8bb26'
yellow='#d79921'
yellow0='#fabd2f'
blue='#458588'
blue0='#83a598'
purple='#b16286'
purple0='#d3869b'
aqua='#689d6a'
aqua0='#8ec07c'
white='#a89984'
white0='#fbf1c7'


### main colors
background=black
foreground=white0
### borders
focus_t=green
normal_t=blue
focus_f=aqua
normal_f=white
### bar
mark=green
active=foreground
inactive=foreground

warning=red0

#programs are handled by sxhkd
keys = [
    Key([mod], "h", lazy.layout.left(), ),
    Key([mod], "l", lazy.layout.right(), ),
    Key([mod], "j", lazy.layout.down(), ),
    Key([mod], "k", lazy.layout.up(), ),
   
    Key([mod], "space", lazy.layout.next(), ),
   
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), ),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), ),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), ),
   
    Key([mod, "control"], "h", lazy.layout.grow_left(), ),
    Key([mod, "control"], "l", lazy.layout.grow_right(), ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), ),
    Key([mod, "control"], "k", lazy.layout.grow_up(), ),
   
    Key([mod], "Tab", lazy.next_layout(), ),
    Key([mod], "w", lazy.window.kill(), ),
    Key([mod, "control"], "r", lazy.restart(), ),
    Key([mod, "control"], "q", lazy.shutdown(), ),

    Key([mod], "r", lazy.spawncmd(), ),
    Key([mod], "e",lazy.window.toggle_floating(),),
    Key([mod], "d",lazy.window.toggle_fullscreen(),),
    Key([mod], "t",lazy.hide_show_bar(),),
]

groups = []
group_names ="1234567890"
group_labels = "一二三四五六七八九十"
group_layouts = ["Columns", "Max","Columns","Columns","Columns","Columns","Columns","Columns","Columns","Columns",]
for i in range(len(group_names)):
        groups.append( Group( name=group_names[i], layout=group_layouts[i].lower(), label=group_labels[i],))

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(),),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),),
    ])

layouts = [
    layout.Columns(
        margin_on_single=0,
        border_focus=focus_t,
        border_normal=normal_t,
        border_width=5,
        margin=5,
        ),
    layout.Max(),
]

widget_defaults = dict(
    font='FiraCode',
    fontsize=25,
    padding=5,
    foreground=foreground,
    background=background,
    
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    disable_drag=True,
                    spacing=0,
                    center_aligned=True,
                    active=active,
                    inactive=inactive,
                    highlight_method="block",
                    this_current_screen_border=mark,
                    urgent_border=warning,
                ),
                widget.Prompt(),
                widget.WindowName(),
                widget.Systray(
                    icon_size=25,
                    ),
                widget.TextBox(
                    padding=0,
                    text= '',
                    foreground=green,
                    ),
                widget.Battery(
                    format='{percent:2.0%}',
                    low_percentage=0.2,
                    low_foreground=warning,
                    background=green,
                ),
                widget.TextBox(
                    padding=0,
                    text= '',
                    foreground=aqua,
                    background=green,
                    ),
                widget.KeyboardLayout(
                    configured_keyboards=['us','ro std','ru'],
                    display_map={'us':'US','ro std':'RO','ru':'RU'},
                    background=aqua,
                    ),
                widget.TextBox(
                    padding=0,
                    text= '',
                    foreground=blue,
                    background=aqua,
                    ),
                widget.Clock(
                    format='%I:%M %p',
                    background=blue,
                    ),
                widget.TextBox(
                    padding=0,
                    text= '',
                    foreground=purple,
                    background=blue,
                    ),
                widget.Clock(
                    format='%d.%m.%Y',
                    background=purple,
                    ),
            ],
            30,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
        border_focus=focus_f,
        border_normal=normal_f,
        border_width=3, 
        float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(title='Application Finder'), 
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# Needed by some Java programs
wmname = "LG3D"
