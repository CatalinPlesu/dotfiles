from qute_bookmarks.data import BookmarkLibrary, Entity
from qute_bookmarks.config import *
from qute_bookmarks.qutebrowser import QuteBrowser


lib = BookmarkLibrary.load_from_file(BOOKMARKS_FILE)
qb = QuteBrowser()


def run(**kwargs):
    hard_delete = kwargs.get('hard_delete', False)

    url = qb.get_url()
    lib.remove_by_url(url, hard_delete=hard_delete)
    lib.save_to_file(BOOKMARKS_FILE)
