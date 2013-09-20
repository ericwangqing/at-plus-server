# 文档和协议设计见：http://my.ss.sysu.edu.cn/wiki/display/AFWD/Locations+Channel+Protocol

require! [ './config', './channel-initial-wrapper']
_ = require 'underscore'
business = require './event-bus'

module.exports  = 
  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of('/interesting-points')

      business-handlers-register: !(socket, data, callback)->
        # ----- 以下响应来自客户端的请求 ---------------- #
        socket.on 'request-create-a-new-ip-on-a-new-url', !(data)->
          socket.emit 'response-create-a-new-ip-on-a-new-url'

        callback!
        
    }

