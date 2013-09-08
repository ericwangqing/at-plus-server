require! ['./locations-manager', './channel-initial-helper']
debug = require('debug')('at-plus')

module.exports  = 
  init: !(io)->
    channel-initial-helper.server-channel-initial-wrapper {
      channel: io.of('/locations')

      request-initial-handler: !(socket, data, callback)->
        callback!

      response-initial-handler: !(socket, data, callback)->
        debug 'location channel handler response-initial'
        callback err = null, {
        }

      business-handlers-register: !(socket, data, callback)->
        callback err = null, {
        }
        
    }