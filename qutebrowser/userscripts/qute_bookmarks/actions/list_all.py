from enum import Enum, auto
from ..state_machine import *
from qute_bookmarks.data import BookmarkLibrary, Entity, OrderingStrategy, SortBy
from qute_bookmarks.rofi import Rofi
from qute_bookmarks.config import *
from qute_bookmarks.qutebrowser import QuteBrowser


class ListAction(Enum):
    LIST = auto()
    URL = auto()
    QUIT = auto()


lib = BookmarkLibrary.load_from_file(BOOKMARKS_FILE)
rofi = Rofi()
qb = QuteBrowser()
next = ListAction.LIST
new_tab = False
new_window = False


def open_url(entity: Entity):
    global next
    next = ListAction.URL
    qb.open_url(entity.access_url(), new_tab=new_tab, new_window=new_window)


def a_quit():
    global next
    next = ListAction.QUIT


def prepare_entity(e: Entity):
    display = e.name if len(e.name) > 0 else e.url
    return (f"🔗 (c:{e.accessed_count}) {display}", open_url, None, open_url, (e,), (), (e,))


def sort_entities(entities: List[Entity]) -> List[Entity]:
    """Sort entities based on root collection's ordering strategy and sort direction"""
    ordering_strategy = lib.root.ordering_strategy
    sort_by = lib.root.sort_by

    if ordering_strategy == OrderingStrategy.RANDOM:
        import random
        shuffled = entities[:]  # Create a copy
        random.shuffle(shuffled)
        return shuffled

    def get_sort_key(entity: Entity):
        if ordering_strategy == OrderingStrategy.NAME:
            return entity.name.lower() if entity.name else entity.url.lower()
        elif ordering_strategy == OrderingStrategy.CREATED:
            return entity.created_date
        elif ordering_strategy == OrderingStrategy.ACCESSED:
            return entity.last_accessed_date
        elif ordering_strategy == OrderingStrategy.COUNT:
            return entity.accessed_count
        else:
            return entity.name.lower() if entity.name else entity.url.lower()

    reverse = (sort_by == SortBy.DESC)
    return sorted(entities, key=get_sort_key, reverse=reverse)


def list_callback(sm: StateMachine) -> ListAction:
    # Get all entities with URLs across all hierarchies
    entities = lib.root.get_all_entities_with_urls()

    # Sort using root collection's settings
    entities = sort_entities(entities)

    # Prepare menu items
    items_list = [prepare_entity(e) for e in entities]
    custom_items = [
        ("❌ QUIT", a_quit, None, a_quit),
    ]

    rofi.show_menu(custom_items + items_list)
    return next


def url_callback(sm: StateMachine) -> ListAction:
    return None


def quit_callback(sm: StateMachine) -> Optional[ListAction]:
    return None


def run(**kwargs):
    # Define state definitions
    state_definitions = [
        (ListAction.LIST, list_callback),
        (ListAction.URL, url_callback),
        (ListAction.QUIT, quit_callback),
    ]

    # Define exit states
    exit_states = [ListAction.QUIT, ListAction.URL]

    # Instantiate state machine
    sm = StateMachine(
        initial_state=ListAction.LIST,
        state_definitions=state_definitions,
        exit_states=exit_states
    )

    global new_tab
    new_tab = kwargs['new_tab']
    global new_window
    new_window = kwargs['new_window']

    # Run state machine
    sm.run(**kwargs)
    lib.save_to_file(BOOKMARKS_FILE)
