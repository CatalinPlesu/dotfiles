from random import randrange
def startpage():
	pages = [
	'https://twitter.com/Raichiyo33',
	'https://twitter.com/akairiot?lang=en',
	'https://twitter.com/dh_k___?lang=en',
	'https://twitter.com/navigavi',
	'https://twitter.com/parorou?lang=en',
	'https://twitter.com/y_o_m_y_o_m',
	'https://www.artstation.com/angstern/likes',
	'https://www.artstation.com/arowana',
	'https://www.artstation.com/nisp_art',
	'https://www.artstation.com/romana_0',
	'https://www.artstation.com/samurainokokoro/likes',
	'https://www.artstation.com/yamatoren/likes',
	'https://www.instagram.com/myinputwo/',
	'https://www.instagram.com/yuumeiart/',
	'https://www.pixiv.net/en/users/10012651',
	'https://www.pixiv.net/en/users/12845810',
	'https://www.pixiv.net/en/users/2750098',
	'https://www.pixiv.net/en/users/4480830',
	'https://www.reddit.com/r/awwnime/',
	'https://www.reddit.com/r/ecchi/',
	'https://www.pixiv.net/en/users/6210796/illustrations',
	'https://www.pixiv.net/en/users/554102/illustrations',
	'https://www.deviantart.com/watch/deviations',
	'https://www.pixiv.net/en/users/189732',
	'https://www.pixiv.net/en/users/14143785',
	'https://www.artstation.com/nefred',
	'',
	]
	return pages[randrange(0,len(pages)-2)]
print(startpage())
