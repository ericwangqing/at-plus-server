# 文档和协议设计见：http://my.ss.sysu.edu.cn/wiki/display/AFWD/Locations+Channel+Protocol

require! ['./locations-manager', './users-manager', './interesting-points-manager', './channel-initial-wrapper', './config']
_ = require 'underscore'
business = require './event-bus'


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
  locations-data = get-response-initial-data resolved-locations, interesting-points-summaries-map, brief-users-map
  callback locations-data, inexistence-locations-urls

fake-set-uid = !(socket, data)->
  socket.session.uid = data.uid if data.uid


get-users-attending-interesting-points = (interesting-points-summaries-map)->
  uids = []
  interesting-points-manager.visit-uids-of-interesting-points-summaries-map interesting-points-summaries-map, (value, attr)->
    uids.push value[attr]
  uids

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

get-response-initial-data = (locations, interesting-points-summaries, brief-users-map)->
  replace-uids-with-brief-users interesting-points-summaries, brief-users-map
  locations.for-each !(location)->
    location.interesting-points-summaries = interesting-points-summaries[location._id] 
    # location.interesting-points-summaries[0].commented-by = _.compact location.interesting-points-summaries[0].commented-by
  locations: locations

replace-uids-with-brief-users = !(interesting-points-summaries, brief-users-map)->
  interesting-points-manager.visit-uids-of-interesting-points-summaries-map interesting-points-summaries, (value, attr)->
    value[attr] = brief-users-map[value[attr]]


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

        # socket.on 'leave-location'

        callback!
        
    }

