#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- encoding: utf-8 -*-

import os
import webapp2
from google.appengine.ext.webapp import util
#from v1_1 import urlHandler as v1_1  + v1_1.urls
import v1.handler.urlHandler as v1

application = webapp2.WSGIApplication(v1.urls,debug=os.environ['HTTP_HOST'].startswith('localhost'))
util.run_wsgi_app(application)