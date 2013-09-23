require! H: './test-create-a-new-ip-on-a-new-url-helper'

describe '创建的整个流程，有按照http://my.ss.sysu.edu.cn/wiki/pages/viewpage.action?pageId=221184007的设计进行', !->
  debug '''
  ************ 请注意，本测例需要人工观察，判断是否正确 **************
  '''    
  can '提交创建请求后，按照设计，服务端各模块执行了流程（url被解析为已有location的alias）', !(done)->
    H.open-client-with-testing-helper is-url-new-location = false, !(locations-channel, ip-channel, data)->
      debug-output-client-request-and-response-steps locations-channel, ip-channel, done

  can '提交创建请求后，按照设计，服务端各模块执行了流程（url被解析为新location的情况）', !(done)->
    H.open-client-with-testing-helper is-url-new-location = true, !(locations-channel, ip-channel, data)->
      debug-output-client-request-and-response-steps locations-channel, ip-channel, done

  describe '多人交互时，消息发送和接收正确', !->
    request-data = null
    before-each !-> request-data := utils.load-fixture 'request-create-a-new-ip-on-a-new-url'     

    describe 'url为已有locatoin的alias时，消息次序正确', !->
      can '创建者收到response-create-a-new-ip-on-a-new-url，之前在此页面的用户收到push-location-updated', !(done)->
        (creator, observer, wait) <-! H.open-two-clients is-url-new-location = false, done
        creator.ip.on 'response-create-a-new-ip-on-a-new-url', wait !(data)-> debug "创建者收到创建成功消息"
        observer.ip.on 'response-create-a-new-ip-on-a-new-url', !(data)-> should.fail "观察者收到了'response-create-a-new-ip-on-a-new-url'"

        observer.locations.on 'push-location-updated', wait !(data)-> debug "观察者收到location更新消息"
        creator.locations.on 'push-location-updated', !(data)-> should.fail "创建者收到了'push-location-updated'"

        creator.ip.emit 'request-create-a-new-ip-on-a-new-url', request-data

    describe 'url为新的locatoin时，消息次序正确', !->
      can '创建者收到response-create-a-new-ip-on-a-new-url，之前在此页面的用户收到push-location-updated', !(done)->
        (creator, observer, wait) <-! H.open-two-clients is-url-new-location = true, done
        creator.ip.on 'response-create-a-new-ip-on-a-new-url', wait !(data)-> debug "创建者收到创建成功消息"
        observer.ip.on 'response-create-a-new-ip-on-a-new-url', !(data)-> should.fail "观察者收到了'response-create-a-new-ip-on-a-new-url'"

        observer.locations.on 'push-location-updated', wait !(data)-> debug "观察者收到location更新消息"
        creator.locations.on 'push-location-updated', !(data)-> should.fail "创建者收到了'push-location-updated'"

        creator.locations.on 'ask-location-internality', !(data)->
          debug "创建者收到了查询location internality消息"
          creator.locations.emit 'answer-location-internality', is-internal: H.fake-figure-out-location-internality data.url, data.server-retrieved-html
        observer.locations.on 'ask-location-internality', !(data)->
          should.fail "观察者收到了查询location internality消息"

        creator.ip.emit 'request-create-a-new-ip-on-a-new-url', request-data 

  before-each !(done)->
    <-! server.start
    socket-helper.clear-all-client-sockets! # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    utils.prepare-clean-test-db done

  after-each !(done)->
    utils.close-db !->
      socket-helper.Sockets-distroyer.get!.destroy-all!
      server.shutdown!
      done!

# ---------------------- 美丽的分割线，以下辅助代码 ----------------------- #

debug-output-client-request-and-response-steps = !(locations-channel, ip-channel, done)->
  locations-channel.on 'ask-location-internality', !(data)->
    debug "@+ Client: ======== locations-channel in 'ask-location-internality' =========="
    debug "@+ Client: ======== locations-channel emit 'answer-location-internality' =========="
    locations-channel.emit 'answer-location-internality', is-internal: H.fake-figure-out-location-internality data.url, data.server-retrieved-html

  locations-channel.on 'push-location-updated', !(data)->
    debug "@+ Client: ======== in 'push-location-updated' ==========, channel id: ", locations-channel.socket.sessionid


  ip-channel.on 'response-create-a-new-ip-on-a-new-url', !(data)->
    debug "@+ Client: ======== ip-channel in 'response-create-a-new-ip-on-a-new-url' =========="
    set-timeout (!-> done!), 300 # 等待所有通信完成。
  debug "@+ Client: ======== ip-channelemit 'request-create-a-new-ip-on-a-new-url' =========="
  ip-channel.emit 'request-create-a-new-ip-on-a-new-url', utils.load-fixture 'request-create-a-new-ip-on-a-new-url'
