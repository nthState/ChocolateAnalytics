import logging
from baseHandler import BaseHandler

class HomeClassLocalized(BaseHandler):
	def get(self, locale):
		loadHome(self, locale)

class HomeClass(BaseHandler):
	def get(self):
		loadHome(self, self.DefaultLocalization)

def loadHome(self, locale):
	locale = self.GetLocale(locale)
	response = {
		'header': {
			'statusCode': 200,
			'message': 'no message',
			'proposal': 'no proposal'
		},
		'body': None
	}
	self.JSONResponse(response)