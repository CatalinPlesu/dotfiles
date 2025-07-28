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
    qb.open_url(entity.access_url(), new_tab=new_tab, new_window=new_window)


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
        return (f"🔗 (c:{e.accessed_count}) {display}", open_url, go_back, open_url, (e,), (), (e,))
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
    lib.save_to_file(BOOKMARKS_FILE)
