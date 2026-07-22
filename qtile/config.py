from gruvbox.gruvbox import *
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from theme import *
import os
import shutil
import subprocess

_wp_src = os.path.expanduser("~/Pictures/frieren.png")
_wp_out = os.path.expanduser("~/.local/share/qtile/wallpaper.png")
os.makedirs(os.path.dirname(_wp_out), exist_ok=True)
try:
    res = subprocess.check_output(
        "xdpyinfo 2>/dev/null | awk '/dimensions:/{print $2}'", shell=True
    ).decode().strip()
    if res and "x" in res:
        subprocess.run(
            ["convert", _wp_src, "-resize", f"{res}^",
             "-gravity", "North", "-extent", res, _wp_out],
            capture_output=True,
        )
    else:
        shutil.copy2(_wp_src, _wp_out)
except Exception:
    shutil.copy2(_wp_src, _wp_out)

mod = "mod1"
term = "ghostty"
browser = "zen-browser"

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/scripts/podman-compose-autostart")
    subprocess.call(home)
    subprocess.Popen(["wlr-randr", "--output", "DP-1", "--on",
                      "--output", "HDMI-A-1", "--above", "DP-1"])

# ═══════════════════════════════════════════════════════════
#  Key bindings
# ═══════════════════════════════════════════════════════════

keys = [
    # ── Window Management ──
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "space", lazy.layout.next()),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "l", lazy.layout.grow_right()),
    Key([mod, "control"], "j", lazy.layout.grow_down()),
    Key([mod, "control"], "k", lazy.layout.grow_up()),

    Key(["mod4"], "h", lazy.layout.flip_left()),
    Key(["mod4"], "l", lazy.layout.flip_right()),
    Key(["mod4"], "j", lazy.layout.flip_down()),
    Key(["mod4"], "k", lazy.layout.flip_up()),

    Key([mod, "shift"], "n", lazy.layout.normalize()),
    Key([mod, "shift"], "f", lazy.window.toggle_floating()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "t", lazy.hide_show_bar()),
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.spawn("qtile cmd-obj -o cmd -f reload_config")),
    Key([mod, "control"], "q", lazy.shutdown()),

    # ── Screens ──
    Key([mod], "w", lazy.next_screen()),
    # ── Launch: Core Apps ──
    Key([mod], "Return", lazy.spawn(f'{term} -e tmux new-session -A -s main')),
    Key([mod, "shift"], "Return", lazy.spawn(term)),
    Key([mod], "b", lazy.spawn(browser)),
    Key([mod, "shift"], "b", lazy.spawn("firefox")),
    Key([mod], "x", lazy.spawn("loginctl lock-session")),

    # ── Rofi ──
    Key([mod], "d", lazy.spawn("rofi -show combi")),
    Key([mod, "shift"], "d", lazy.spawn("rofi -show calc -theme dmenu | wl-copy")),
    Key([mod, "shift"], "e", lazy.spawn("plasma-emojier")),

    # ── Screenshots (Wayland: grim + slurp + wl-copy) ──
    Key([], "Print", lazy.spawn(
        'grim ~/Pictures/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png')),
    Key(["control"], "Print", lazy.spawn(
        "grim -g '$(slurp)' ~/Pictures/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png")),
    Key([mod], "Print", lazy.spawn("grim -g '$(slurp)' - | wl-copy")),
    Key([mod], "s", lazy.spawn(
        "grim -g '$(slurp)' ~/Pictures/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png")),
    Key([mod, "shift"], "s", lazy.spawn("flameshot gui")),

    # ── Audio (PipeWire) ──
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),
    Key([], "XF86AudioMicMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")),

    # ── Brightness / Keyboard ──
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),
    Key([mod, "control"], "space", lazy.widget["keyboardlayout"].next_keyboard()),

    # ── Misc ──
    Key([mod, "shift"], "w", lazy.spawn(
        "swww img $(find ~/Pictures/wallpapers -type f | shuf -n1)")),
    Key([mod, "shift"], "c", lazy.spawn("wtype -k caps_lock")),
]

# ═══════════════════════════════════════════════════════════
#  KeyChords (sxhkd-style modal bindings)
# ═══════════════════════════════════════════════════════════

# ── super + a : Terminal Apps ──
keys.append(KeyChord([mod], "a", [
    Key([], "e", lazy.spawn(f'{term} -e nvim')),
    Key([], "n", lazy.spawn(f'{term} -e note')),
    Key([], "N", lazy.spawn(f'{term} -e now')),
    Key([], "m", lazy.spawn(f'{term} -e ncmpcpp')),
    Key([], "r", lazy.spawn(f'{term} -e ranger')),
    Key([], "h", lazy.spawn(f'{term} -e htop')),
    Key([], "Return", lazy.spawn(f'{term} -e tmux new-session -A -s main')),
    Key([], "t", lazy.spawn(term)),
], name="terminal apps"))

