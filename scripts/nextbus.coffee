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
      return body.Error if res.statusCode == 400
      response = '次の高槻行きバスは，'+body.Hour+':'+body.Minute+'です'
      msg.send response

  robot.respond /.*(富田へ).*/i, (msg) ->
    options =
      url: baseurl + 'to-tonda'
      json: true
    request.get options, (err, res, body) ->
      return err if err
      return body.Error if res.statusCode == 400
      response = '次の富田行きバスは，'+body.Hour+':'+body.Minute+'です'
      msg.send response

  robot.respond /.*(高槻から).*/i, (msg) ->
    options =
      url: baseurl + 'from-takatsuki'
      json: true
    request.get options, (err, res, body) ->
      return err if err
      return body.Error if res.statusCode == 400
      response = '次の関大行きバスは，'+body.Hour+':'+body.Minute+'です'
      msg.send response

  robot.respond /.*(富田から).*/i, (msg) ->
    options =
      url: baseurl + 'from-tonda'
      json: true
    request.get options, (err, res, body) ->
      return err if err
      return body.Error if res.statusCode == 400
      response = '次の関大行きバスは，'+body.Hour+':'+body.Minute+'です'
      msg.send response

  robot.hear /^\s*bus\s*(?:(f(?:r|ro|rom)?|to?)\s*((?:to(?:n|nd|nda)?)|(?:ta(?:k|ka|kat|kats|katsu|katsuk|katsuki)?))?)?\s*$/i, (msg) ->
    if msg.match[1]
      direction = if msg.match[1].substr(0) == "t" then "to" else "from"
      if msg.match[2]
        [place, place_ja] = if msg.match[2].substr(0, 2) == "to" then ["tonda", "富田"] else ["takatsuki", "高槻"]
        place_ja = if direction == "from" then "関大" else place_ja
        options =
          url: baseurl + direction + '-' + place
          json: true
        request.get options, (err, res, body) ->
          return err if err
          return body.Error if res == 400
          response = '次の'+place_ja+'行きバスは，'+body.Hour+':'+body.Minute+'です'
          msg.send response
      else
        msg.send "This function does not work yet."
    else
      msg.send "This function does not work yet."
