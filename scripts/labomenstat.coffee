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
#   hubot labomen add - Add you to this system
#   hubot (Message contains <登校, 登山, 出席, 出勤>) - Change status to login
#   hubot (Message contains <下校, 下山, 退席, 退勤, 外出, 帰宅>) - Change status to logout
#   hubot labomen list - Show all labomen's status
#
# Author:
#   Trileg

class Labomen
  constructor: (@robot) ->
    @cache = {}
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.labomen
        @cache = @robot.brain.data.labomen
  add: (sender) ->
    if sender of @cache == false
      @cache[sender] = "logout"
      @robot.brain.data.labomen = @cache
      return
    else
      return
  login: (sender) ->
    if sender of @cache == true
      @cache[sender] = "login"
      @robot.brain.data.labomen = @cache
      return
    else
      return
  logout: (sender) ->
    if sender of @cache == true
      @cache[sender] = "logout"
      @robot.brain.data.labomen = @cache
      return
    else
      return
  list: ->
    @cache

module.exports = (robot) ->
  labomen = new Labomen robot

  robot.respond /labomen add/i, (msg) ->
    labomen.add msg.message.user.name

  robot.respond /.*(登校|登山|出席|出勤).*/i, (msg) ->
    labomen.login msg.message.user.name

  robot.respond /.*(下校|下山|退席|退勤|外出|帰宅).*/i, (msg) ->
    labomen.logout msg.message.user.name

  robot.respond /labomen list/i, (msg) ->
    response = ""
    for user, status of labomen.list()
      response += "#{user}: #{status}\n"
    msg.send response
