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

class Nextbus
  next: (word) ->
    options =
      url: baseurl + word
      json: true

    request.get options, (err, res, body) ->
      return err if err
      return body.Error if res == 400
      destination = ''
      if word == 'to-takatsuki'
        destination = '高槻'
      else if word == 'to-tonda'
        destination = '富田'
      else
        destination = '関大'
      response = '次の'+destination+'行きバスは，'+body.Hour+':'+body.Minute+'です'
      response

module.exports = (robot) ->
  nextbus = new Nextbus

  robot.respond /.*(高槻へ).*/i, (msg) ->
    response =  nextbus.next 'to-takatsuki'
    msg.send response

  robot.respond /.*(富田へ).*/i, (msg) ->
    response =  nextbus.next 'to-tonda'
    msg.send response

  robot.respond /.*(高槻から).*/i, (msg) ->
    response =  nextbus.next 'from-takatsuki'
    msg.send response

  robot.respond /.*(富田から).*/i, (msg) ->
    response =  nextbus.next 'from-tonda'
    msg.send response
