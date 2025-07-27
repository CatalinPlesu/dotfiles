#!/usr/bin/env python3
from qute_bookmarks.rofi import Rofi
from qute_bookmarks.data import BookmarkLibrary, Entity
import os
import sys
import json
import subprocess
import argparse
from pathlib import Path
from typing import List, Optional, Dict, Any
import shutil
import time
import random
from datetime import datetime

# --- Configuration ---
from qute_bookmarks.config import *
import qute_bookmarks.actions.open as open

# Ensure data directory exists
DATA_DIR.mkdir(parents=True, exist_ok=True)


# to do
# --save
# --open
# --open-newtab
# --remove
# --edit
# --entitiy <entitiy/hierarchy> - as unicode, separated by /
# --random [enitity/hierarchy] - default is root enitity

def main():
    parser = argparse.ArgumentParser(
        description="Enhanced Qutebrowser bookmarks manager")
    parser.add_argument("--open", action="store_true", help="Open url")
    parser.add_argument("--focuspath", type=str,
                        help="Path to the entity to focus on")
    parser.add_argument("--new_tab", action="store_true",
                        help="Open in new tab")
    parser.add_argument("--new_window", action="store_true",
                        help="Open in new window")

    args = parser.parse_args()

    lib = BookmarkLibrary.load_from_file(
        '/home/catalin/.config/qutebrowser/userscripts/test.json')
    rofi = Rofi()

    try:
        if args.open:
            open.run(focuspath=args.focuspath, new_tab=args.new_tab,
                     new_window=args.new_window)
    except:
        print(f"Something Else: {args}")
    print(f"Something Else: {args}")


main()
