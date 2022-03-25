# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from typing import List  # noqa: F401

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.layout.columns import Columns
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook
from libqtile.log_utils import logger

from libqtile.layout.columns import Columns
from libqtile.layout.xmonad import MonadWide 
from libqtile.layout.xmonad import MonadTall 
from libqtile.layout.max import Max 
from libqtile.layout.tile import Tile 
from libqtile.layout.floating import Floating 


#Font Size
fs = 12
font_size = 10
my_font = "Isevka"
bar_spacer = font_size + 8
mod = "mod4"                                     # Sets mod key to SUPER/WINDOWS
myTerm = "alacritty"                             # My terminal of choice
terminal = guess_terminal()

home = os.path.expanduser('~')
# Apps
app_lock = "slock"
app_terminal = "alacritty"
app_file = "pcmanfm"
app_browser = "brave"
app_password = "enpass"

app_active_windows_screenshot = home + "/.scripts/take_screenshot_of_active_windows.bash"
app_selected_zone_screenshot = home + "/.scripts/take_screenshot_of_selected_zone.bash"



keys = [
    Key([mod, "shift"], "r", lazy.restart(), desc='Restart Qtile'),

    Key([mod, "shift"], "Return", lazy.spawn("rofi -show drun -display-drun \"Run: \" -drun-display-format \"{name}\""), desc='Run Launcher'),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc='Kill active window'),
    Key([mod, "shift"], "q", lazy.shutdown(), desc='Shutdown Qtile'),
    Key([mod, "shift"], "s", lazy.spawn(app_lock), desc='Lock Qtile'),
    Key([mod, "shift"], "f", lazy.spawn(app_file), desc='File manager'),
    Key([mod, "shift"], "b", lazy.spawn(app_browser), desc='Browser'),
    Key([mod, "shift"], "t", lazy.spawn(app_selected_zone_screenshot), desc='Selected zone screenshot'),
    Key([mod, "control"], "t", lazy.spawn(app_active_windows_screenshot), desc='Active window screenshot'),
        
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    Key([mod, "control"], "h", lazy.screen.prev_group(), desc='Move focus to prev monitor'),
    Key([mod, "control"], "l", lazy.screen.next_group(), desc='Move focus to next monitor'),
    
    #Key([mod, "shift", "control"], "h", lazy.function(window_to_prev_group), desc='Move windos to prev monitor'),
    #Key([mod, "shift", "control"], "l", lazy.function(window_to_next_group), desc='Move windows to next monitor'),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    
    Key([mod, "shift"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "shift"], "h", lazy.layout.shrink_main(), desc="Grow window to the left"),
    Key([mod, "shift"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "shift"], "l", lazy.layout.grow_main(), desc="Grow window to the right"),
    Key([mod, "shift"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "shift"], "k", lazy.layout.grow_up(), desc="Grow window up"),
]

group_names = [
    ("1-Dev", {'layout': 'monadtall'}),
    ("2-Dev", {'layout': 'monadtall'}),
    ("3-Web", {'layout': 'monadtall'}),
    ("4-Web", {'layout': 'monadtall'}),
    ("5-Sys", {'layout': 'monadtall'}),
    ("6-Sys", {'layout': 'monadtall'}),
    ("7-Com", {'layout': 'monadtall'}),
]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

keys.append(Key([mod], "F1", lazy.group["1-Dev"].toscreen()))
keys.append(Key([mod], "F2", lazy.group["2-Dev"].toscreen()))
keys.append(Key([mod], "F3", lazy.group["3-Web"].toscreen()))
keys.append(Key([mod], "F4", lazy.group["4-Web"].toscreen()))
keys.append(Key([mod], "F5", lazy.group["5-Sys"].toscreen()))
keys.append(Key([mod], "F6", lazy.group["6-Sys"].toscreen()))
keys.append(Key([mod], "F7", lazy.group["7-Com"].toscreen()))


def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)

def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)

def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


layout_theme = {"border_width": 2,
                "margin": 6,
                "border_focus": "DDDDDD",
                "border_normal": "21252B"
                }

layouts = [
    MonadWide(**layout_theme),
#     #layout.Bsp(**layout_theme),
#     #layout.Stack(stacks=2, **layout_theme),
    Columns(**layout_theme),
#     #layout.RatioTile(**layout_theme),
#     #layout.VerticalTile(**layout_theme),
#     #layout.Matrix(**layout_theme),
#     #layout.Zoomy(**layout_theme),
    MonadTall(**layout_theme),
    Max(**layout_theme),
    Tile(shift_windows=True, **layout_theme),
#     layout.Stack(num_stacks=2),
#     layout.Floating(**layout_theme)
]

colors = [["#282c34", "#282c34"], # panel background
          ["#4f5163", "#4f5163"], # background for current screen tab
          ["#ffffff", "#ffffff"], # font color for group names
          ["#4f5163", "#4f5163"], # border line color for current tab
          ["#282c34", "#282c34"], # border line color for other tab and odd widgets
          ["#282c34", "#282c34"], # color for the even widgets
          ["#ffffff", "#ffffff"]] # window name

