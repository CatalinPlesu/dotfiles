import random
import time

from qute_bookmarks.data import BookmarkLibrary, Entity, EntityCollection
from qute_bookmarks.config import *
from qute_bookmarks.qutebrowser import QuteBrowser

lib = BookmarkLibrary.load_from_file(BOOKMARKS_FILE)
qb = QuteBrowser()


def _collect_entities_with_urls_recursive(collection: EntityCollection) -> list[Entity]:
    eligible_entities = []
    for child in collection.children:
        if child.url and child.url != "":
            eligible_entities.append(child)
        if child.collection:
            eligible_entities.extend(
                _collect_entities_with_urls_recursive(child.collection))
    return eligible_entities


def _find_collection_by_path(root_collection: EntityCollection, path_parts: list[str]) -> EntityCollection | None:
    current = root_collection
    for part in path_parts:
        found_next = None
        for child in current.children:
            if child.name == part and child.collection:
                found_next = child.collection
                break
        if found_next is None:
            return None
        current = found_next
    return current


def run(**kwargs):
    focuspath = kwargs.get('focuspath', None)
    new_tab = kwargs.get('new_tab', False)
    new_window = kwargs.get('new_window', False)

    eligible_entities = []

    if focuspath:
        path_parts = [p for p in focuspath.split('/') if p]
        target_collection = _find_collection_by_path(lib.root, path_parts)
        if target_collection:
            eligible_entities = _collect_entities_with_urls_recursive(
                target_collection)
        else:
            print(f"Error: Folder '{focuspath}' not found.")
            return
    else:
        eligible_entities = _collect_entities_with_urls_recursive(lib.root)

    if not eligible_entities:
        if focuspath:
            print(f"No entities with URLs found in folder '{focuspath}'.")
        else:
            print("No entities with URLs found across all hierarchies.")
        return

    selected_entity = random.choice(eligible_entities)
    qb.open_url(selected_entity.url, new_tab=new_tab, new_window=new_window)
