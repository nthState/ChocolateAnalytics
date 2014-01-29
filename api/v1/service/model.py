from google.appengine.ext import ndb

class Track(ndb.Model):
	trackingId = ndb.StringProperty()
	uniqueId = ndb.StringProperty()
	versionId = ndb.StringProperty()
	events = ndb.JsonProperty()