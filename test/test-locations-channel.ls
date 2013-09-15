describe '测试location channel', !->
  describe 'BDD之Spike Story', !->
    can '能够查回两个已有locations的兴趣点（中大、优酷，@+已有这两个location）的列表', !(done)->
      initial-request-to-server {
        request-locatoin-urls: [sysu-url, youku-url]
        response-handler: !(socket, initial-data)->
          initial-data.should.have.property('locations').with.length-of 2
          initial-data.locations.should.include-eql sysu-location # include-eql可以判断数组，而include不可以，因此这里需要用include-eql
          initial-data.locations.should.include-eql youku-location
          done!
      }

    can '查询一个已有location，一个@+中还没有的location时，只给回一个已有兴趣点', !(done)->
      initial-request-to-server {
        request-locatoin-urls: [sysu-url]
        response-handler: !(socket, initial-data)->
          initial-data.should.have.property('locations').with.length-of 1
          initial-data.locations.should.include-eql sysu-location # include-eql可以判断数组，而include不可以，因此这里需要用include-eql
          done!
      }




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

initial-request-to-server = !(config)->
  request-server {
    url: locations-channel-url
    request-initial-data:
      locations:
        type: "web"
        urls: config.request-locatoin-urls
    },
    !(socket, initial-data)->
      utils.Sockets-distroyer.get!.add-socket socket # 为了在每个测试结束，关闭服务端的socket，以便隔离各个测例。
      config.response-handler socket, initial-data

