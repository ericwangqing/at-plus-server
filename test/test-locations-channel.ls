describe '测试location channel', !->
  describe '能够查询兴趣点', !->
    can '能够查回两个已有locations的兴趣点（中大、优酷，@+已有这两个location）的列表', !(done)->
      open-at-plus-on-locations [sysu-url, youku-url], !(socket, data)->
          data.should.have.property('locations').with.length-of 2
          data.locations.should.include-eql sysu-location # include-eql可以判断数组，而include不可以，因此这里需要用include-eql
          data.locations.should.include-eql youku-location
          done!

    can '查询一个已有location，一个@+中还没有的location时，只给回一个已有兴趣点', !(done)->
      open-at-plus-on-locations [sysu-url], !(socket, initial-data)->
          initial-data.should.have.property('locations').with.length-of 1
          initial-data.locations.should.include-eql sysu-location # include-eql可以判断数组，而include不可以，因此这里需要用include-eql
          done!

  describe '能够收听location的更新', !->
    can '收听来自他人，自己也在的location的更新', !(done)->
      (xiaodong, data) <-! open-at-plus-on-locations [sysu-url]
      (baixin, data) <-! open-at-plus-on-locations [sysu-url, youku-url]
      sysu-location = get-location data.locations, sysu-url

      xiaodong.on 'response-update-location', !(data)->
        data.lid.should.eql sysu-location._id
        data.message.should.eql '新的兴趣点'
        done!

      baixin.emit 'request-update-location', {lid: sysu-location._id, message: '新的兴趣点'}


    can '收不到来自他人，自己不在的location的更新', !(done)->
      (xiaodong, data) <-! open-at-plus-on-locations [sysu-url]
      (baixin, data) <-! open-at-plus-on-locations [sysu-url, youku-url]
      youku-location = get-location data.locations, youku-url

      xiaodong.on 'response-update-location', !(data)->
        should.fail '收到了来自自己不在的location的消息'

      baixin.emit 'request-update-location', {lid: youku-location._id, message: '新的兴趣点'}

      set-timeout (-> done!), 1000





  describe '测试are interal locations / report internal or not', !-> # 在Spike之后，针对已有协议，考虑更多各种情况，进行BDD开发。
  describe '测试are ask resolving locations / answer resolved locations', !->
  describe '测试are interal locations/report internal or not', !->

  before-each !(done)->
    <-! server.start
    (require 'socket.io-client/lib/io.js').sockets = {} # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    utils.open-clean-db-and-load-fixtures 'locations', [sysu-location, youku-location], !->

      sysu-location._id = String sysu-location._id # 这里的_id需要强制转换成String
      youku-location._id = String youku-location._id
      done!

  after-each !(done)->
    utils.close-db !->
      utils.Sockets-distroyer.get!.destroy-all!
      server.shutdown!
      done!

# ---------------------- 美丽的分割线，以下辅助代码 ----------------------- #

locations-channel-url = base-url + "/locations"
sysu-url = "http://ss.sysu.edu.cn/InformationSystem/"
youku-url = "http://v.youku.com/v_show/id_XNjA1OTQ2OTI0.html"
sysu-location = utils.load-fixture "sysu-location"
youku-location = utils.load-fixture "youku-location"

open-at-plus-on-locations = !(urls, callback)->
  request-server {
    url: locations-channel-url
    request-initial-data:
      locations:
        type: "web"
        urls: urls
    },
    !(socket, initial-data)->
      utils.Sockets-distroyer.get!.add-socket socket # 为了在每个测试结束，关闭服务端的socket，以便隔离各个测例。
      callback socket, initial-data

get-location = (locations, url)->
  for location in locations
    return location if url in location.urls


