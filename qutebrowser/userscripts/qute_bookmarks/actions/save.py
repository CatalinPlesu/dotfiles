from enum import Enum, auto
import time
from ..state_machine import *

from qute_bookmarks.data import BookmarkLibrary, Entity
from qute_bookmarks.rofi import Rofi
from qute_bookmarks.config import *
from qute_bookmarks.helper import extract_menu_items
from qute_bookmarks.qutebrowser import QuteBrowser


class SaveAction(Enum):
    OPEN = auto()
    SAVE = auto()
    QUIT = auto()


lib = BookmarkLibrary.load_from_file(BOOKMARKS_FILE)
rofi = Rofi()
qb = QuteBrowser()

next = SaveAction.OPEN


def open_collection(entity: Entity):
    global next
    next = SaveAction.OPEN
    lib.focus_on_entity(entity)


def save_url():
    global next
    next = SaveAction.SAVE


def a_quit():
    global next
    next = SaveAction.QUIT
    lib.focus_on_root()


def go_back():
    global next
    next = SaveAction.OPEN
    lib.go_back()


def prepare_items(x):
    e, t = x
    display = e.name if len(e.name) > 0 else e.url
    if t == "folder":
        return (f"📁 {display}", open_collection,  go_back, open_collection, (e,), (), (e,))
    else:
        return (f"🔗 {display}", open_collection, go_back, open_collection, (e,), (), (e,))


def open_callback(sm: StateMachine) -> SaveAction:
    print(f"State: {sm.current_state}")

    if sm.context.get('focuspath') is not None:
        focuspath = sm.context.pop('focuspath', None)
        if focuspath is not None:
            lib.focus_on_path(focuspath)
        return SaveAction.SAVE

    items = lib.get_current_items()

    if len(items) == 0:
        return SaveAction.SAVE

    items = extract_menu_items(items)
    items_list = [prepare_items(x) for x in items]

    custom_items = [
        ("💾 SAVE - HERE", save_url, go_back, save_url),
        ("❌ QUIT", a_quit, go_back, a_quit),
        ("❎ BACK", go_back, go_back, go_back),
    ]

    new_entity = rofi.show_menu(custom_items + items_list, allow_custom=True)
    if new_entity is not None:
        entity = lib.create_entity_here(name=new_entity)
        lib.focus_on_entity(entity)
        return SaveAction.SAVE

    return next


def save_callback(sm: StateMachine) -> SaveAction:
    print(f"State: {sm.current_state}")
    name = qb.get_title()
    url = qb.get_url()
    lib.create_entity_here(name=name, url=url)
    lib.save_to_file(BOOKMARKS_FILE)
    return None


def quit_callback(sm: StateMachine) -> Optional[SaveAction]:
    print(f"State: {sm.current_state}")
    return None


def run(**kwargs):  # Accepts **kwargs
    # Define your state definitions as a list of tuples
    my_state_definitions = [
        (SaveAction.OPEN, open_callback),
        (SaveAction.SAVE, save_callback),
        (SaveAction.QUIT, quit_callback),
    ]

    # Define the states that should cause the machine to halt
    my_exit_states = [SaveAction.QUIT, SaveAction.SAVE]

    # Instantiate the state machine
    sm = StateMachine(
        initial_state=SaveAction.OPEN,
        state_definitions=my_state_definitions,
        exit_states=my_exit_states
    )

    # Run the state machine, passing parameters to its run method
    sm.run(**kwargs)
