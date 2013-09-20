# 文档和协议设计见：http://my.ss.sysu.edu.cn/wiki/display/AFWD/Locations+Channel+Protocol

require! ['./locations-manager', './messages-manager', './users-manager', './interesting-points-manager', './channel-initial-wrapper', './config']
_ = require 'underscore'
event-bus = require './event-bus'


request-initial-handler = !(socket, data, callback)->
  fake-set-uid socket, data # ！！！注意，这里仅仅为了测试，在正式代码里要去掉
  (locations-data, inexistence-locations-urls) <-! prepare-location-data-for-initializing-client data.locations, socket.session.uid
  join-locations-rooms socket, locations-data.locations
  join-inexsitence-locations-rooms socket, inexistence-locations-urls # 一旦对应url有兴趣点创建（形成location），就能够收到消息
  callback locations-data

prepare-location-data-for-initializing-client = !(locations, current-uid, callback)->
  (resolved-locations, inexistence-locations-urls) <-! locations-manager.resolve-locations locations
  (interesting-points-summaries-map) <-! interesting-points-manager.get-interesting-points-summaries-map [location._id for location in resolved-locations]
  uids = _.uniq get-users-attending-interesting-points interesting-points-summaries-map
  (brief-users-map) <-! users-manager.get-brief-users-map uids, current-uid

  ipids = _.uniq get-interesting-points-ids interesting-points-summaries-map
  (recent-messages-map) <-! messages-manager.get-recent-messages-map ipids 

  locations-data = get-response-initial-data resolved-locations, interesting-points-summaries-map, brief-users-map, recent-messages-map
  callback locations-data, inexistence-locations-urls

fake-set-uid = !(socket, data)->
  socket.session.uid = data.uid if data.uid


get-users-attending-interesting-points = (interesting-points-summaries-map)->
  uids = []
  interesting-points-manager.visit-uids-of-interesting-points-summaries-map interesting-points-summaries-map, (value, attr)->
    uids.push value[attr]
  uids

get-interesting-points-ids = (interesting-points-summaries-map)->
  _.reduce (_.values interesting-points-summaries-map), (ipids, ips_array)->
    ipids.concat _.pluck ips_array, '_id'
  , []

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

get-response-initial-data = (locations, interesting-points-summaries-map, brief-users-map, recent-messages-map)->
  replace-uids-with-brief-users interesting-points-summaries-map, brief-users-map
  locations.for-each !(location)->
    location.interesting-points-summaries = interesting-points-summaries-map[location._id] 
    # debug "location.interesting-points-summaries: ", location.interesting-points-summaries
    for ips in location.interesting-points-summaries
      ips.recent-messages = recent-messages-map[ips._id]
      # debug "ips: ", ips
      # debug "ips.recent-messages: ", ips.recent-messages
    # location.interesting-points-summaries[0].commented-by = _.compact location.interesting-points-summaries[0].commented-by
  locations: locations

replace-uids-with-brief-users = !(interesting-points-summaries-map, brief-users-map)->
  interesting-points-manager.visit-uids-of-interesting-points-summaries-map interesting-points-summaries-map, (value, attr)->
    value[attr] = brief-users-map[value[attr]]

change-url-room-to-location-room = !(location-channel, url, location)->
  debug "------ in: 'change-url-room-to-location-room' ---------"
  for client in location-channel.clients url
    client.leave get-room url
    client.join location._id


module.exports  = 
  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of('/locations')

      response-initial-handler: request-initial-handler

      business-handlers-register: !(socket, data, callback)->
        # ----- 以下响应来自客户端的请求 ---------------- #
        socket.on 'request-update-location', !(data)->
          <-! locations-manager.update-location data.lid, data.update
          socket.broadcast.to(data.lid).emit 'response-update-location', data
          # debug 'response-update-location emitted at: ', data.lid

        socket.on 'answer-location-internality', !(data)->
          debug "------ in: 'answer-location-internality' ---------"
          if (data.is-internal)
            locations-manager.update-location-internality data.lid, true

        # ----- 以下响应服务端business层的请求 ---------------- #
        event-bus.on 'locations-channel:ask-location-internality', !(data)->
          debug "------ in: 'locations-channel:ask-location-internality' ---------"
          debug "------ emit: 'ask-location-internality' ---------"
          socket.emit 'ask-location-internality', data


        event-bus.on 'locations-channel:location-updated', !(data)~>
          debug "------ in: 'locations-channel:location-updated' ---------"
          change-url-room-to-location-room @channel, data.url, data.location
          debug "------ broadcast: 'push-location-updated' ---------"
          socket.broadcast.to(data.location.lid).emit 'push-location-updated', data.ip-summary

        # socket.on 'leave-location'

        callback!
        
    }

