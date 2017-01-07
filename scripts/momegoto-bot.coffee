isDispute = ->
  true

module.exports = (robot) ->
  robot.hear /.*/, (msg) ->
    msg.send "揉め事かァ？" if isDispute

