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

  # describe '多人交互时，消息发送和接收正确', !->
  #   describe 'url为已有locatoin的alias时，消息次序正确', !->
  #     can '创建者收到response-create-a-new-ip-on-a-new-url，之前在此页面的用户收到push-location-updated', !(done)->
  #       (xiaodong, baixin, wait) <-! open-two-clients is-url-new-location = false, done
  #       xiaodong.ip.on 'response-create-a-new-ip-on-a-new-url', wait !(data)-> debug "创建者收到创建成功消息"
  #       baixin.ip.on 'response-create-a-new-ip-on-a-new-url', !(data)-> should.fail "非创建者收到了'response-create-a-new-ip-on-a-new-url'"

  #       baixin.locations.on 'push-location-updated', wait !(data)-> debug "非创建者收到location更新消息"
  #       xiaodong.locations.on 'push-location-updated', !(data)-> should.fail "创建者收到了'push-location-updated'"

  #       xiaodong.ip.emit 'request-create-a-new-ip-on-a-new-url'     

  #   describe 'url为新的locatoin时，消息次序正确', !->
  #     can '创建者收到response-create-a-new-ip-on-a-new-url，之前在此页面的用户收到push-location-updated', !(done)->
  #       (xiaodong, baixin, wait) <-! open-two-clients is-url-new-location = true, done
  #       xiaodong.ip.on 'response-create-a-new-ip-on-a-new-url', wait !(data)-> debug "创建者收到创建成功消息"
  #       baixin.ip.on 'response-create-a-new-ip-on-a-new-url', !(data)-> should.fail "非创建者收到了'response-create-a-new-ip-on-a-new-url'"

  #       baixin.locations.on 'push-location-updated', wait !(data)-> debug "非创建者收到location更新消息"
  #       xiaodong.locations.on 'push-location-updated', !(data)-> should.fail "创建者收到了'push-location-updated'"

  #       xiaodong.locations.on 'ask-location-internality', !(data)->
  #         debug "创建者收到了查询location internality消息"
  #         xiaodong.locations.emit 'answer-location-internality', is-internal: fake-figure-out-location-internality data.url, data.server-retrieved-html
  #       baixin.locations.on 'ask-location-internality', !(data)->
  #         should.fail "非创建者收到了查询location internality消息"

  #       xiaodong.ip.emit 'request-create-a-new-ip-on-a-new-url'     

  describe '创建兴趣点后，客户端接收到正确的数据，服务端正确保存了兴趣点', !->
    testing-data = total-locations-in-db = total-interestiong-points-in-db = null
    before-each !->
      (amount) <-! count-locaitons-in-db
      total-locations-in-db := amount
      (amount) <-! count-interesting-points-in-db
      total-interestiong-points-in-db := amount
      testing-data := prepare-testing-data!

    describe 'url为已有locatoin的alias时，消息内容正确，兴趣点正确保存', !->
      can '创建者收到response-create-a-new-ip-on-a-new-url，之前在此页面的用户收到push-location-updated', !(done)->
        (xiaodong, baixin, wait) <-! open-two-clients is-url-new-location = false, done
        xiaodong.ip.on 'response-create-a-new-ip-on-a-new-url', wait !(data)-> 
          debug "创建者收到创建成功消息"
          data.should.have.property 'lid'
          data.should.have.property 'ipid'
          data.result.should.eql 'success'

          done-waiter = wait!
          debug "total-locations-in-db: #{total-locations-in-db}, total-interestiong-points-in-db: #{total-interestiong-points-in-db}"
          <-! should-db-not-include-any-new-location total-locations-in-db
          <-! should-new-location-url-added-as-alias testing-data.request-create-a-new-ip-on-a-new-url
          <-! should-db-include-a-new-interesting-point total-interestiong-points-in-db
          <-! should-db-include-the-requested-new-ip testing-data.request-create-a-new-ip-on-a-new-url
          done-waiter!

        baixin.ip.on 'response-create-a-new-ip-on-a-new-url', !(data)-> should.fail "非创建者收到了'response-create-a-new-ip-on-a-new-url'"

        baixin.locations.on 'push-location-updated', wait !(data)-> 
          debug "非创建者收到location更新消息"
          data.type.should.eql 'new-ip-added'
          data.should.have.property '_id'
          data.added-interesting-point.should.have.property '_id'
          data.added-interesting-point.created-by.should.have.property '_id'
          (utils.chop-off-id data).should.eql (utils.chop-off-id testing-data.push-location-updated)

        xiaodong.locations.on 'push-location-updated', !(data)-> should.fail "创建者收到了'push-location-updated'"

        xiaodong.ip.emit 'request-create-a-new-ip-on-a-new-url', testing-data.request-create-a-new-ip-on-a-new-url


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


open-two-clients = !(is-url-new-location, done, callback)->
  (a-locations-channel, a-ip-channel, data) <-! open-client-with-testing-helper is-url-new-location = false
  (b-locations-channel, b-ip-channel, data) <-! open-client-without-testing-helper
  done-waiter = new utils.All-done-waiter done
  callback {locations: a-locations-channel, ip: a-ip-channel}, {locations: b-locations-channel, ip: b-ip-channel}, done-waiter.add-waiting-function

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

prepare-testing-data = ->
  request-create-a-new-ip-on-a-new-url: utils.load-fixture 'request-create-a-new-ip-on-a-new-url'
  push-location-updated: utils.load-fixture 'push-location-updated'

fake-figure-out-location-internality = (url, server-retrieved-html)->
  # debug ' .... 真实的client会在这里将server-retrieved-html和自己打开的location（url）中的源码进行比较，确定是否一致。一致则是not internal，否则是internal ...'
  true # 测试用true，激发服务器响应行为

count-locaitons-in-db = !(callback)->
  count-amount-of-docs-in-a-collection 'locations', callback

count-interesting-points-in-db = !(callback)->
  count-amount-of-docs-in-a-collection 'interesting-points', callback

count-amount-of-docs-in-a-collection = !(collection-name, callback)->
  (results) <-! query-collection collection-name, {}
  callback results.length

should-db-not-include-any-new-location = !(old-amount, callback)->
  (locations) <-! query-collection 'locations', {}
  locations.length.should.eql old-amount
  callback!

should-new-location-url-added-as-alias = !(new-ip, callback)->
  (locations) <-! query-collection 'locations', {urls: new-ip.within-location.url}
  locations.length.should.eql 1
  callback!


should-db-include-a-new-interesting-point = !(old-amount, callback)->
  (locations) <-! query-collection 'interesting-points', {} 
  locations.length.should.eql old-amount + 1
  callback!

should-db-include-the-requested-new-ip = !(new-ip, callback)->
  (ips) <-! query-collection 'interesting-points', {'title': new-ip.title} 
  debug "ips: ", ips
  ips.length.should.eql 1
  callback!

query-collection = !(collection-name, query-obj, callback)->
  (db) <-! database.get-db
  (err, results) <-! db.at-plus[collection-name].find query-obj .to-array
  callback results



