require! ['./locations-manager', './channel-initial-wrapper', './config']
business = require './event-bus'


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
    socket.join get-room url
    debug "socket: #{socket.id} join #{room}"

get-room = (inexistence-location-url)->
  # add prefix to url for distinguishing from location id
  config.locations-channel.inexistence-prefix + inexistence-location-url

module.exports  = 
  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of('/locations')

      request-initial-handler: !(socket, data, callback)->
        callback!

      response-initial-handler: request-initial-handler

      business-handlers-register: !(socket, data, callback)->
        # ----- 以下响应来自客户端的请求 ---------------- #
        socket.on 'request-update-location', !(data)->
          <-! locations-manager.update-location data.lid, data.update
          socket.broadcast.to(data.lid).emit 'response-update-location', data
          # debug 'response-update-location emitted at: ', data.lid

        # ----- 以下响应来自business层的请求 ---------------- #

        # 通常'ask-resolving-new-location-interanl-or-not'消息发生的情况如下：
        # 1）用户在还没有兴趣点的location上创建兴趣点，发出了request-new-interesting-point消息，到interesting-points频道
        # 2）interesting-points频道先使用location-manager创建新的location，location-manager发出此消息，
        #    'ask-resolving-new-location-interanl-or-not'后，先创建location，并将location id给回interesting-points频道
        #    interesting-points频道再调用interesting-points-manager创建interesting-points，
        #    interesting-points-manager创建完成之后，向本频道报告'location-updated'
        #    本频道emit response-update-location
        # 3) 本频道会发出'are-internal-locations'消息，询问用户是否为internal
        # 4）根据用户答复（'report-internal-or-not'）创建location
        # 5）调用location-manager，find-alia-urls，查找同名urls
        # business.on 'ask-resolving-new-location-interanl-or-not', !(data)-> 
        #   (cid, alia-urls) <-! locations-manager.create-location data.url
        #   for url in alia-urls.concat [data.url]
        #     socket.broadcast.to(get-room url).emit 'response-update-location', data
        #   callback



          


        callback err = null, {
        }
        
    }

