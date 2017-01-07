APP_NAME = "momegoto-bot"

monitor = (brain, msg) ->
  users = brain.get(APP_NAME)
  users = {} unless users?
  users[msg.message.user.name] = [] unless users[msg.message.user.name]?
  users[msg.message.user.name].push(new Date)
  brain.set(APP_NAME, users)
  msg.send msg.message.user.name + " : " + users[msg.message.user.name]

isDispute = ->
  true

module.exports = (robot) ->
  robot.hear /.*/, (msg) ->
    monitor(robot.brain, msg)
    msg.send "揉め事かァ？" if isDispute

