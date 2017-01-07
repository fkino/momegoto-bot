APP_NAME = "momegoto-bot"

monitor = (brain, msg) ->
  users = brain.get(APP_NAME)
  users = new Object() unless users?
  if users[msg.message.user.name]?
    count = users[msg.message.user.name]
  else
    count = 0
  users[msg.message.user.name] = ++count
  brain.set(APP_NAME, users)
  msg.send msg.message.user.name + " : " + count

isDispute = ->
  true

module.exports = (robot) ->
  robot.hear /.*/, (msg) ->
    monitor(robot.brain, msg)
    msg.send "揉め事かァ？" if isDispute

