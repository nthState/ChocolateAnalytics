import json
import logging
from baseHandler import BaseHandler
from v1.service.trackerService import TrackerService

class TrackerClassPlural(BaseHandler):
	def get(self, locale):
		locale = self.GetLocale(locale)
		response = TrackerService.Track(locale, None)
		self.JSONResponse(response)
	def post(self, locale):
		locale = self.GetLocale(locale)
		logging.info(self.request.headers['Json'])
		#response = TrackerService.Track(locale, json.loads(self.request.body))
		response = TrackerService.Track(locale, json.loads(self.request.headers['Json']))
		self.JSONResponse(response)