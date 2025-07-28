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
from pathlib import Path
import os

DATA_DIR = Path.home() / "Documents/qutebrowser_bookmarks"
BOOKMARKS_FILE = DATA_DIR / "bookmarks.json"

# for testing
BOOKMARKS_FILE = "/home/catalin/.config/qutebrowser/userscripts/test.json"
from datetime import datetime, date
from typing import Optional, List, Dict, Any
from enum import Enum
import json

class OrderingStrategy(Enum):
    NAME = "name"
    CREATED = "created"
    ACCESSED = "accessed"
    COUNT = "count"
    MANUAL = "manual"

class SortBy(Enum):
    ASC = "asc"
    DESC = "desc"

class EntityCollection:
    def __init__(
        self,
        ordering_strategy: Optional[OrderingStrategy] = OrderingStrategy.CREATED,
        sort_by: Optional[SortBy] = SortBy.DESC,
        children: Optional[List['Entity']] = None,
    ):
        self.ordering_strategy = ordering_strategy
        self.sort_by = sort_by
        self.children: List['Entity'] = children or []
    
    def list_items(self) -> List['Entity']:
        return self.children
    
    def _name_or_url_exists(self, name: str, url: str) -> bool:
        for child in self.children:
            if (name and child.name == name) or (url and child.url == url):
                return True
        return False
    
    def add_item(self, entity: 'Entity') -> bool:
        if self._name_or_url_exists(entity.name, entity.url):
            return False
        self.children.append(entity)
        return True
    
    def remove_by_url(self, url: str) -> bool:
        for i, child in enumerate(self.children):
            if child.url == url:
                del self.children[i]
                return True
            if child.collection and child.collection.remove_by_url(url):
                return True
        return False
    
    def _to_dict(self) -> Dict[str, Any]:
        return {
            "ordering_strategy": self.ordering_strategy.value,
            "sort_by": self.sort_by.value,
            "children": [child._to_dict() for child in self.children]
        }
    
    @classmethod
    def _from_dict(cls, data: Dict[str, Any]) -> 'EntityCollection':
        collection = cls(
            ordering_strategy=OrderingStrategy(data.get("ordering_strategy", "created")),
            sort_by=SortBy(data.get("sort_by", "desc")),
        )
        collection.children = [Entity._from_dict(child) for child in data.get("children", [])]
        return collection

class Entity:
    def __init__(
        self,
        name: str = "",
        url: str = "",
        created_date: date = None,
        last_accessed_date: date = None,
        accessed_count: int = 0,
        collection: Optional[EntityCollection] = None,
    ):
        self.name = name
        self.url = url
        self.created_date = created_date if created_date is not None else date.today()
        self.last_accessed_date = last_accessed_date if last_accessed_date is not None else date.today()
        self.accessed_count = accessed_count
        self.collection = collection
    
    def edit(self, name: Optional[str] = None, url: Optional[str] = None, 
             last_accessed_date: Optional[date] = None, accessed_count: Optional[int] = None) -> None:
        if name is not None:
            self.name = name
        if url is not None:
            self.url = url
        if last_accessed_date is not None:
            self.last_accessed_date = last_accessed_date
        if accessed_count is not None:
            self.accessed_count = accessed_count
    
    def _to_dict(self) -> Dict[str, Any]:
        data = {
            "name": self.name,
            "url": self.url,
            "created_date": self.created_date.isoformat(),
            "last_accessed_date": self.last_accessed_date.isoformat(),
            "accessed_count": self.accessed_count,
        }
        if self.collection is not None:
            data["collection"] = self.collection._to_dict()
        return data
    
    @classmethod
    def _from_dict(cls, data: Dict[str, Any]) -> 'Entity':
        entity = cls(
            name=data.get("name", ""),
            url=data.get("url", ""),
            created_date=date.fromisoformat(data["created_date"]) if "created_date" in data else date.today(),
            last_accessed_date=date.fromisoformat(data["last_accessed_date"]) if "last_accessed_date" in data else date.today(),
            accessed_count=data.get("accessed_count", 0),
        )
        if "collection" in data:
            entity.collection = EntityCollection._from_dict(data["collection"])
        return entity

