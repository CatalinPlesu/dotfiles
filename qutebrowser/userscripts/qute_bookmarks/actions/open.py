# open.py to be modified
from enum import Enum, auto
import time
from ..state_machine import *
from qute_bookmarks.data import BookmarkLibrary, Entity, OrderingStrategy, SortBy
from qute_bookmarks.rofi import Rofi
from qute_bookmarks.config import *
from qute_bookmarks.helper import extract_menu_items
from qute_bookmarks.qutebrowser import QuteBrowser


class OpenAction(Enum):
    OPEN = auto()
    URL = auto()
    QUIT = auto()
    SETTINGS = auto()


lib = BookmarkLibrary.load_from_file(BOOKMARKS_FILE)
rofi = Rofi()
qb = QuteBrowser()
next = OpenAction.OPEN
new_tab = False
new_window = False

# Settings will be read from lib.current_collection


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


def open_settings():
    global next
    next = OpenAction.SETTINGS


def prepare_items(x):
    e, t = x
    display = e.name if len(e.name) > 0 else e.url
    if t == "folder":
        return (f"📁 {display}", open_collection,  go_back, open_collection, (e,), (), (e,))
    else:
        return (f"🔗 (c:{e.accessed_count}) {display}", open_url, go_back, open_url, (e,), (), (e,))


def sort_items(items):
    """Sort items based on current ordering strategy and sort direction"""
    ordering_strategy = lib.current_collection.ordering_strategy
    sort_by = lib.current_collection.sort_by

    if ordering_strategy == OrderingStrategy.RANDOM:
        import random
        shuffled = items[:]  # Create a copy
        random.shuffle(shuffled)
        return shuffled

    def get_sort_key(item):
        entity, _ = item
        if ordering_strategy == OrderingStrategy.NAME:
            return entity.name.lower() if entity.name else entity.url.lower()
        elif ordering_strategy == OrderingStrategy.CREATED:
            return getattr(entity, 'created_time', 0)
        elif ordering_strategy == OrderingStrategy.ACCESSED:
            return getattr(entity, 'last_accessed', 0)
        elif ordering_strategy == OrderingStrategy.COUNT:
            return getattr(entity, 'accessed_count', 0)
        else:
            return entity.name.lower() if entity.name else entity.url.lower()

    reverse = (sort_by == SortBy.DESC)
    return sorted(items, key=get_sort_key, reverse=reverse)


def set_ordering_strategy(strategy: OrderingStrategy):
    global next
    lib.current_collection.ordering_strategy = strategy
    next = OpenAction.SETTINGS


def set_sort_by(sort_by: SortBy):
    global next
    lib.current_collection.sort_by = sort_by
    next = OpenAction.SETTINGS


def back_to_main():
    global next
    next = OpenAction.OPEN

# --- Your Callback Functions (accessing params from sm.context) ---


def open_callback(sm: StateMachine) -> OpenAction:
    print(f"State: {sm.current_state}")
    focuspath = sm.context.pop('focuspath', None)
    if focuspath is not None:
        lib.focus_on_path(focuspath)

    items = lib.get_current_items()
    items = extract_menu_items(items)

    # Sort items based on current settings
    items = sort_items(items)

    print("was here")
    items_list = [prepare_items(x) for x in items]
    custom_items = [
        ("❌ QUIT", a_quit, go_back, a_quit),
        ("❎ BACK", go_back, go_back, go_back),
        ("⚙️ SETTINGS", open_settings, go_back, open_settings),
    ]
    rofi.show_menu(custom_items + items_list)
    return next


def settings_callback(sm: StateMachine) -> OpenAction:
    print(f"State: {sm.current_state}")

    # Get current settings from lib.current_collection
    current_ordering_strategy = lib.current_collection.ordering_strategy
    current_sort_by = lib.current_collection.sort_by

    # Create settings menu items
    ordering_items = []
    for strategy in OrderingStrategy:
        current_marker = "✓" if strategy == current_ordering_strategy else " "
        ordering_items.append((
            f"[{current_marker}] Order by: {strategy.value.title()}",
            set_ordering_strategy,
            back_to_main,
            set_ordering_strategy,
            (strategy,), (), (strategy,)
        ))

    sort_items = []
    for sort_by in SortBy:
        current_marker = "✓" if sort_by == current_sort_by else " "
        sort_items.append((
            f"[{current_marker}] Sort: {sort_by.value.upper()}",
            set_sort_by,
            back_to_main,
            set_sort_by,
            (sort_by,), (), (sort_by,)
        ))

    custom_items = [
        ("❎ BACK TO MAIN", back_to_main, back_to_main, back_to_main),
        ("", None, None, None),  # Separator
    ]

    all_items = custom_items + ordering_items + \
        [("", None, None, None)] + sort_items

    rofi.show_menu(all_items)
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
        (OpenAction.SETTINGS, settings_callback),
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
