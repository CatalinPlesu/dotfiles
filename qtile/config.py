from gruvbox.gruvbox import *
from libqtile import bar, layout, widget
from libqtile import hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from theme import *
from typing import List
import os
import subprocess


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/scripts/podman-compose-autostart')
    subprocess.call(home)
    subprocess.Popen(['wlr-randr', '--output', 'DP-1', '--pos',
                     '0,0', '--output', 'HDMI-A-1', '--pos', '1920,0'])


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
    Key([mod], "q", lazy.window.kill(), ),
    Key([mod, "control"], "r", lazy.spawn(
        "qtile cmd-obj -o cmd -f reload_config"), ),
    Key([mod, "control"], "q", lazy.shutdown(), ),

    Key([mod, "shift"], "f", lazy.window.toggle_floating(),),
    Key([mod], "f", lazy.window.toggle_fullscreen(),),
    Key([mod], "t", lazy.hide_show_bar(),),

    # Rofi
    Key([mod], "d", lazy.spawn("rofi -show combi")),
    Key([mod, "shift"], "d", lazy.spawn(
        "rofi -show calc -theme dmenu | wl-copy")),  # Updated for Wayland
    Key([mod, "shift"], "e", lazy.spawn("plasma-emojier")),

    # Apps
    Key([mod], "Return", lazy.spawn("kitty -e tmux new-session -A -s main")),
    Key([mod, "shift"], "t", lazy.spawn("kitty")),
    Key([mod], "b", lazy.spawn("zen-browser")),
    Key([mod, "shift"], "b", lazy.spawn("firefox")),
    Key([mod], "x", lazy.spawn("loginctl lock-session")),
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
# HDMI-A-1 (screen 0) gets workspaces 1-5, DP-1 (screen 1) gets workspaces 6-0
screen_affinities = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1]
group_layouts = ["Bsp", "Max", "Bsp", "Bsp",
                 "Bsp", "Bsp", "Bsp", "Bsp", "Bsp", "Bsp",]
for i in range(len(group_names)):
    groups.append(Group(
        name=group_names[i], layout=group_layouts[i].lower(), label=group_labels[i], screen_affinity=screen_affinities[i]))

for i in groups:
    keys.extend([
        Key([mod], i.name,
            lazy.function(lambda qtile, group_name=i.name: switch_group_no_move(qtile, group_name))),
        Key([mod, "shift"], i.name, lazy.window.togroup(
            i.name, switch_group=True)),
    ])

# Add keys to switch between screens
keys.extend([
    Key([mod, "control"], "h", lazy.to_screen(0)),  # Switch to screen 0
    Key([mod, "control"], "l", lazy.to_screen(1)),  # Switch to screen 1
    # You can also use this for cycling between screens
    Key([mod], "w", lazy.next_screen()),
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
    # Screen 0 - HDMI-A-1 (LG TV) - Workspaces 1-5
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
                    # Show only workspaces 1-5
                    visible_groups=["1", "2", "3", "4", "5"],
                ),
                widget.WindowName(
                    foreground=background,
                ),
                widget.CurrentLayout(
                    background=yellow,
                    foreground=white0,
                ),
                widget.TextBox(
                    padding=0,
                    text=separator,
                    foreground=purple,
                    background=yellow,
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
                    background=purple,
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
        wallpaper="/home/catalin/Pictures/wallpapers/pattern/wallhaven-kxp8dd_1920x1080.png"
    ),
    # Screen 1 - DP-1 (Samsung via VGA) - Workspaces 6-0
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
                    # Show only workspaces 6-0
                    visible_groups=["6", "7", "8", "9", "0"],
                ),
                widget.WindowName(),
                widget.CurrentLayout(
                    background=yellow,
                    foreground=white0,
                ),
                widget.TextBox(
                    padding=0,
                    text=separator,
                    foreground=blue,
                    background=yellow,
                ),
                widget.Clock(
                    format='%d.%m %H:%M',
                    background=blue,
                    foreground=white0,
                ),
            ],
            24,
        ),
        wallpaper="/home/catalin/Pictures/wallpapers/anime/wallhaven-wel5e7_1920x1080.png"
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


def switch_group_no_move(qtile, group_name):
    group = qtile.groups_map[group_name]
    screen_affinity = getattr(group, 'screen_affinity', None)

    if screen_affinity is not None and screen_affinity != qtile.current_screen.index:
        # Switch screen first, then switch group — without moving window
        qtile.cmd_to_screen(screen_affinity)
        group.cmd_toscreen()
    else:
        # Just switch group on current screen
        group.cmd_toscreen()
