debug = require('debug')('at-plus')
require! ['./channel-initial-helper', './session-store']
module.exports = 
  init: !(io)->
    channel-initial-helper.server-channel-initial-wrapper {
      channel: io

      request-initial-handler: !(socket, data, callback)->

        if data and  data.sid
          session-store.restore socket.id, data.sid, !(found-session)->
            socket.session = found-session
            callback!
        else
          callback!

      response-initial-handler: !(socket, data, callback)->
        callback err = null, {
        }

      business-handlers-register: !(socket, data, callback)->
        callback err = null, {
        }
    }


