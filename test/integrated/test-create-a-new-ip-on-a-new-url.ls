describe '测试在新URL上创建新兴趣点时，Locations Channel与Interesting Points Channel的协同', !->
  # describe '创建的整个流程，有按照http://my.ss.sysu.edu.cn/wiki/pages/viewpage.action?pageId=221184007的设计进行', !->
  #   debug '''
  #   ************ 请注意，本测例需要人工观察，判断是否正确 **************
  #   '''    
  #   can '提交创建请求后，按照设计，服务端各模块执行了流程（url被解析为已有location的alias）', !(done)->
  #     open-client-with-testing-helper is-url-new-location = false, !(locations-channel, ip-channel, data)->
  #       debug-output-client-request-and-response-steps locations-channel, ip-channel, done

  #   can '提交创建请求后，按照设计，服务端各模块执行了流程（url被解析为新location的情况）', !(done)->
  #     open-client-with-testing-helper is-url-new-location = true, !(locations-channel, ip-channel, data)->
  #       debug-output-client-request-and-response-steps locations-channel, ip-channel, done
    # can "创建兴趣点时的URL，被识别为已有location。能够收到正确的Ï'response-create-a-new-ip-on-a-new-url'和'push-location-updated'消息", !(done)->

  describe 'url为已有locatoin的alias时', !->
    can '创建者收到response-create-a-new-ip-on-a-new-url，之前在此页面的用户收到push-location-updated', !(done)->
      (xiaodong-locations-channel, xiaodong-ip-channel, data) <-! open-client-with-testing-helper is-url-new-location = false
      (baixin-locations-channel, baixin-ip-channel, data) <-! open-client-without-testing-helper
      waiter = new utils.All-done-waiter done
      baixin-done = waiter.add-waiting-function!
      xiaodong-done = waiter.add-waiting-function!

      xiaodong-locations-channel.on 'response-create-a-new-ip-on-a-new-url', !(data)-> xiaodong-done!
      baixin-locations-channel.on 'response-create-a-new-ip-on-a-new-url', !(data)-> should.fail "非创建者收到了'response-create-a-new-ip-on-a-new-url'"

      baixin-locations-channel.on 'push-location-updated', !(data)-> baixin-done!
      xiaodong-locations-channel.on 'push-location-updated', !(data)-> should.fail "创建者收到了'push-location-updated'"

      xiaodong-ip-channel.emit 'request-create-a-new-ip-on-a-new-url'     


  before-each !(done)->
    <-! server.start
    socket-helper.clear-all-client-sockets! # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    utils.prepare-clean-test-db done
    debug 'prepare-clean-test-db complete'

  after-each !(done)->
    utils.close-db !->
      socket-helper.Sockets-distroyer.get!.destroy-all!
      server.shutdown!
      done!

# ---------------------- 美丽的分割线，以下辅助代码 ----------------------- #

open-client-without-testing-helper = !(callback)->
  open-client null, callback   

open-client-with-testing-helper = !(is-url-new-location, callback)->
  open-client {
    options: request-initial-data:
      testing-control: locations-manager: get-old-or-create-new-location: is-new: is-url-new-location
  }, callback   


open-client = !(testing-helper-channel-config, callback)->
  channels = null
  waiter = new utils.All-done-waiter! # 用以保存各个频道的channels，在所有回调结束后才可用。
  channels-configs =
    default-channel: {}
    locations-channel: {}
    interesting-points-channel: business-handler-register: !(socket, data)->
      socket-helper.Sockets-distroyer.get!.add-socket socket # 为了在每个测试结束，关闭服务端的socket，以便隔离各个测例。
      waiter.set-done -> 
        callback channels.locations-channel, channels.interesting-points-channel, data

  channels-configs.testing-helper-channel = testing-helper-channel-config if testing-helper-channel-config

  socket-helper.initial-client channels-configs, waiter.add-waiting-function !(cs)->
    channels := cs
    debug "客户端初始化完毕"   

debug-output-client-request-and-response-steps = !(locations-channel, ip-channel, done)->
  locations-channel.on 'ask-location-internality', !(data)->
    debug "@+ Client: ======== locations-channel in 'ask-location-internality' =========="
    debug "@+ Client: ======== locations-channel emit 'answer-location-internality' =========="
    locations-channel.emit 'answer-location-internality', is-internal: fake-figure-out-location-internality data.url, data.server-retrieved-html

  locations-channel.on 'push-location-updated', !(data)->
    debug "@+ Client: ======== in 'push-location-updated' ==========, channel id: ", locations-channel.socket.sessionid


  ip-channel.on 'response-create-a-new-ip-on-a-new-url', !(data)->
    debug "@+ Client: ======== ip-channel in 'response-create-a-new-ip-on-a-new-url' =========="
    set-timeout (!-> done!), 300 # 等待所有通信完成。
  debug "@+ Client: ======== ip-channelemit 'request-create-a-new-ip-on-a-new-url' =========="
  ip-channel.emit 'request-create-a-new-ip-on-a-new-url'



fake-figure-out-location-internality = (url, server-retrieved-html)->
  # debug ' .... 真实的client会在这里将server-retrieved-html和自己打开的location（url）中的源码进行比较，确定是否一致。一致则是not internal，否则是internal ...'
  true # 测试用true，激发服务器响应行为
