# 文档和协议设计见：http://my.ss.sysu.edu.cn/wiki/display/AFWD/Locations+Channel+Protocol

require! ['./locations-manager', './users-manager', './interesting-points-manager', './channel-initial-wrapper', './config']
_ = require 'underscore'
business = require './event-bus'


request-initial-handler = !(socket, data, callback)->
  socket.session.uid = data.uid if data.uid # ！！！注意，这里仅仅为了测试，在正式代码里要去掉
  (resolved-locations, inexistence-locations-urls) <-! locations-manager.resolve-locations data.locations
  (interesting-points-summaries) <-! interesting-points-manager.get-interesting-points-summaries [location._id for location in resolved-locations]
  uids = _.uniq get-users-attending-interesting-points interesting-points-summaries
  (brief-users-map) <-! users-manager.get-brief-users-map uids, socket.session.uid
  join-locations-rooms socket, resolved-locations
  join-inexsitence-locations-rooms socket, inexistence-locations-urls # 一旦对应url有兴趣点创建（形成location），就能够收到消息
  callback get-response-initial-data resolved-locations, interesting-points-summaries, brief-users-map

get-users-attending-interesting-points = (interesting-points-summaries)->
  uids = []
  interesting-points-manager.visit-uids-of-interesting-points-summaries interesting-points-summaries, (value, attr)->
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
  replace-uids-with-brief-users-map interesting-points-summaries, brief-users-map
  locations.for-each !(location)->
    location.interesting-points-summaries = interesting-points-summaries[location._id] 
    # location.interesting-points-summaries[0].commented-by = _.compact location.interesting-points-summaries[0].commented-by
  locations: locations


replace-uids-with-brief-users-map = !(interesting-points-summaries, brief-users-map)->
  interesting-points-manager.visit-uids-of-interesting-points-summaries interesting-points-summaries, (value, attr)->
    value[attr] = brief-users-map[value[attr]]


  # for ips-array in _.values interesting-points-summaries
  #   for ips in ips-array
  #     replace-uid-in-attribute ips, ['createdBy', 'commentedBy', 'sharedWith', 'watchedBy'], brief-users-map

  # replace-uid-in-attribute = !(ips, attributes, brief-users-map)->
  #   for attr in attributes
  #     if value = ips[attr]
  #       if _.is-array value
  #         for uid, i in value
  #           value[i] = brief-users-map[uid]

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