class BookmarkLibrary:
    def __init__(self):
        self.current_collection = None
        self.current_path = ""
        self._history_stack: List[EntityCollection] = []
    
    def focus_on_root(self) -> EntityCollection:
        self.current_collection = self.root
        self.current_path = "/"
        self._history_stack.clear()
        self._debug_print()
        return self.current_collection
    
    def focus_on_entity(self, entity: Entity) -> EntityCollection:
        if entity.collection is None:
            entity.collection = EntityCollection()

        self._history_stack.append(self.current_collection)
        self.current_collection = entity.collection
        self.current_path = f"{self.current_path.rstrip('/')}/{entity.name}"
        self._debug_print()
        return self.current_collection


    def focus_on_path(self, path: str) -> Optional[EntityCollection]:
        path_parts = [p for p in path.split('/') if p]
        
        if not path_parts:
            print("Invalid path provided. Path cannot be empty.")
            return None

        # Clear history and start from root for a full path navigation
        self.focus_on_root() 
        temp_current_collection = self.current_collection
        temp_current_path = self.current_path
        temp_history_stack = self._history_stack.copy() # Make a copy to revert if path is invalid

        # Store the current state before attempting navigation to allow rollback
        original_current_collection = self.current_collection
        original_current_path = self.current_path
        original_history_stack = self._history_stack.copy()

        try:
            for part in path_parts:
                found_entity = None
                for child in temp_current_collection.children:
                    if child.name == part:
                        found_entity = child
                        break
                
                if found_entity:
                    if found_entity.collection is None:
                        print(f"Cannot focus on '{part}': It is a bookmark, not a folder (collection).")
                        # Revert to original state
                        self.current_collection = original_current_collection
                        self.current_path = original_current_path
                        self._history_stack = original_history_stack
                        self._debug_print()
                        return None
                    
                    # Store the current collection before moving deeper
                    self._history_stack.append(temp_current_collection) 
                    temp_current_collection = found_entity.collection
                    temp_current_path = f"{temp_current_path.rstrip('/')}/{found_entity.name}"
                else:
                    print(f"Entity '{part}' not found in the current hierarchy.")
                    # Revert to original state
                    self.current_collection = original_current_collection
                    self.current_path = original_current_path
                    self._history_stack = original_history_stack
                    self._debug_print()
                    return None
            
            # If the loop completes, the path is valid. Update the actual state.
            self.current_collection = temp_current_collection
            self.current_path = temp_current_path
            # The history stack has been updated incrementally during the loop, 
            # so it's already in the correct state if the path was valid.
            
            self._debug_print()
            return self.current_collection

        except Exception as e:
            print(f"An error occurred while focusing on path: {e}")
            # Revert to original state in case of unexpected errors
            self.current_collection = original_current_collection
            self.current_path = original_current_path
            self._history_stack = original_history_stack
            self._debug_print()
            return None

    def go_back(self) -> Optional[EntityCollection]:
        if self._history_stack:
            self.current_collection = self._history_stack.pop()
            if self.current_collection == self.root:
                self.current_path = "/"
            else:
                path_parts = [p for p in self.current_path.split('/') if p]
                if path_parts:
                    self.current_path = "/" + "/".join(path_parts[:-1])
                else:
                    self.current_path = "/"
            self._debug_print()
            return self.current_collection
        else:
            print("Already at the root. Cannot go back further.")
            return None

    def _debug_print(self) -> None:
        items = self.current_collection.list_items() if self.current_collection else []
        print(f"[{self.current_path}] {len(items)} items: " + 
              ", ".join([item.name for item in items[:5]]) +
              ("..." if len(items) > 5 else ""))
    
    def get_current_items(self) -> List[Entity]:
        if self.current_collection:
            return self.current_collection.list_items()
        return []
    
    def create_entity_here(self, name: str, url: str = "") -> Optional[Entity]:
        if self.current_collection is None:
            self.current_collection = self.root
        
        entity = Entity(name=name, url=url)
        if self.current_collection.add_item(entity):
            self._debug_print()
            return entity
        else:
            print(f"Entity with name '{name}' or url '{url}' already exists at this level")
            return None
    
    def remove_by_url(self, url: str) -> bool:
        return self.root.remove_by_url(url)
    
    def remove_by_name(self, name: str) -> bool:
        return self._remove_by_name_recursive(self.root, name)
    
    def remove_by_path(self, path: str) -> bool:
        path_parts = [p for p in path.split('/') if p]
        if not path_parts:
            return False
        return self._remove_by_path_recursive(self.root, path_parts)
    
    def _remove_by_name_recursive(self, collection: EntityCollection, name: str) -> bool:
        for i, child in enumerate(collection.children):
            if child.name == name:
                del collection.children[i]
                return True
            if child.collection and self._remove_by_name_recursive(child.collection, name):
                return True
        return False
    
    def _remove_by_path_recursive(self, collection: EntityCollection, path_parts: List[str]) -> bool:
        if len(path_parts) == 1:
            for i, child in enumerate(collection.children):
                if child.name == path_parts[0]:
                    del collection.children[i]
                    return True
            return False
        else:
            for child in collection.children:
                if child.name == path_parts[0] and child.collection:
                    return self._remove_by_path_recursive(child.collection, path_parts[1:])
            return False
    
    def move_entity(self, entity_name: str, target_path: str) -> bool:
        entity = self._find_and_remove_entity(self.root, entity_name)
        if not entity:
            print(f"Entity '{entity_name}' not found")
            return False
        
        target_collection = self._create_path_if_needed(target_path)
        if target_collection.add_item(entity):
            print(f"Moved '{entity_name}' to '{target_path}'")
            return True
        else:
            self.root.add_item(entity)  # Add back to root if failed
            print(f"Cannot move '{entity_name}' to '{target_path}' - name or url conflict")
            return False
   
    def move_children(self, source_entity_name: str, target_path: str) -> bool:
        """
        Move all children of the specified entity to the target path.
        
        Args:
            source_entity_name: Name of the entity whose children should be moved
            target_path: Path where children should be moved to
            
        Returns:
            bool: True if any children were moved, False otherwise
        """
        # Find the source entity
        source_entity = self._find_entity(self.root, source_entity_name)
        if not source_entity:
            print(f"Entity '{source_entity_name}' not found")
            return False
        
        # Check if source has children to move
        if not source_entity.collection or not source_entity.collection.children:
            print(f"Entity '{source_entity_name}' has no children to move")
            return False
        
        # Get or create the target collection
        target_collection = self._create_path_if_needed(target_path)
        
        # Check if we're trying to move to the same collection
        if source_entity.collection == target_collection:
            print(f"Cannot move children - source and target are the same")
            return False
        
        # Move children one by one
        children_to_move = source_entity.collection.children.copy()
        moved_count = 0
        
        for child in children_to_move:
            # Skip if child already exists in target
            if target_collection._name_or_url_exists(child.name, child.url):
                print(f"Skipping '{child.name}' - already exists in target")
                continue
                
            if target_collection.add_item(child):
                source_entity.collection.children.remove(child)
                moved_count += 1
            else:
                print(f"Could not move child '{child.name}' - unknown error")
        
        if moved_count > 0:
            print(f"Moved {moved_count} children from '{source_entity_name}' to '{target_path}'")
            return True
        else:
            print(f"No children could be moved from '{source_entity_name}' to '{target_path}'")
            return False


    def _find_and_remove_entity(self, collection: EntityCollection, name: str) -> Optional[Entity]:
        for i, child in enumerate(collection.children):
            if child.name == name:
                return collection.children.pop(i)
            if child.collection:
                found = self._find_and_remove_entity(child.collection, name)
                if found:
                    return found
        return None
    
    def move_children(self, entity_name: str, target_path: str) -> bool:
        entity = self._find_entity(self.root, entity_name)
        if not entity:
            print(f"Entity '{entity_name}' not found")
            return False
        
        if not entity.collection or not entity.collection.children:
            print(f"Entity '{entity_name}' has no children to move")
            return False
        
        target_collection = self._create_path_if_needed(target_path)
        children_to_move = entity.collection.children.copy()
        moved_count = 0
        
        for child in children_to_move:
            if target_collection.add_item(child):
                entity.collection.children.remove(child)
                moved_count += 1
            else:
                print(f"Cannot move child '{child.name}' - name or url conflict")
        
        if moved_count > 0:
            print(f"Moved {moved_count} children from '{entity_name}' to '{target_path}'")
            return True
        else:
            print(f"No children could be moved from '{entity_name}' to '{target_path}'")
            return False
    
    def _find_entity(self, collection: EntityCollection, name: str) -> Optional[Entity]:
        for child in collection.children:
            if child.name == name:
                return child
            if child.collection:
                found = self._find_entity(child.collection, name)
                if found:
                    return found
        return None
        path_parts = [p for p in path.split('/') if p]
        current_collection = self.root
        
        for part in path_parts:
            found = None
            for child in current_collection.children:
                if child.name == part:
                    found = child
                    break
            
            if found:
                if found.collection is None:
                    found.collection = EntityCollection()
                current_collection = found.collection
            else:
                new_entity = Entity(name=part, collection=EntityCollection())
                current_collection.add_item(new_entity)
                current_collection = new_entity.collection
        
        return current_collection
   
    def _create_path_if_needed(self, path: str) -> EntityCollection:
        path_parts = [p for p in path.split('/') if p]
        current_collection = self.root
        
        for part in path_parts:
            found = None
            for child in current_collection.children:
                if child.name == part:
                    found = child
                    break
            
            if found:
                if found.collection is None:
                    found.collection = EntityCollection()
                current_collection = found.collection
            else:
                new_entity = Entity(name=part, collection=EntityCollection())
                current_collection.add_item(new_entity)
                current_collection = new_entity.collection
        
        return current_collection
    

    def save_to_file(self, filepath: str) -> None:
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump({"root": self.root._to_dict()}, f, indent=2)
    
    @classmethod
    def load_from_file(cls, filepath: str) -> 'BookmarkLibrary':
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
                instance = cls()
                instance.root = EntityCollection._from_dict(data["root"])
                instance.focus_on_root()
                return instance
        except (FileNotFoundError, json.JSONDecodeError):
            instance = cls()
            instance.root = EntityCollection()
            instance.focus_on_root()
            return instance
