APP_NAME = "momegoto-bot"
MESSAGE_COUNT = 10
USER_COUNT = 2
INTERVAL_SEC = 180
MEDIATION_MESSAGE = "揉め事かァ？ハグアウトする？"

cleanup = (users, date) ->
  for user, times of users
    if ((date - times[times.length - 1]) / 1000) >= INTERVAL_SEC
      delete users[user]
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

reset = (brain) ->
  brain.set(APP_NAME, {})

isDispute = (users) ->
  count = 0
  for user, times of users
    count++ if times.length >= MESSAGE_COUNT
  true if count >= USER_COUNT

module.exports = (robot) ->
  robot.respond /debug/i, (msg) ->
    cleanup(robot.brain.get(APP_NAME), new Date)
    msg.send JSON.stringify(robot.brain.get(APP_NAME))
    msg.finish()

  robot.hear /.*/, (msg) ->
    users = monitor(robot.brain, msg)
    if isDispute(users)
      msg.send MEDIATION_MESSAGE
      reset(robot.brain)

