describe '测试在新URL上创建新兴趣点时，Locations Channel与Interesting Points Channel的协同', !->
  describe '创建的整个流程，有按照http://my.ss.sysu.edu.cn/wiki/pages/viewpage.action?pageId=221184007的设计进行', !->
    can '提交创建请求后，按照设计，服务端各模块执行了流程', !(done)->
      debug '''
      ************ 请注意，本测例需要人工观察，判断是否正确 **************
      注意：服务端应该依http://my.ss.sysu.edu.cn/wiki/pages/viewpage.action?pageId=221184007次输出各步骤的执行
      '''
      open-at-plus-on-default-locations-and-interesting-points-channels !(locations-channel, ip-channel, data)->
        locations-channel.on 'ask-location-internality', !(data)->
          debug "@+ Client: ======== locations-channel in 'ask-location-internality' =========="
          debug "@+ Client: ======== locations-channel emit 'answer-location-internality' =========="
          locations-channel.emit 'answer-location-internality', is-internal: fake-figure-out-location-internality data.url, data.server-retrieved-html

        locations-channel.on 'push-location-updated', !(data)->
          debug "@+ Client: ======== in 'push-location-updated' =========="


        ip-channel.on 'response-create-a-new-ip-on-a-new-url', !(data)->
          debug "@+ Client: ======== ip-channel in 'response-create-a-new-ip-on-a-new-url' =========="
          set-timeout (!-> done!), 500 # 等待所有通信完成。
        debug "@+ Client: ======== ip-channel emit 'request-create-a-new-ip-on-a-new-url' =========="
        ip-channel.emit 'request-create-a-new-ip-on-a-new-url'



  before-each !(done)->
    <-! server.start
    (require 'socket.io-client/lib/io.js').sockets = {} # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    utils.prepare-clean-test-db done
    debug 'prepare-clean-test-db complete'

  after-each !(done)->
    utils.close-db !->
      utils.Sockets-distroyer.get!.destroy-all!
      server.shutdown!
      done!

# ---------------------- 美丽的分割线，以下辅助代码 ----------------------- #
default-channel-url = base-url
locations-channel-url = base-url + "/locations"
interesting-points-channel-url = base-url + "/interesting-points"
no-new-connection-options = {'force new connection': false}

open-at-plus-on-default-locations-and-interesting-points-channels = !(callback)->
  request-server {url: default-channel-url, options: no-new-connection-options}
  ,
  !(socket, initial-data)->
    request-server {url: locations-channel-url, options: no-new-connection-options}
    ,
    !(socket, initial-data)->
      locations-channel = socket
      request-server {url: interesting-points-channel-url, options: no-new-connection-options}
      ,
      !(socket, initial-data)->
        interesting-points-channel = socket
        utils.Sockets-distroyer.get!.add-socket socket # 为了在每个测试结束，关闭服务端的socket，以便隔离各个测例。
        callback locations-channel, interesting-points-channel, initial-data

fake-figure-out-location-internality = (url, server-retrieved-html)->
  # debug ' .... 真实的client会在这里将server-retrieved-html和自己打开的location（url）中的源码进行比较，确定是否一致。一致则是not internal，否则是internal ...'
  true # 测试用true，激发服务器响应行为
