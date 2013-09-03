server = require '../bin/server'
clients = []
module-cache-sockets = 'socket.io-client/lib/io.js' # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
describe '测试@+为socket.io添加的session', !->
  before-each !->
    (require module-cache-sockets).sockets = {}
    # server.start done
 
  describe '能够通过session区分不同的用户', !->
    can '在同一个用户多次请求之间保存状态', !(done)->
      clients[0] = io.connect base-url, options
      n = null

      clients[0].on 'initial', !(data)->
        n := data.number
        clients[0].emit 'request-1', null

      clients[0].on 'request-1-answer', !(data)->
        data.number.should.eql n
        done!

    can '能够区分多个用户的请求', !(done)-> # option中 'force new connection': true
      n1 = n2 = null
      clients[0] = io.connect base-url, options  # 如果没有force new connection: true，将使用已有socket，无法区分

      clients[0].on 'initial', !(data)->
        n1 := data.number
        clients[0].emit 'request-1', null 

      clients[0].on 'request-1-answer', !(data)->
        # 此时才发起clients[1]的连接，以保证n1已经取得。
        clients[1] = io.connect base-url, options 

        clients[1].on 'initial', !(data)->
          clients[0].socket.sessionid.should.not.eql clients[1].socket.sessionid
          n2 := data.number
          n2.should.not.eql n1
          clients[1].emit 'request-1', null 

        clients[1].on 'request-1-answer', !(data)->
          data.number.should.eql n2
          data.number.should.not.eql n1 
          done!

  describe '能够在同一用户连接多个channel时，保持数据正确', !->

    can 'a) 在多个channels间分享用户数据', !(done)->
      m1 = m2 = null
      async.parallel [
        !(callback)->
          clients[0] = io.connect base-url, options
          clients[0].on 'initial', !(data)->
            console.log "a) clients[0]: ", clients[0].socket.sessionid
            m1 := data.message
            callback!
        !(callback)->
          clients[1] = io.connect base-url + '/locations' 
          clients[1].on 'ready', !(data)->
            console.log "a) clients[1]: ", clients[1].socket.sessionid
            console.log "a) clients[1] on ready with data: ", data
            m2 := data.message
            callback!
        ], !->
          m1.should.eql m2
          done!

    can 'b) 多个channels有同样的sessionid', !(done)->
      async.parallel [
        !(callback)->
          clients[0] = io.connect base-url
          clients[0].on 'initial', !(data)->
            console.log "b) clients[0]: ", clients[0].socket.sessionid
          callback!
        !(callback)->
          clients[1] = io.connect base-url + '/locations'
          console.log "b) clients[1]: ", clients[1].socket.sessionid
          clients[1].on 'ready', !(data)->
            clients[0].socket.sessionid.should.eql clients[1].socket.sessionid
            console.log "b) clients[1]: ", clients[1].socket.sessionid
            console.log 'b) data of connected to /locations: ', data
            callback!
        ], !->
          done!

    # can '不同channel可以各自使用自己的数据', !(done)->
    #   done!
