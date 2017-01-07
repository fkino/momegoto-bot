APP_NAME = "momegoto-bot"
MESSAGE_COUNT = 10
INTERVAL_SEC = 5

cleanup = (users, date) ->
  for user, times of users
    if ((date - times[times.length - 1]) / 1000) >= INTERVAL_SEC
      continue
    for time, i in times
      if ((date - time) / 1000) < INTERVAL_SEC
        times.splice(0, i)
        break
  users

monitor = (brain, msg) ->
  users = brain.get(APP_NAME)
  users = {} unless users?
  users[msg.message.user.name] = [] unless users[msg.message.user.name]?
  users[msg.message.user.name].push(date = new Date)
  users = cleanup(users, date)
  brain.set(APP_NAME, users)
  users

clear = (brain) ->
  brain.set(APP_NAME, {})

isDispute = (users) ->
  count = 0
  for user, times of users
    count++ if times.length >= MESSAGE_COUNT
  true if count >= 1

module.exports = (robot) ->
  robot.hear /.*/, (msg) ->
    users = monitor(robot.brain, msg)
    if isDispute(users)
      msg.send "揉め事かァ？"
      clear(robot.brain)

  robot.respond /debug/i, (msg) ->
    msg.send JSON.stringify(robot.brain.get(APP_NAME))

