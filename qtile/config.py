from typing import List
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from gruvbox.gruvbox import *
from theme import *

mod = "mod4"

triangle = "◀"
slash = ""
separator = slash
                    
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

    Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    Key([mod, "mod1"], "h", lazy.layout.flip_left()),
    Key([mod, "mod1"], "l", lazy.layout.flip_right()),

    Key([mod, "shift"], "n", lazy.layout.normalize()),
    Key([mod], "n", lazy.layout.toggle_split()),

    Key([mod], "Tab", lazy.next_layout(), ),
    Key([mod], "c", lazy.window.kill(), ),
    Key([mod, "control"], "r", lazy.restart(), ),
    Key([mod, "control"], "q", lazy.shutdown(), ),

    Key([mod], "e",lazy.window.toggle_floating(),),
    Key([mod], "w",lazy.window.toggle_fullscreen(),),
    Key([mod], "t",lazy.hide_show_bar(),),
]

groups = []
group_names ="1234567890"
group_labels = "一二三四五六七八九十"
group_layouts = ["Bsp", "Max","Bsp","Bsp","Bsp","Bsp", "Bsp","Bsp","Bsp","Bsp",]
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
    layout.Bsp(
        border_focus=red,
        border_normal=normal_t,
        border_width=3,
        ),
]

widget_defaults = dict(
    font='FiraCode',
    fontsize=18,
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
                widget.WindowName(
                    foreground=background,
                    ),
                widget.TextBox(
                    padding=0,
                    text= separator,
                    foreground=purple,
                    ),
                widget.TextBox(
                    text= 'scr:',
                    background=purple,
                    foreground=white0,
                    ),
                widget.Backlight(
                    backlight_name="amdgpu_bl0",
                    background=purple,
                    foreground=white0,
                ),
                widget.TextBox(
                    padding=0,
                    text= separator,
                    foreground=yellow,
                    background=purple,
                    ),
                widget.TextBox(
                    text= 'vol:',
                    background=yellow,
                    foreground=white0,
                    ),
                widget.Volume(
                    background=yellow,
                    foreground=white0,
                ),
                widget.TextBox(
                    padding=0,
                    text= separator,
                    foreground=green,
                    background=yellow,
                    ),
                widget.TextBox(
                    text= 'bat:',
                    background=green,
                    foreground=white0,
                    ),
                widget.Battery(
                    format='{percent:2.0%}',
                    low_percentage=0.2,
                    low_foreground=warning,
                    background=green,
                    foreground=white0,
                ),
                widget.TextBox(
                    padding=0,
                    text= separator,
                    foreground=aqua,
                    background=green,
                    ),
                widget.KeyboardLayout(
                    configured_keyboards=['us','ro std','ru'],
                    display_map={'us':'US','ro std':'RO','ru':'RU'},
                    background=aqua,
                    foreground=white0,
                    ),
                widget.TextBox(
                    padding=0,
                    text= separator,
                    foreground=blue,
                    background=aqua,
                    ),
                widget.Clock(
                    #format='%I:%M %p',
                    format='%d.%m',
                    background=blue,
                    foreground=white0,
                    ),
                widget.TextBox(
                    padding=0,
                    text= separator,
                    foreground=purple,
                    background=blue,
                    ),
                widget.Clock(
                    #format='%d.%m.%Y',
                    format='%I:%M',
                    background=purple,
                    foreground=white0,
                    ),
                widget.Systray(
                    background=purple,
                    icon_size=15,
                    ),
            ],
            20,
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
