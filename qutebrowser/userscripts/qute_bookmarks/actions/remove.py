from qute_bookmarks.data import BookmarkLibrary, Entity
from qute_bookmarks.config import *
from qute_bookmarks.qutebrowser import QuteBrowser


lib = BookmarkLibrary.load_from_file(BOOKMARKS_FILE)
qb = QuteBrowser()


def run(**kwargs):
    url = qb.get_url()
    lib.remove_by_url(url)
    lib.save_to_file(BOOKMARKS_FILE)
