from google.appengine.ext import ndb

class Track(ndb.Model):
	trackingId = ndb.StringProperty()
	uniqueId = ndb.StringProperty()
	version = ndb.StringProperty()
	events = ndb.JsonProperty()