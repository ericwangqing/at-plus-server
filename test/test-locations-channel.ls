locations-channel-url = base-url + '/locations'
sysu-url = 'http://ss.sysu.edu.cn/InformationSystem/'
youku-url = 'http://v.youku.com/v_show/id_XNjA1OTQ2OTI0.html'
sysu-location = utils.load-fixture 'sysu-location'
youku-location = utils.load-fixture 'youku-location'

describe '测试location channel', !->
  db-connection = null
  do
    (done) <-! before
    (connection) <-! database.get-db-connection
    db-connection := connection
    (err, records) <-! db-connection.locations.insert [sysu-location, youku-location], safe: true
    done! if !err

  describe 'BDD之Spike Story', !->
    can '能够给回小东两个兴趣点（中大、优酷）的列表', !(done)->
      request-server {
        url: locations-channel-url
        request-initial-data:
          locations:
            type: 'web'
            urls: [sysu-url, youku-url]
        },
        !(client, initial-data)->
          initial-data.should.have.property('locations').with.length-of 2
          initial-data.should.include.sysu-location
          initial-data.should.include.sysu-location
          done!

  describe '测试are interal locations / report internal or not', !-> # 在Spike之后，针对已有协议，考虑更多各种情况，进行BDD开发。
  describe '测试are ask resolving locations / answer resolved locations', !->
  describe '测试are interal locations/report internal or not', !->

  do
    (done) <-! after
    (err) <-! db-connection.locations.remove
    done! if !err