widget_defaults = dict(
    font = my_font,
    fontsize = fs,
    padding = 10,
    background=colors[2]
)

extension_defaults = widget_defaults.copy()

from libqtile.widget.textbox import TextBox
from libqtile.widget.sep import Sep
from libqtile.widget.systray import Systray
from libqtile.widget.groupbox import GroupBox
from libqtile.widget.prompt import Prompt
from libqtile.widget.cpu import CPU
from libqtile.widget.memory import Memory
from libqtile.widget.clock import Clock
from libqtile.widget.windowname import WindowName
from libqtile.widget.volume import Volume
from libqtile.widget.currentlayout import CurrentLayout, CurrentLayoutIcon
from libqtile.widget.battery import Battery, BatteryIcon

# Spacer
def wspacer():
    return TextBox(text = ' ',background = colors[4],foreground = colors[5],padding = 0)

def wseparator():
    return Sep(linewidth = 0,padding = 40,foreground = colors[2],background = colors[4])

def wsystray():
    return Systray(foreground = colors[0], background = colors[5], padding = 5)

def wpipe():
   return TextBox(text = "|",padding = 0,foreground = colors[3],background = colors[4])

def init_widgets_list():
    widgets_list = [
        Sep(linewidth = 0,padding = 6,foreground = colors[2],background = colors[4]),
        GroupBox(
                 font = my_font,
                 fontsize = fs,
                 margin_y = 3,
                 margin_x = 0,
                 padding_y = 5,
                 padding_x = 3,
                 borderwidth = 3,
                 active = colors[2],
                 inactive = colors[2],
                 rounded = False,
                 highlight_color = colors[1],
                 highlight_method = "line",
                 this_current_screen_border = colors[3],
                 this_screen_border = colors [4],
                 other_current_screen_border = colors[0],
                 other_screen_border = colors[0],
                 foreground = colors[2],
                 background = colors[4]
                 ),
        Prompt(font = my_font, fontsize = fs, padding = 10,foreground = colors[3],background = colors[4]),
        Sep(linewidth = 0,padding = 40,foreground = colors[2],background = colors[4]),
        WindowName(font = my_font, fontsize = fs, foreground = colors[6],background = colors[4],padding = 0),
        TextBox(text = 'CPU:',background = colors[4],foreground = colors[2],padding = 0),
        CPU(font = my_font, fontsize = fs, background = colors[4],foreground = colors[2],padding = 5,format= "{load_percent}%"),
        wpipe(),
        TextBox(font = my_font, fontsize = fs, text = 'MEM:',background = colors[5],foreground = colors[2],padding = 0),
        Memory(font = my_font, fontsize = fs, format = '{MemUsed:.0f}{mm}/{MemTotal:.0f}{mm}', background = colors[4],foreground = colors[2]),
        Volume(foreground = colors[2],background = colors[5],padding = 5),
        wpipe(),
        CurrentLayoutIcon(foreground = colors[0],background = colors[4],padding = 0,scale = 0.7),
        CurrentLayout(foreground = colors[2],background = colors[4],padding = 5),
        wpipe(),
        TextBox(text = 'Bat:',background = colors[4],foreground = colors[2],padding = 0),
        Battery(foreground = colors[2],background = colors[4],padding = 5),
        wpipe(),
        Clock(font = my_font, fontsize = fs, foreground = colors[2],background = colors[5],format = "%A, %B %d  [ %H:%M ]"),
        wpipe(),
    ]
    return widgets_list

def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    widgets_screen1.append(wsystray())
    widgets_screen1.append(wspacer())

    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    widgets_screen2.append(wsystray())
    widgets_screen2.append(wspacer())
    return widgets_screen2

def init_screens():
    return [
        Screen(top=bar.Bar(init_widgets_screen1(), bar_spacer)),
        Screen(top=bar.Bar(init_widgets_screen1(), bar_spacer)),
        Screen(top=bar.Bar(init_widgets_screen1(), bar_spacer)),
    ]

screens = init_screens()

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
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(title='Enpass'),  # GPG key password entry
])

groups.append(ScratchPad('scratchpad', [
    DropDown('enpass', 'enpass', width=0.4, x=0.3, y=0.2),
]))
keys.extend([
    Key([mod, "shift"], "p", lazy.group['scratchpad'].dropdown_toggle('enpass'), desc='Password managers'),
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

@hook.subscribe.startup_once

def start_once():
    logger.warning("Restarting Hook")
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

def show_keys():
    key_help = ""
    for k in keys:
        mods = ""

        for m in k.modifiers:
            if m == "mod4":
                mods += "Super + "
            else:
                mods += m.capitalize() + " + "

        if len(k.key) > 1:
            mods += k.key.capitalize()
        else:
            mods += k.key

        key_help += "{:<30} {}".format(mods, k.desc + "\n")

    return key_help

keys.extend([Key([mod], "h", lazy.spawn("sh -c 'echo \"" + show_keys() + "\" | rofi -dmenu -i -mesg \"Keyboard shortcuts\"'"), desc="Print keyboard bindings"),])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
