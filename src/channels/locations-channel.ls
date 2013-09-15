require! ['./locations-manager', './channel-initial-wrapper', './config']


request-initial-handler = !(socket, data, callback)->
  (resolved-locations, inexistence-locations-urls) <-! locations-manager.resolve-locations data.locations
  join-locations-rooms socket, resolved-locations
  join-inexsitence-locations-rooms socket, inexistence-locations-urls # 一旦对应url有兴趣点创建（形成location），就能够收到消息
  callback err = null, locations: resolved-locations

join-locations-rooms = !(socket, locations)->
  for location in locations
    socket.join location._id
    debug "socket: #{socket.id} join #{location._id}"

join-inexsitence-locations-rooms =!(socket, inexistence-locations-urls)->
  for url in inexistence-locations-urls
    socket.join room = config.locations-channel.inexistence-prefix + url
    debug "socket: #{socket.id} join #{room}"


module.exports  = 
  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of('/locations')

      request-initial-handler: !(socket, data, callback)->
        callback!

      response-initial-handler: request-initial-handler

      business-handlers-register: !(socket, data, callback)->
        callback err = null, {
        }
        
    }
