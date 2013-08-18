locations-manager = 
  init: (io, callback)->
    (socket) <-! io.sockets.on 'connection'
    console.log arguments.callee.caller.name, ": connected"
    socket.emit 'ask-location', {web-url: null, world-position: null}
    (data) <-! socket.on 'answer-location'
    console.log data
    socket.emit 'at-plus-server-ready', {}
    callback data

module.exports <<< locations-manager
