debug = require('debug')('at-plus')
require! ['./channel-initial-wrapper', './session-store']
module.exports = 
  init: !(io, db)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io

      request-initial-handler: !(socket, data, callback)->

        if data and  data.sid
          session-store.restore socket.id, data.sid, !(found-session)->
            socket.session = found-session
            callback!
        else
          callback!

      response-initial-handler: !(socket, data, callback)->
        # socket.session.message = 'hello'
        callback err = null, {
          sid: socket.id
          message: socket.session.message or 'hello'
        }

      business-handlers-register: !(socket, data, callback)->
        socket.on 'change-session-request', !(data, save-session)->
          socket.session.message = 'world'
          save-session!
          socket.emit 'change-session-response', null
        callback err = null, {
        }
    }


