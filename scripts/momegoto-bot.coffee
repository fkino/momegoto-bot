APP_NAME = "momegoto-bot"
MESSAGE_COUNT = 10
USER_COUNT = 2
INTERVAL_SEC = 180
MEDIATION_MESSAGE = "揉め事かァ？ハグアウトする？"

cleanup = (messages, date) ->
  for user, times of messages
    if ((date - times[times.length - 1]) / 1000) >= INTERVAL_SEC
      delete messages[user]
      continue
    for time, i in times
      if ((date - time) / 1000) < INTERVAL_SEC
        times.splice(0, i)
        break
  messages

monitor = (brain, msg) ->
  messages = brain.get(APP_NAME)
  messages = {} unless messages?
  messages[msg.message.user.name] = [] unless messages[msg.message.user.name]?
  messages[msg.message.user.name].push(date = new Date)
  messages = cleanup(messages, date)
  brain.set(APP_NAME, messages)
  messages

reset = (brain) ->
  brain.set(APP_NAME, {})

isDispute = (messages) ->
  count = 0
  for user, times of messages
    count++ if times.length >= MESSAGE_COUNT
  count >= USER_COUNT

module.exports = (robot) ->
  robot.respond /debug/i, (msg) ->
    msg.send JSON.stringify(robot.brain.get(APP_NAME))
    msg.finish()

  robot.hear /.*/, (msg) ->
    messages = monitor(robot.brain, msg)
    if isDispute(messages)
      msg.send MEDIATION_MESSAGE
      reset(robot.brain)