def extract_menu_items(items):
    result = []
    for item in items:
        if item.collection and len(item.collection.children) > 0:
            result.append((item, "folder"))
        if len(item.url) > 0:
            result.append((item, "url"))
    return result

# qute_bookmarks/__init__.py
"""Package for managing qutebrowser bookmarks with Rofi interaction."""
import os


class QuteBrowser:
    def __init__(self):
        self._url = os.environ.get("QUTE_URL")
        self._title = os.environ.get("QUTE_TITLE")
        self._fifo_path = os.environ.get("QUTE_FIFO")
        # ADD THIS LINE TO DEBUG
        print(f"DEBUG: QUTE_FIFO path initialized as: {self._fifo_path}")

    def get_url(self):
        return self._url

    def get_title(self):
        return self._title

    def send_command(self, command: str):
        # ADD THIS LINE TO DEBUG
        print(f"DEBUG: Attempting to send command '{
              command}'. FIFO path: {self._fifo_path}")
        if not self._fifo_path:
            # ADD THIS
            print("ERROR: QUTE_FIFO path is not set. Cannot send command.")
            return
        try:
            with open(self._fifo_path, 'a') as fifo_file:
                fifo_file.write(command + '\n')
            print(f"DEBUG: Command '{
                  command}' successfully written to FIFO.")  # ADD THIS
        except (FileNotFoundError, IOError) as e:
            print(f"ERROR: Failed to write to FIFO: {e}")  # ADD THIS
            pass

    def open_url(self, url: str, new_tab: bool = False, new_window: bool = False):
        command = "open"
        if new_window:
            command += " -w"
        elif new_tab:
            command += " -t"
        command += f" {url}"
        self.send_command(command)
