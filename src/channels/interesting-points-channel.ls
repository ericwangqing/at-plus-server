# 文档和协议设计见：http://my.ss.sysu.edu.cn/wiki/display/AFWD/Locations+Channel+Protocol

require! [ './config', './channel-initial-wrapper', './locations-manager', './interesting-points-manager']
_ = require 'underscore'
event-bus = require './event-bus'

module.exports  = 
  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of('/interesting-points')

      business-handlers-register: !(socket, data, callback)->
        # ----- 以下响应来自客户端的请求 ---------------- #
        socket.on 'request-create-a-new-ip-on-a-new-url', !(data)->
          debug "------ in: 'request-create-a-new-ip-on-a-new-url' ---------"
          (location) <-! locations-manager.create-or-update-a-location data.url
          (interesting-point) <-! interesting-points-manager.create-interesting-point location._id, data.interesting-point
          debug "------ emit: 'response-create-a-new-ip-on-a-new-url' ---------"
          socket.emit 'response-create-a-new-ip-on-a-new-url', result: 'success'
          locations-manager.update-location-with-ip data.url, location.id, interesting-point

        callback!
        
    }

