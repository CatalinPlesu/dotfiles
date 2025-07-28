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

    def remove_by_url(self, url: str, hard_delete: bool = False) -> bool:
        removed_any = False
        new_children = []

        for child in self.children:
            if child.url == url:
                removed_any = True
                if not hard_delete and child.collection:
                    # Soft delete: promote children of the deleted entity
                    new_children.extend(child.collection.children)
            else:
                # If the child itself is not removed, check its collection recursively.
                # Only call remove_by_url on the child's collection if it exists.
                if child.collection and child.collection.remove_by_url(url, hard_delete):
                    removed_any = True
                new_children.append(child)

        self.children = new_children
        return removed_any

    def _to_dict(self) -> Dict[str, Any]:
        return {
            "ordering_strategy": self.ordering_strategy.value,
            "sort_by": self.sort_by.value,
            "children": [child._to_dict() for child in self.children]
        }

    @classmethod
    def _from_dict(cls, data: Dict[str, Any]) -> 'EntityCollection':
        collection = cls(
            ordering_strategy=OrderingStrategy(
                data.get("ordering_strategy", "created")),
            sort_by=SortBy(data.get("sort_by", "desc")),
        )
        collection.children = [Entity._from_dict(
            child) for child in data.get("children", [])]
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
            created_date=date.fromisoformat(
                data["created_date"]) if "created_date" in data else date.today(),
            last_accessed_date=date.fromisoformat(
                data["last_accessed_date"]) if "last_accessed_date" in data else date.today(),
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
        # Make a copy to revert if path is invalid
        temp_history_stack = self._history_stack.copy()

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
                        print(f"Cannot focus on '{
                              part}': It is a bookmark, not a folder (collection).")
                        # Revert to original state
                        self.current_collection = original_current_collection
                        self.current_path = original_current_path
                        self._history_stack = original_history_stack
                        self._debug_print()
                        return None

                    # Store the current collection before moving deeper
                    self._history_stack.append(temp_current_collection)
                    temp_current_collection = found_entity.collection
                    temp_current_path = f"{
                        temp_current_path.rstrip('/')}/{found_entity.name}"
                else:
                    print(
                        f"Entity '{part}' not found in the current hierarchy.")
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
            print(f"Entity with name '{name}' or url '{
                  url}' already exists at this level")
            return None

    def remove_by_url(self, url: str, hard_delete: bool = False) -> bool:
        return self.root.remove_by_url(url, hard_delete=hard_delete)

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
            print(f"Cannot move '{entity_name}' to '{
                  target_path}' - name or url conflict")
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
            print(f"Moved {moved_count} children from '{
                  source_entity_name}' to '{target_path}'")
            return True
        else:
            print(f"No children could be moved from '{
                  source_entity_name}' to '{target_path}'")
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
                print(f"Cannot move child '{
                      child.name}' - name or url conflict")

        if moved_count > 0:
            print(f"Moved {moved_count} children from '{
                  entity_name}' to '{target_path}'")
            return True
        else:
            print(f"No children could be moved from '{
                  entity_name}' to '{target_path}'")
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