from typing import List, Optional, Union, Callable, Tuple, Any, Dict
import subprocess


class Rofi:
    def __init__(self):
        self.is_on = False

    def dmenu(self,
              prompt: str,
              options: List[str],
              allow_custom: bool = False) -> Tuple[Optional[str], int]:
        """Rofi dmenu with support for Shift+H and Shift+L"""
        cmd = [
            "rofi", "-dmenu", "-i", "-p", prompt,
            "-kb-move-char-back", "",
            "-kb-move-char-forward", "",
            "-kb-custom-1", "Left",
            "-kb-custom-2", "Right"
        ]
        if allow_custom:
            cmd.extend(["-mesg", "Type custom value and press Enter"])
        input_text = "\n".join(options) if options else ""
        proc = subprocess.run(
            cmd,
            input=input_text,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        selected = proc.stdout.strip() if proc.stdout else None
        return selected, proc.returncode

    def show_menu(self,
                  items: List[Union[
                      str,
                      Tuple[str, Callable],  # default enter
                      # enter, shift+h, shift+l
                      Tuple[str, Callable, Callable, Callable],
                      Tuple[str, Callable, Callable, Callable, Tuple[Any, ...],
                            Tuple[Any, ...], Tuple[Any, ...]]  # full
                  ]],
                  prompt: str = "Select:",
                  allow_custom: bool = False) -> Optional[str]:
        """
        Enhanced menu with support for Enter, Shift+H and Shift+L callbacks.

        Each item can be:
            - str
            - (text, enter_cb)
            - (text, enter_cb, shift_h_cb, shift_l_cb)
            - (text, enter_cb, shift_h_cb, shift_l_cb, enter_args, h_args, l_args)
        """
        display_options = []
        callback_map: Dict[str, Tuple[Optional[Callable], Optional[Callable],
                                      Optional[Callable], Tuple[Any, ...], Tuple[Any, ...], Tuple[Any, ...]]] = {}

        for item in items:
            if isinstance(item, str):
                display_options.append(item)
                callback_map[item] = (None, None, None, (), (), ())
            elif len(item) == 2:
                text, enter_cb = item
                display_options.append(text)
                callback_map[text] = (enter_cb, None, None, (), (), ())
            elif len(item) == 4:
                text, enter_cb, h_cb, l_cb = item
                display_options.append(text)
                callback_map[text] = (enter_cb, h_cb, l_cb, (), (), ())
            elif len(item) >= 7:
                text, enter_cb, h_cb, l_cb, enter_args, h_args, l_args = item
                display_options.append(text)
                callback_map[text] = (
                    enter_cb, h_cb, l_cb, enter_args, h_args, l_args)

        selected, code = self.dmenu(prompt, display_options, allow_custom)

        if not selected or selected not in callback_map:
            return None

        enter_cb, h_cb, l_cb, enter_args, h_args, l_args = callback_map[selected]

        if code == 0 and enter_cb:
            enter_cb(*enter_args)
        elif code == 10 and h_cb:
            h_cb(*h_args)
        elif code == 11 and l_cb:
            l_cb(*l_args)

        return selected
from typing import Any, Callable, Dict, List, Optional, Tuple

class StateMachine:
    def __init__(
        self,
        initial_state: Any,
        state_definitions: List[Tuple[Any, Callable[['StateMachine'], Any]]],
        exit_states: List[Any]
    ):
        self._current_state = initial_state
        self._state_callbacks: Dict[Any, Callable[..., Any]] = {}
        self._context: Dict[str, Any] = {} # Initialized as empty
        self._exit_states = exit_states

        for state, callback in state_definitions:
            self.define_state(state, callback)

    @property
    def current_state(self) -> Any:
        return self._current_state

    @property
    def context(self) -> Dict[str, Any]:
        return self._context

    def define_state(self, state: Any, callback: Callable[..., Any]):
        self._state_callbacks[state] = callback

    def process_current_state(self) -> bool: # No *args, **kwargs here
        callback = self._state_callbacks.get(self._current_state)

        if callback:
            try:
                # Call callback, passing only 'self' (StateMachine instance)
                # Callbacks will access parameters directly from sm.context
                next_state = callback(self)

                if next_state is None:
                    return False
                elif next_state == self._current_state:
                    return True
                elif next_state not in self._state_callbacks and next_state is not None:
                    self._current_state = next_state
                    return True
                else:
                    self._current_state = next_state
                    return True
            except Exception as e:
                print(f"Error in state '{self._current_state}': {e}")
                return False
        else:
            return False

    def run(self, **kwargs): # Accepts **kwargs for initial parameters
        """
        Runs the state machine. Parameters passed to run() are stored in context.
        """
        self._context.update(kwargs) # Store parameters in context before running
        # print("--- State Machine Running ---") # Removed as per "no much prints"
        while True:
            state_being_processed = self.current_state

            should_continue_processing = self.process_current_state()

            if not should_continue_processing:
                break

            if state_being_processed in self._exit_states:
                break
        # print("--- State Machine Halted ---") # Removed as per "no much prints"
# qute_bookmarks/actions/__init__.py
"""Package for managing qutebrowser bookmarks with Rofi interaction."""
from enum import Enum, auto
import time
from ..state_machine import *

from qute_bookmarks.data import BookmarkLibrary, Entity
from qute_bookmarks.rofi import Rofi
from qute_bookmarks.config import *
from qute_bookmarks.helper import extract_menu_items
from qute_bookmarks.qutebrowser import QuteBrowser


class OpenAction(Enum):
    OPEN = auto()
    URL = auto()
    QUIT = auto()


lib = BookmarkLibrary.load_from_file(BOOKMARKS_FILE)
rofi = Rofi()
qb = QuteBrowser()

next = OpenAction.OPEN
new_tab = False
new_window = False


def open_collection(entity: Entity):
    global next
    next = OpenAction.OPEN
    lib.focus_on_entity(entity)


def open_url(entity: Entity):
    global next
    next = OpenAction.URL
    qb.open_url(entity.url, new_tab=new_tab, new_window=new_window)


def a_quit():
    global next
    next = OpenAction.QUIT
    lib.focus_on_root()


def go_back():
    global next
    next = OpenAction.OPEN
    lib.go_back()


def prepare_items(x):
    e, t = x
    display = e.name if len(e.name) > 0 else e.url
    if t == "folder":
        return (f"📁 {display}", open_collection,  go_back, open_collection, (e,), (), (e,))
    else:
        return (f"🔗 {display}", open_url, go_back, open_url, (e,), (), (e,))
# --- Your Callback Functions (accessing params from sm.context) ---


def open_callback(sm: StateMachine) -> OpenAction:
    print(f"State: {sm.current_state}")

    focuspath = sm.context.pop('focuspath', None)
    if focuspath is not None:
        lib.focus_on_path(focuspath)

    items = lib.get_current_items()
    items = extract_menu_items(items)
    print("was here")
    items_list = [prepare_items(x) for x in items]

    custom_items = [
        ("❌ QUIT", a_quit, go_back, a_quit),
        ("❎ BACK", go_back, go_back, go_back),
    ]
    rofi.show_menu(custom_items + items_list)

    return next


def url_callback(sm: StateMachine) -> OpenAction:
    print(f"State: {sm.current_state}")
    return None


def quit_callback(sm: StateMachine) -> Optional[OpenAction]:
    print(f"State: {sm.current_state}")
    return None

# --- Main run function ---


def run(**kwargs):  # Accepts **kwargs
    # Define your state definitions as a list of tuples
    my_state_definitions = [
        (OpenAction.OPEN, open_callback),
        (OpenAction.URL, url_callback),
        (OpenAction.QUIT, quit_callback),
    ]

    # Define the states that should cause the machine to halt
    my_exit_states = [OpenAction.QUIT, OpenAction.URL]

    # Instantiate the state machine
    sm = StateMachine(
        initial_state=OpenAction.OPEN,
        state_definitions=my_state_definitions,
        exit_states=my_exit_states
    )

    global new_tab
    new_tab = kwargs['new_tab']
    global new_window
    new_window = kwargs['new_window']
    # Run the state machine, passing parameters to its run method
    sm.run(**kwargs)
    # Run the state machine, passing parameters to its run method
    sm.run(**kwargs)
