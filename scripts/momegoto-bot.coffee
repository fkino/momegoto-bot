APP_NAME = "momegoto-bot"
MESSAGE_COUNT = 10

monitor = (brain, msg) ->
  users = brain.get(APP_NAME)
  users = {} unless users?
  users[msg.message.user.name] = [] unless users[msg.message.user.name]?
  users[msg.message.user.name].push(new Date)
  brain.set(APP_NAME, users)
  users

isDispute = (users) ->
  count = 0
  for user, times of users
    count++ if times.length >= MESSAGE_COUNT
  true if count >= 1

module.exports = (robot) ->
  robot.hear /.*/, (msg) ->
    users = monitor(robot.brain, msg)
    msg.send "揉め事かァ？" if isDispute(users)

