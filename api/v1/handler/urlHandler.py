
from trackerHandler import TrackerClassPlural
from homeHandler import HomeClassLocalized
from homeHandler import HomeClass

#Note: More specific first.

urls = [
	('/v1/(.*)/tracker', TrackerClassPlural),#[post]
	('/v1/(.*)', HomeClassLocalized),
	('/v1', HomeClass),
	('/', HomeClass)
]