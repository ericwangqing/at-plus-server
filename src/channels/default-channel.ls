debug = require('debug')('at-plus')
require! ['./channel-initial-helper', './session-store']
module.exports = 
  init: !(io)->
    channel-initial-helper.server-channel-initial-wrapper {
      channel: io

      session-socket-handler: !(socket, data, callback)->
        socket.number = socket.number or Math.random!

        if data and  data.sid
          session-store.restore socket.id, data.sid, !(found-session)->
            socket.session = found-session
            callback!
        else
          socket.session.message = socket.session.message or Math.random!
          callback!

      response-initial-data-getter: !(socket, data, callback)->
        callback err = null, {
          sid: socket.session.sid or socket.id
          number: socket.number
          message: socket.session.message
        }

      business-handlers: !(socket, data, callback)->
        for-session-testing socket, callback
    }

for-session-testing = !(socket, callback)->  # these handler are used in session-testing, and should be removed in future
  try-socket-data socket, callback
    # socket.emit 'a default message', {everyone: 'in', '/': 'will get'}

try-socket-data = !(socket, callback)->
  socket.on 'request-1', !(data)->
    socket.emit 'request-1-answer', number: socket.number
  callback!

