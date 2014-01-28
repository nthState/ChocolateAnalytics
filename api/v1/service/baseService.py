import os

class BaseService():

	#Debug = os.environ['HTTP_HOST'].startswith('localhost')
	Debug = True
	BaseUrl = "http://127.0.0.1:8010" if Debug else "http://test.appspot.com"