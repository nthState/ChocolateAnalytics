import logging
from baseService import BaseService
from model import Track as TrackModel

class TrackerService(BaseService):

	@staticmethod
	def Track(locale, data):
	
		if not data:
			return {}
	
		mdl = TrackModel()
		mdl.trackingId = data.get('trackingId', 'None')
		mdl.uniqueId = data.get('uniqueId', 'None')
		mdl.version = data.get('version', 'None')
		mdl.events = data.get('events', 'None')
		mdl.put()
	
		return {}
