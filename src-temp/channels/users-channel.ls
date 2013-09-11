debug = require('debug')('at-plus')
require! ['./event-bus', './channel-initial-wrapper']
module.exports = 
  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of '/users'

      business-handlers-register: !(socket, data, callback)->
        event-bus.on 'user-create-interesting-point-comment', !(data)->
          socket.emit 'response-user-create-interesting-point-comment', data
        callback err = null, {}
    }