# ── super + v : Volume / Brightness Fine-tuning ──
keys.append(KeyChord([mod], "v", [
    Key([], "j", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")),
    Key([], "k", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")),
    Key([], "m", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),
    Key([], "g", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%")),
    Key([], "G", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%")),
    Key([], "l", lazy.spawn("brightnessctl set +5%")),
    Key([], "h", lazy.spawn("brightnessctl set 5%-")),
], name="vol/brightness"))

# ── super + r : Extras ──
# keyboard layouts via widget: super + ctrl + space
keys.append(KeyChord([mod], "r", [
    Key([], "w", lazy.spawn("swww img $(find ~/Pictures/wallpapers -type f | shuf -n1)")),
    Key([], "t", lazy.spawn("switch")),
    Key([], "s", lazy.spawn("pkill wshowkeys || wshowkeys")),
    Key([], "S", lazy.spawn("pkill wshowkeys")),
], name="extras"))

# ── Romanian Diacritics (Wayland: wtype) ──
keys.extend([
    Key(["mod1"], "bracketleft", lazy.spawn("wtype ă")),
    Key(["mod1"], "bracketright", lazy.spawn("wtype î")),
    Key(["mod1"], "backslash", lazy.spawn("wtype â")),
    Key(["mod1"], "apostrophe", lazy.spawn("wtype ș")),
    Key(["mod1"], "semicolon", lazy.spawn("wtype ț")),
])

# ═══════════════════════════════════════════════════════════
#  Groups & Layouts
# ═══════════════════════════════════════════════════════════

groups = []
group_names = "1234567890"
group_labels = "一二三四五六七八九十"
screen_affinities = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1]
group_layouts = ["Bsp", "Max", "Bsp", "Bsp", "Bsp", "Bsp", "Bsp", "Bsp", "Bsp", "Bsp"]

for i in range(len(group_names)):
    groups.append(Group(
        name=group_names[i],
        layout=group_layouts[i].lower(),
        label=group_labels[i],
        screen_affinity=screen_affinities[i],
    ))

for g in groups:
    keys.extend([
        Key([mod], g.name, lazy.function(
            lambda qtile, name=g.name: switch_group_no_move(qtile, name))),
        Key([mod, "shift"], g.name, lazy.window.togroup(g.name, switch_group=True)),
    ])

layouts = [
    layout.Columns(margin_on_single=0, border_focus=focus_t,
                   border_normal=normal_t, border_width=5, margin=5),
    layout.Max(),
    layout.Bsp(border_focus=red, border_normal=normal_t, border_width=3),
]

# ═══════════════════════════════════════════════════════════
#  Appearance
# ═══════════════════════════════════════════════════════════

sep = ""
widget_defaults = dict(
    font="FiraCode Nerd Font", fontsize=18, padding=5,
    foreground=foreground, background=background,
)
extension_defaults = widget_defaults.copy()

def bar_widgets(visible_groups):
    """Shared bar widgets with group visibility filter."""
    return [
        widget.GroupBox(
            disable_drag=True, spacing=0, center_aligned=True,
            active=active, inactive=inactive, highlight_method="block",
            this_current_screen_border=mark, urgent_border=warning,
            visible_groups=visible_groups,
        ),
        widget.WindowName(foreground=background),
        widget.CurrentLayout(background=yellow, foreground=white0),
        widget.TextBox(text=sep, foreground=purple, background=yellow),
        widget.TextBox(text="vol:", background=purple, foreground=white0),
        widget.Volume(background=purple, foreground=white0),
        widget.TextBox(text=sep, foreground=green, background=purple),
        widget.TextBox(text="mem:", background=green, foreground=white0),
        widget.Memory(format="{MemUsed: .0f}{mm}", background=green, foreground=white0),
        widget.TextBox(text=sep, foreground=aqua, background=green),
        widget.TextBox(text="cpu:", background=aqua, foreground=white0),
        widget.CPU(format="{freq_current}GHz {load_percent}%",
                   background=aqua, foreground=white0),
        widget.TextBox(text=sep, foreground=blue, background=aqua),
        widget.KeyboardLayout(
            configured_keyboards=["us", "ro std", "ru"],
            display_map={"us": "US", "ro std": "RO", "ru": "RU"},
            background=blue, foreground=white0,
        ),
        widget.TextBox(text=sep, foreground=yellow, background=blue),
        widget.Clock(format="%d.%m", background=yellow, foreground=white0),
        widget.TextBox(text=sep, foreground=purple, background=yellow),
        widget.Clock(format="%H:%M", background=purple, foreground=white0),
        widget.StatusNotifier(background=purple, icon_size=15), # Replaced Systray
    ]

screens = [
    Screen(
        top=bar.Bar(bar_widgets(["1", "2", "3", "4", "5"]), 24),
        wallpaper=_wp_out,
    ),
    Screen(
        top=bar.Bar([
            widget.GroupBox(
                disable_drag=True, spacing=0, center_aligned=True,
                active=active, inactive=inactive, highlight_method="block",
                this_current_screen_border=mark, urgent_border=warning,
                visible_groups=["6", "7", "8", "9", "0"],
            ),
            widget.WindowName(),
            widget.CurrentLayout(background=yellow, foreground=white0),
            widget.TextBox(text=sep, foreground=blue, background=yellow),
            widget.Clock(format="%d.%m %H:%M", background=blue, foreground=white0),
        ], 24),
        wallpaper=_wp_out,
    ),
]

# ═══════════════════════════════════════════════════════════
#  Misc Config
# ═══════════════════════════════════════════════════════════

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D"

floating_layout = layout.Floating(
    border_focus=focus_f, border_normal=normal_f, border_width=3,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(title="Application Finder"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="blueman-manager"),
    ],
)


def switch_group_no_move(qtile, group_name):
    group = qtile.groups_map[group_name]
    screen_affinity = getattr(group, "screen_affinity", None)
    if screen_affinity is not None and screen_affinity != qtile.current_screen.index:
        if screen_affinity < len(qtile.screens):
            qtile.to_screen(screen_affinity)
        group.toscreen() # Enforced correct syntax for Qtile 0.21+
    else:
        group.toscreen() # Enforced correct syntax for Qtile 0.21+
