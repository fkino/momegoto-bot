module.exports = (robot) ->
  robot.hear /HELLO$/i, (msg) ->
    msg.send "hello!"

