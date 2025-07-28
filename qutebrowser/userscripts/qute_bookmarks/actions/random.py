import random
import time

from qute_bookmarks.data import BookmarkLibrary, Entity, EntityCollection
from qute_bookmarks.config import *
from qute_bookmarks.qutebrowser import QuteBrowser

lib = BookmarkLibrary.load_from_file(BOOKMARKS_FILE)
qb = QuteBrowser()


def run(**kwargs):
    focuspath = kwargs.get('focuspath', None)
    new_tab = kwargs.get('new_tab', False)
    new_window = kwargs.get('new_window', False)

    entity = lib.get_random_entity(focuspath)
    qb.open_url(entity.url, new_tab=new_tab, new_window=new_window)
