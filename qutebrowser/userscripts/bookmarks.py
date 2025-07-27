#!/usr/bin/env python3

import os
import sys
import json
import argparse
import subprocess
import random
from pathlib import Path

# Configuration
DATA_DIR = Path.home() / "Documents/qutebrowser_bookmarks"
BOOKMARKS_FILE = DATA_DIR / "bookmarks.json"
FIFO_PATH = os.environ.get("QUTE_FIFO", "/tmp/qutebrowser_fifo")

def ensure_dirs():
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    if not BOOKMARKS_FILE.exists():
        BOOKMARKS_FILE.write_text("{}")

def load_bookmarks():
    ensure_dirs()
    with open(BOOKMARKS_FILE, 'r') as f:
        return json.load(f)

def save_bookmarks(data):
    ensure_dirs()
    with open(BOOKMARKS_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def send_to_qute(command):
    try:
        with open(FIFO_PATH, 'w') as fifo:
            fifo.write(f"{command}\n")
    except Exception as e:
        print(f"Failed to write to FIFO: {e}")

def rofi_dmenu(prompt, options):
    proc = subprocess.run(
        ["rofi", "-dmenu", "-p", prompt],
        input="\n".join(options),
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    if proc.returncode == 0:
        return proc.stdout.strip()
    return None

def save_link(category=None):
    url = os.environ.get("QUTE_URL")
    if not url:
        print("QUTE_URL not set", file=sys.stderr)
        return

    bookmarks = load_bookmarks()

    if not category:
        category = rofi_dmenu("Save link in:", list(bookmarks.keys()) + ["[New Category]"])
        if not category:
            return
        if category == "[New Category]":
            category = rofi_dmenu("Enter new category name:", [])
            if not category:
                return

    if category not in bookmarks:
        bookmarks[category] = []

    if url not in bookmarks[category]:
        bookmarks[category].append(url)
        save_bookmarks(bookmarks)
        print(f"Saved {url} to {category}")

def open_link(new_tab=False, category=None):
    bookmarks = load_bookmarks()

    if not bookmarks:
        print("No categories found.", file=sys.stderr)
        return

    if not category:
        category = rofi_dmenu("Open from category:", list(bookmarks.keys()))
        if not category or category not in bookmarks:
            return

    urls = bookmarks.get(category, [])
    if not urls:
        print(f"No URLs in category '{category}'", file=sys.stderr)
        return

    url = rofi_dmenu(f"Select URL from {category}:", urls)
    if url:
        cmd = f"open {'-t' if new_tab else ''} {url}"
        send_to_qute(cmd)

def remove_link():
    url = os.environ.get("QUTE_URL")
    if not url:
        print("QUTE_URL not set", file=sys.stderr)
        return

    bookmarks = load_bookmarks()
    modified = False

    for cat, urls in bookmarks.items():
        if url in urls:
            urls.remove(url)
            modified = True

    if modified:
        save_bookmarks(bookmarks)
        print(f"Removed {url} from all categories")

def random_link(category="artists"):
    bookmarks = load_bookmarks()
    urls = bookmarks.get(category, [])
    if urls:
        url = random.choice(urls)
        send_to_qute(f"open -t {url}")
    else:
        print(f"No URLs found in category '{category}'", file=sys.stderr)

def main():
    parser = argparse.ArgumentParser(description="Qutebrowser bookmarks manager")
    parser.add_argument("-s", "--save", action="store_true", help="Save current URL")
    parser.add_argument("-o", "--open", action="store_true", help="Open in same tab")
    parser.add_argument("-O", "--new-tab", action="store_true", help="Open in new tab")
    parser.add_argument("-r", "--remove", action="store_true", help="Remove current URL")
    parser.add_argument("--random", nargs='?', const="artists", help="Open random URL from category")
    parser.add_argument("-f", "--file", help="Specify category/file directly")

    args = parser.parse_args()

    if args.save:
        save_link(args.file)
    elif args.open or args.new_tab:
        open_link(new_tab=args.new_tab, category=args.file)
    elif args.remove:
        remove_link()
    elif args.random:
        random_link(args.random)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
