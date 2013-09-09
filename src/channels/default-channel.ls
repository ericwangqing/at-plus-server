debug = require('debug')('at-plus')
require! ['./channel-initial-helper', './session-store']
module.exports = 
  init: !(io)->
    channel-initial-helper.server-channel-initial-wrapper {
      channel: io

      session-socket-handler: !(socket, data, callback)->
        socket.number = socket.number or Math.random!
        debug 'restoring-session-data: ', data

        if data and data.sid and data.sid is not socket.id
          session-store.restore socket.id, data.sid, !(found-session)->
            debug 'restored-session: ', found-session
            socket.session = found-session
            debug "after restore socket #{socket.id} session: ", socket.session
            callback!
        else
          socket.session.message = socket.session.message or Math.random!
          callback!

      response-initial-data-getter: !(socket, data, callback)->
        debug "before response socket #{socket.id} session: ", socket.session
        callback err = null, {
          sid: socket.session.sid
          message: socket.session.message
          number: socket.number 
        }

      business-handlers: !(socket, data, callback)->  
        for-session-testing socket, callback
    }

for-session-testing = !(socket, callback)->  # these handler are used in session-testing, and should be removed in future
  try-socket-data socket, callback
    # socket.emit 'a default message', {everyone: 'in', '/': 'will get'}

try-socket-data = !(socket, callback)->
  socket.on 'request-1', !(data, done)->
    socket.emit 'request-1-answer', number: socket.number
    done!
  callback!

