#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- encoding: utf-8 -*-

import webapp2
import logging
import json

class BaseHandler(webapp2.RequestHandler):

	DefaultLocalization = "en-gb"
	LocaleList = ["en-gb", "ja-jp", "ko-kr", "zh-cn", "zh-tw"]

	def GetLocale(self, locale): 
		if locale:
			locale = locale.lower()
		if locale[-1:] == "/":
			locale = locale[0:-1]    
		if not locale in self.LocaleList:
			locale = self.DefaultLocalization
		return locale

	def JSONResponse(self, data, http=200):
		self.response.set_status(http)
		self.response.headers['Content-Type'] = "application/json"
		self.response.headers['Rate-Limit'] = str(5000)
		self.response.headers['Rate-Limit-Remaining'] = str(4998)
		self.response.out.write(json.dumps(data))
