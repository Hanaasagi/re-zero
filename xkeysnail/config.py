# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *

# define timeout for multipurpose_modmap
define_timeout(1)


# [Global modemap] Change modifier keys as in xmodmap
define_modmap({Key.CAPSLOCK: Key.LEFT_CTRL})


# Use for browser specific hotkeys
browsers = [
    "Chromium",
    "Google-chrome",
    "Chromium-browser",
    "Firefox",
    "Firefox-Nightly",
    "Nightly",
]
browsers = [browser.casefold() for browser in browsers]
browser_pattern = "|".join(str("^" + x + "$") for x in browsers)

terminals = [
    "Alacritty",
    "Konsole",
]
terminals = [term.casefold() for term in terminals]
termianl_pattern = "|".join(str("^" + x + "$") for x in terminals)

# Keybindings for Browsers
define_keymap(
    re.compile(browser_pattern, re.IGNORECASE),
    {
        # K("Alt-C"): K("C-C"),
        # K("Alt-V"): K("C-V"),
    },
    "Firefox, Chrome and others",
)

# Emacs/Vim-like keybindings in non-Emacs applications
define_keymap(
    lambda wm_class: wm_class.casefold() not in terminals,
    {
        # Copy, Paste and Select
        K("LM-C"): K("C-C"),
        K("LM-V"): K("C-V"),
        K("LM-A"): K("C-A"),
        K("LM-S"): K("C-S"),
        # Cursor
        K("LM-H"): (K("left")),
        K("LM-J"): (K("down")),
        K("LM-K"): (K("up")),
        K("LM-L"): (K("right")),
        K("C-H"): (K("backspace")),
        # Beginning/End of line
        K("C-A"): (K("home")),
        K("C-E"): (K("end")),
        # Undo
        K("LM-Z"): K("C-z"),
    },
    "Emacs/Vim-like keys",
)
