# Description:
#   Tell user about next bus time
#
# Dependencies:
#   "request": "^2.72.0"
#   "kanarne/busnoyatsu": "https://github.com/kanarne/busnoyatsu"
#
# Configuration:
#   None
#
# Commands:
#   hubot (Message contain <高槻へ>) - Show next bus time of KUTC -> Takatsuki
#   hubot (Message contain <富田へ>) - Show next bus time of KUTC -> Tonda
#   hubot (Message contain <高槻から>) - Show next bus time of Takatsuki -> KUTC
#   hubot (Message contain <富田から>) - Show next bus time of Tonda -> KUTC
#
# Author:
#   Kensuke Kosaka <kosaka@trileg.net>

request = require 'request'
baseurl = 'https://kutcbus.appspot.com/api/v1/next-bus/'

module.exports = (robot) ->
  robot.respond /.*(高槻へ).*/i, (msg) ->
    options =
      url: baseurl + 'to-takatsuki'
      json: true
    request.get options, (err, res, body) ->
      return err if err
      return body.Error if res == 400
      response = '次の高槻行きバスは，'+body.Hour+':'+body.Minute+'です'
      msg.send response

  robot.respond /.*(富田へ).*/i, (msg) ->
    options =
      url: baseurl + 'to-tonda'
      json: true
    request.get options, (err, res, body) ->
      return err if err
      return body.Error if res == 400
      response = '次の富田行きバスは，'+body.Hour+':'+body.Minute+'です'
      msg.send response

  robot.respond /.*(高槻から).*/i, (msg) ->
    options =
      url: baseurl + 'from-takatsuki'
      json: true
    request.get options, (err, res, body) ->
      return err if err
      return body.Error if res == 400
      response = '次の関大行きバスは，'+body.Hour+':'+body.Minute+'です'
      msg.send response

  robot.respond /.*(富田から).*/i, (msg) ->
    options =
      url: baseurl + 'from-tonda'
      json: true
    request.get options, (err, res, body) ->
      return err if err
      return body.Error if res == 400
      response = '次の関大行きバスは，'+body.Hour+':'+body.Minute+'です'
      msg.send response
