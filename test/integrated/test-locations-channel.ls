#describe '测试location channel', !->
#  describe 'Client initial Locations Channel', !->
#    can 'inital后，查回两个已有locations的兴趣点列表', !(done)->
#      open-at-plus-on-locations [sysu-url, youku-url], xiaodong-id, !(socket, data)->
#          data.should.have.property('locations').with.length-of 2
#          data.locations.should.include-eql response-sysu-location
#          data.locations.should.include-eql response-youku-location
#          done!
#
#    can 'initial with一个已有，一个@+中还没有的location时，只给回一个已有兴趣点', !(done)->
#      open-at-plus-on-locations [sysu-url], xiaodong-id, !(socket, data)->
#          data.should.have.property('locations').with.length-of 1
#          data.locations.should.include-eql response-sysu-location # include-eql可以判断数组，而include不可以，因此这里需要用include-eql
#          data.locations.should.not.include-eql response-youku-location # include-eql可以判断数组，而include不可以，因此这里需要用include-eql
#          done!
#
#    can 'initial后，收听来自他人，自己也在的location的更新', !(done)->
#      (xiaodong, data) <-! open-at-plus-on-locations [sysu-url], xiaodong-id
#      (baixin, data) <-! open-at-plus-on-locations [sysu-url, youku-url] baixin-id
#      sysu-location = get-location data.locations, sysu-url
#
#      xiaodong.on 'response-update-location', !(data)->
#        data.lid.should.eql sysu-location._id
#        data.message.should.eql '新的兴趣点'
#        done!
#
#      baixin.emit 'request-update-location', {lid: sysu-location._id, message: '新的兴趣点'}
#
#    can 'initial后，收不到来自他人，自己不在的location的更新', !(done)->
#      (xiaodong, data) <-! open-at-plus-on-locations [sysu-url], xiaodong-id
#      (baixin, data) <-! open-at-plus-on-locations [sysu-url, youku-url], baixin-id
#      youku-location = get-location data.locations, youku-url
#
#      xiaodong.on 'response-update-location', !(data)->
#        console.log data
#        should.fail '收到了来自自己不在的location的消息'
#
#      baixin.emit 'request-update-location', {lid: youku-location._id, message: '新的兴趣点'}
#
#      set-timeout (-> done!), 1000
#
#  before-each !(done)->
#    <-! server.start
#    socket-helper.clear-all-client-sockets! # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
#    utils.prepare-clean-test-db done
#    debug 'prepare-clean-test-db complete'
#
#  after-each !(done)->
#    utils.close-db !->
#      socket-helper.Sockets-distroyer.get!.destroy-all!
#      server.shutdown!
#      done!
#
## ---------------------- 美丽的分割线，以下辅助代码 ----------------------- #
#
#sysu-url = "http://ss.sysu.edu.cn/InformationSystem/"
#youku-url = "http://v.youku.com/v_show/id_XNjA1OTQ2OTI0.html"
#xiaodong-id = 'uid-1'
#baixin-id = 'uid-2'
#wangyu-id = 'uid-3'
#response-sysu-location = responses-mocker.mock-locations-channel-initial-response 'lid-1', xiaodong-id
#response-youku-location = responses-mocker.mock-locations-channel-initial-response 'lid-2', xiaodong-id
#
#open-at-plus-on-locations = !(urls, uid, callback)->
#  socket-helper.initial-client {
#    default-channel: {}
#    testing-helper-channel: options: request-initial-data: fake-uid: uid
#    locations-channel: 
#      options:
#        request-initial-data:
#          locations:
#            type: "web"
#            urls: urls
#      business-handler-register: !(socket, data)->
#        socket-helper.Sockets-distroyer.get!.add-socket socket # 为了在每个测试结束，关闭服务端的socket，以便隔离各个测例。
#        callback socket, data
#  }, !->
#    # debug "客户端初始化完成"
#
#
#get-location = (locations, url)->
#  for location in locations
#    return location if url in location.urls
