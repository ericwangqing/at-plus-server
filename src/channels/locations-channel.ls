require! ['./locations-manager', './channel-initial-helper']
debug = require('debug')('at-plus')

request-initial-handler = !(socket, data, callback)->
  (resolved-locations) <-! locations-manager.resolve-locations data.locations
  callback err = null, locations: resolved-locations

module.exports  = 
  init: !(io)->
    channel-initial-helper.server-channel-initial-wrapper {
      channel: io.of('/locations')

      request-initial-handler: !(socket, data, callback)->
        callback!

      response-initial-handler: request-initial-handler

      business-handlers-register: !(socket, data, callback)->
        callback err = null, {
        }
        
    }
