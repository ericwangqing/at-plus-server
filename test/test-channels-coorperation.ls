interesting-pionts-channel-url = base-url + '/interesting-points'  
users-channel-url = base-url + '/users'

describe 'SPIKE之频道协同', !->
  interesting-points-channel = null
  initial-interesting-points-channel = !(done)->
      request-server {
        url: interesting-pionts-channel-url
      },
      !(client, initial-data)->
        interesting-points-channel := client
        done!

  before-each !(done)->
    <-! server.start
    (require 'socket.io-client/lib/io.js').sockets = {} # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    initial-interesting-points-channel done

  can '向intesting-points频道发送请求，从users频道得到响应', !(done)->
    request-server {
      url: users-channel-url
      },
      !(users-channel, initial-data)->
        users-channel.on 'response-user-create-interesting-point-comment', !(data)->
          data.username.should.eql '小东'
          done!
        interesting-points-channel.emit 'request-new-interesting-point-comment',
          username: '小东'
          comment: {'something'}


  after-each !(done)->
    utils.clear-and-close-db done
    server.shutdown!