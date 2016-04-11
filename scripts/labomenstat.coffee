# Description:
#   Manage attendance status of labomen
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot (Message contains <登校, 登山, 出席, 出勤>) - Change status to login
#   hubot (Message contains <下校, 下山, 退席, 退勤, 外出, 帰宅>) - Change status to logout
#   hubot labomen list - Show all labomen's status
#   hubot labomen reset - Reset status table
#
# Author:
#   Trileg

class Labomen
  constructor: (@robot) ->
    @cache = {}
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.labomen
        @cache = @robot.brain.data.labomen
  login: (sender) ->
    @cache[sender] = "login"
    @robot.brain.data.labomen = @cache
    @robot.brain.save()
    return
  logout: (sender) ->
    @cache[sender] = "logout"
    @robot.brain.data.labomen = @cache
    @robot.brain.save()
    return
  list: ->
    @cache
  reset: ->
    @cache = {}
    @robot.brain.data.labomen = @cache
    @robot.brain.save()
    return

module.exports = (robot) ->
  labomen = new Labomen robot

  robot.respond /.*(登校|登山|出席|出勤).*/i, (msg) ->
    labomen.login msg.message.user.name

  robot.respond /.*(下校|下山|退席|退勤|外出|帰宅).*/i, (msg) ->
    labomen.logout msg.message.user.name

  robot.respond /labomen list/i, (msg) ->
    response = ""
    for user, status of labomen.list()
      response += "#{user}: #{status}\n"
    msg.send response

  robot.respond /labomen reset/i, (msg) ->
    labomen.reset()
