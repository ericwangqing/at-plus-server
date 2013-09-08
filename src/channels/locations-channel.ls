require! ['./interesting-points-manager', './channel-initial-helper']
module.exports  = 
  init: !(io)->
    channel-initial-helper.server-channel-initial-wrapper {
      channel: io.of('/locations')

      session-socket-handler: !(socket, data, callback)->
        callback!

      response-initial-data-getter: !(socket, data, callback)->
        callback err = null, {
        }

      business-handlers: !(socket, data, callback)->
        
    }