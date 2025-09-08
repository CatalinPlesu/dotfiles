from typing import List
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from gruvbox.gruvbox import *
from theme import *

mod = "mod4"

triangle = "◀"
slash = ""
separator = slash

keys = [
    # Qtile Window Management
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
    Key([mod], "w", lazy.window.kill(), ),
    Key([mod, "control"], "r", lazy.restart(), ),
    Key([mod, "control"], "q", lazy.shutdown(), ),

    Key([mod, "shift"], "f", lazy.window.toggle_floating(),),
    Key([mod], "f", lazy.window.toggle_fullscreen(),),
    Key([mod], "t", lazy.hide_show_bar(),),

    # Rofi (works on both X11 and Wayland with rofi-wayland)
    Key([mod], "d", lazy.spawn("rofi -show combi")),
    Key([mod, "shift"], "d", lazy.spawn(
        "rofi -show calc -theme dmenu | wl-copy")),  # Updated for Wayland
    Key([mod, "shift"], "s", lazy.spawn(
        "rofi -modi 'run,drun,emoji' -show emoji -matching normal")),

    # Apps
    Key([mod], "Return", lazy.spawn("kitty -e tmux new-session -A -s main")),
    Key([mod], "t", lazy.spawn("kitty")),
    Key([mod], "b", lazy.spawn("firefox")),  # Default to Firefox
    Key([mod, "shift"], "b", lazy.spawn("chromium")),
    Key([mod], "x", lazy.spawn("swaylock")),  # Updated for Wayland
    Key([mod], "m", lazy.spawn(
        "mpv av://v4l2:/dev/video0 --profile=low-latency --untimed -vf=hflip")),
    Key([mod], "e", lazy.spawn("thunar")),
    # Removed the university-specific shortcut

    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),

    # Volume Control (using wpctl for PipeWire, fallback to pactl)
    Key([], "XF86AudioRaiseVolume", lazy.spawn(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")),
    Key([], "XF86AudioMute", lazy.spawn(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),
    Key([], "XF86AudioMicMute", lazy.spawn(
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")),

    # Screenshots (updated for Wayland)
    Key([], "Print", lazy.spawn("grim -g '$(slurp)' - | wl-copy")),
    Key(["control"], "Print", lazy.spawn(
        "grim ~/Pictures/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png")),
    Key([mod], "s", lazy.spawn(
        "grim -g '$(slurp)' ~/Pictures/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png")),

    Key([mod, "control"], "space", lazy.widget['keyboardlayout'].next_keyboard()),
]

groups = []
group_names = "1234567890"
group_labels = "一二三四五六七八九十"
group_layouts = ["Bsp", "Max", "Bsp", "Bsp",
                 "Bsp", "Bsp", "Bsp", "Bsp", "Bsp", "Bsp",]
for i in range(len(group_names)):
    groups.append(Group(
        name=group_names[i], layout=group_layouts[i].lower(), label=group_labels[i],))

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(),),
        Key([mod, "shift"], i.name, lazy.window.togroup(
            i.name, switch_group=True),),
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
    font='FiraCode Nerd Font',
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
                    text=separator,
                    foreground=purple,
                ),
                widget.TextBox(
                    text='vol:',
                    background=purple,
                    foreground=white0,
                ),
                widget.Volume(
                    background=purple,
                    foreground=white0,
                ),
                widget.TextBox(
                    padding=0,
                    text=separator,
                    foreground=green,
                    background=yellow,
                ),
                widget.TextBox(
                    text='mem:',
                    background=green,
                    foreground=white0,
                ),
                widget.Memory(
                    format='{MemUsed: .0f}{mm}',
                    background=green,
                    foreground=white0,
                ),
                widget.TextBox(
                    padding=0,
                    text=separator,
                    foreground=aqua,
                    background=green,
                ),
                widget.TextBox(
                    text='cpu:',
                    background=aqua,
                    foreground=white0,
                ),
                widget.CPU(
                    format='{freq_current}GHz {load_percent}%',
                    background=aqua,
                    foreground=white0,
                ),
                widget.TextBox(
                    padding=0,
                    text=separator,
                    foreground=blue,
                    background=aqua,
                ),
                widget.KeyboardLayout(
                    configured_keyboards=['us', 'ro std', 'ru'],
                    display_map={'us': 'US', 'ro std': 'RO', 'ru': 'RU'},
                    background=blue,
                    foreground=white0,
                ),
                widget.TextBox(
                    padding=0,
                    text=separator,
                    foreground=yellow,
                    background=blue,
                ),
                widget.Clock(
                    format='%d.%m',
                    background=yellow,
                    foreground=white0,
                ),
                widget.TextBox(
                    padding=0,
                    text=separator,
                    foreground=purple,
                    background=yellow,
                ),
                widget.Clock(
                    format='%H:%M',
                    background=purple,
                    foreground=white0,
                ),
                widget.Systray(
                    background=purple,
                    icon_size=15,
                ),
            ],
            24,
        ),
    ),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
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
        Match(wm_class='pavucontrol'),  # Audio control
        Match(wm_class='blueman-manager'),  # Bluetooth manager
    ])
auto_fullscreen = True
focus_on_window_activation = "smart"

# Needed by some Java programs
wmname = "LG3D"
