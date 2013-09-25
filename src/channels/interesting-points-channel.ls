# 文档和协议设计见：http://my.ss.sysu.edu.cn/wiki/display/AFWD/Locations+Channel+Protocol

require! [ './config', './channel-initial-wrapper', './locations-manager', './users-manager', './interesting-points-manager']
_ = require 'underscore'
event-bus = require './event-bus'

replace-user-id-with-breif-user = !(obj, uid-attr-name, callback)->
  (user) <-! users-manager.create-brief-user-from-uid obj[uid-attr-name]
  obj[uid-attr-name] = user
  callback!

get-push-ip-updated-message = (data)->
  type: "new-msg-added"
  _id: data._id
  added-msg: data.message


module.exports  = 
  init: !(io)->
    # ------------------- 以下响应服务端business层的请求----------------#
    event-bus.on 'interesting-points-channel:ip-updated', !(data)~>
      if io.sockets.sockets[data.session-id]
        debug "-------in: 'interesting-points-channel: ip-updated' ------socket:", io.sockets.sockets[data.session-id].id
        debug "------------broadcase: 'push-ip-updated'"
        io.of('/interesting-points').sockets[data.session-id].broadcast.to(data._id).emit 'push-ip-updated', get-push-ip-updated-message data

    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of('/interesting-points')

      business-handlers-register: !(socket, data, callback)->
        
        # ----- 以下响应来自客户端的请求 ---------------- #
        socket.on 'request-create-a-new-ip-on-a-new-url', !(data)->
          debug "------ in: 'request-create-a-new-ip-on-a-new-url', socket.id: ---------", socket.id
          (location) <-! locations-manager.create-or-update-a-location socket.id, 
            url: data.within-location.url
            name: data.within-location.name
          (interesting-point-summary) <-! interesting-points-manager.create-interesting-point location, data
          <-! replace-user-id-with-breif-user interesting-point-summary, 'createdBy'
          debug "------ emit: 'response-create-a-new-ip-on-a-new-url' ---------"
          socket.emit 'response-create-a-new-ip-on-a-new-url', 
            result: 'success'
            lid: location._id
            ipid: interesting-point-summary._id
          locations-manager.update-location-with-ip socket.id, data.within-location.url, location, interesting-point-summary

        socket.on 'request-send-a-new-message-on-an-ip', !(data)->
          (location) <-! locations-manager.create-or-update-a-location socket.id,
            url: data.within-location.url
            name: data.within-location.name
          (result) <-! interesting-points-manager.send-message location, data
          socket.emit 'response-send-a-new-message-on-an-ip', result
          interesting-points-manager.update-ip-with-msg socket.id, data.within-location.urls, data
        callback!
        
    }

