locations-channel-url = base-url + '/locations'
sysu-url = 'http://ss.sysu.edu.cn/InformationSystem/'
youku-url = 'http://v.youku.com/v_show/id_XNjA1OTQ2OTI0.html'
sysu-location = utils.load-fixture 'sysu-location'
youku-location = utils.load-fixture 'youku-location'

describe '测试location channel', !->
  before-each !(done)->
    (require 'socket.io-client/lib/io.js').sockets = {} # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    utils.open-db-and-load-fixtures 'locations', [sysu-location, youku-location], !->
      sysu-location._id = String sysu-location._id # 这里的_id需要强制转换成String
      youku-location._id = String youku-location._id
      done!

  describe 'BDD之Spike Story', !->
    can '能够给回小东两个页面的兴趣点（中大、优酷）的列表', !(done)->
      request-server {
        url: locations-channel-url
        request-initial-data:
          locations:
            type: 'web'
            urls: [sysu-url, youku-url]
        },
        !(client, initial-data)->
          initial-data.should.have.property('locations').with.length-of 2
          initial-data.locations.should.include-eql sysu-location # include-eql可以判断数组，而include不可以，因此这里需要用include-eql
          initial-data.locations.should.include-eql youku-location
          done!


  after-each !(done)->
    utils.clear-and-close-db done

  describe '测试are interal locations / report internal or not', !-> # 在Spike之后，针对已有协议，考虑更多各种情况，进行BDD开发。
  describe '测试are ask resolving locations / answer resolved locations', !->
  describe '测试are interal locations/report internal or not', !->

