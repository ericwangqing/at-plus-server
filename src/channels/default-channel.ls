debug = require('debug')('at-plus')
require! ['./channel-initial-helper', './session-store']
module.exports = 
  init: !(io)->
    channel-initial-helper.server-channel-initial-wrapper {
      channel: io

      session-socket-handler: !(socket, data, callback)->

        if data and  data.sid
          session-store.restore socket.id, data.sid, !(found-session)->
            socket.session = found-session
            callback!
        else
          callback!

      response-initial-data-getter: !(socket, data, callback)->
        callback err = null, {
        }

      business-handlers: !(socket, data, callback)->
    }


