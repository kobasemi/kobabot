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

  ##########################################
  # Yet-Another Bus Command a.k.a yabus command
  USAGE_MSG = """
  Usage: bus [COMMAND] [OPTION]...

  Get Time Information of Next Bus

  COMMAND:
    h[elp]                print this help
    f[rom] [PLACE]        get next bus info from the position
    t[o]   [PLACE]        get next bus info to the position

    PLACE:
      to[nda]             Tonda / 富田
      ta[katsuki]         Takatsuki / 高槻

  OPTION:
    c[ounts]   NUMBER      get next bus info counts times
    ad[ays]    NUMBER      get next bus info after days
    ah[ours]   NUMBER      get next bus info after hours
    am[inutes] NUMBER      get next bus info after minutes

  EXAMPLE:
    bus                   get next bus info from kutc to tonda and takatsuki,
                          from tonda and takatsuki to kutc
    bus f                 get next bus info from tonda and takatsuki to kutc
    bus t to c 10         get next bus info ten times from kutc to tonda
    bus am 30              get next bus info after 30 minutes
  """

  place_ja =
    kutc     : "関大"
    takatsuki: "高槻"
    tonda    : "富田"

  robot.hear /\s*(?:bus|バス|:bus:)(\s+.*)?\s*$/i, (msg) ->
    Util = require "util"

    request_query = {queries: [
      {from: "kutc"     , to: "takatsuki", counts: 3}
      {from: "takatsuki", to: "kutc"     , counts: 3}
      {from: "kutc"     , to: "tonda"    , counts: 3}
      {from: "tonda"    , to: "kutc"     , counts: 3}
    ]}

    # Below pattern: (f[rom]|t[o]) (to[nda]|ta[katsuki]) (...)
    parser_re = /^\s*(?:(f(?:r|ro|rom)?|to?|h(?:e|el|elp)?)(?:\s+((?:to(?:n|nd|nda)?)|(?:ta(?:k|ka|kat|kats|katsu|katsuk|katsuki)?)))?)?(?:\s+(.*))?$/
    cmds = parser_re.exec(msg.match[1])

    if cmds
      if cmds[1]
        if cmds[1][0] == "h"
          msg.send USAGE_MSG
          return
        direction = if cmds[1][0] == "f" then "from" else "to"
        request_query.queries = request_query.queries.filter((x) -> x[direction] != "kutc")

      if cmds[2]
        place = if cmds[2].substr(0, 2) == "to" then "tonda" else "takatsuki"
        request_query.queries = request_query.queries.filter((x) -> (true for k, v of x when v == place)[0])

      if cmds[3]
        opts = cmds[3].replace(/\s+/g, " ").split(" ")

    if opts
      # Options Parser
      i = 0
      while i < opts.length
        switch true
          # captured c(ounts) NUMBER
          when /^c(?:o|ou|oun|ount|ounts)?$/.test(opts[i])
            request_query.queries.map((x) -> x.counts = parseInt(opts[i+1], 10))
            i += 1
          # captured cNUMBER
          when /^c(\d+)?$/.test(opts[i])
            request_query.queries.map((x) -> x.counts = parseInt(opts[i].substring(1), 10))
          # captured ad(ays) NUMBER
          when /^ad(?:a|ay|ays)?$/.test(opts[i])
            request_query.queries.map((x) -> x.days = parseInt(opts[i+1], 10))
            i += 1
          # captured adNUMBER
          when /^ad(\d+)?$/.test(opts[i])
            request_query.queries.map((x) -> x.days = parseInt(opts[i].substring(1), 10))
          # captured ah(ours) NUMBER
          when /^ah(?:o|ou|our|ours)?$/.test(opts[i])
            request_query.queries.map((x) -> x.hours = parseInt(opts[i+1], 10))
            i += 1
          # captured ahNUMBER
          when /^ah(\d+)?$/.test(opts[i])
            request_query.queries.map((x) -> x.hours = parseInt(opts[i].substring(1), 10))
          # captured am(inutes) NUMBER
          when /^am(?:i|in|inu|inut|inute|inutes)?$/.test(opts[i])
            request_query.queries.map((x) -> x.minutes = parseInt(opts[i+1], 10))
            i += 1
          # captured amNUMBER
          when /^am(\d+)?$/.test(opts[i])
            request_query.queries.map((x) -> x.minutes = parseInt(opts[i].substring(1), 10))
          else
            msg.send "bus: illegal option -- " + opts[i] + "*"
            msg.send USAGE_MSG
            return
        ++i

    options =
      url: baseurl
      headers: {'Content-Type': 'application/json'}
      body: request_query
      json: true
    request.post options, (err, res, body) ->
      return err if err
      return body.Error if res.statusCode == 400

      msg.send ':bus:'
      for result in body.results
        msg.send place_ja[result.From] + ' -> ' + place_ja[result.To]
        if result.Error
          msg.send 'エラーface_with_rolling_eyes: : ' + result.Error
          continue
        msg.send (bus.Hour + ':' + bus.Minute for bus in result.Buses).join(' | ')
