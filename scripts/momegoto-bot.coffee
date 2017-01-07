APP_NAME = "momegoto-bot"

monitor = (brain, msg) ->
  obj = brain.get(APP_NAME)
  obj = new Object() unless obj?
  if obj[msg.message.user.name]?
    count = obj[msg.message.user.name]
  else
    count = 0
  obj[msg.message.user.name] = ++count
  brain.set(APP_NAME, obj)
  msg.send msg.message.user.name + " : " + count

isDispute = ->
  true

module.exports = (robot) ->
  robot.hear /.*/, (msg) ->
    monitor(robot.brain, msg)
    msg.send "揉め事かァ？" if isDispute

