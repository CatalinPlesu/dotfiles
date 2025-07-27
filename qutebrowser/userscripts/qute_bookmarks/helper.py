def extract_menu_items(items):
    result = []
    for item in items:
        if item.collection and len(item.collection.children) > 0:
            result.append((item, "folder"))
        if len(item.url) > 0:
            result.append((item, "url"))
    return result

