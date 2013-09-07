describe '测试@+为socket.io添加的session', !->
  before-each !->
    (require 'socket.io-client/lib/io.js').sockets = {} # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
 
  describe '能够通过session区分不同的用户', !->
    
    can 'a) 在同一个用户多次请求之间保存状态', !(done)->
      n = null
      request-server !(client, initial-data)->
        console.log "client handle response-initial: ", initial-data
        n := initial-data.number

        client.on 'request-1-answer', !(data)->
          console.log "client handle request-1-answer: ", data
          data.number.should.eql n
          done!

        client.emit 'request-1', null
        console.log 'client emit request-1'

    can 'b) 能够区分多个用户的请求', !(done)-> # option中 'force new connection': true
      n1 = n2 = cid1 = cid2 = null
      async.parallel [
        !(callback)->
          request-server !(client, initial-data)->
            cid1 := client.socket.sessionid
            n1 := initial-data.number
            callback!

        !(callback)->
          request-server !(client, initial-data)->
            cid2 := client.socket.sessionid
            n2 := initial-data.number
            callback!
            
        ], !->
          cid1.should.not.eql cid2 
          n2.should.not.eql n1
          done!
 

  describe '能够在同一用户连接多个channel时，保持数据正确', !->

    can 'a) 在多个channels间分享用户数据', !(done)->
      m1 = m2 = null
      async.parallel [
        !(callback)->
          request-server !(client, initial-data)->
            m1 := initial-data.message
            callback!
          , 
            options: 'force new connection': false

        !(callback)->
          request-server !(client)->
            client.on 'request-1-answer', !(data)->
              m2 := data.message
              callback!
            client.emit 'request-1'
          , 
            url: base-url + '/locations'
            options: 'force new connection': false

        ], !->
          m1.should.eql m2
          done!

    can 'b) 多个channels有同样的sessionid', !(done)->
      cid1 = cid2 = null
      async.parallel [
        !(callback)->
          request-server !(client, initial-data)->
            cid1 := client.socket.sessionid
            callback!
          , 
            options: 'force new connection': false

        !(callback)->
          request-server !(client, initial-data)->
            cid2 := client.socket.sessionid
            callback!
          , 
            url: base-url + '/locations'
            options: 'force new connection': false

        ], !->
          cid1.should.eql cid2
          done!

    can 'c) 不同channel可以各自使用自己的数据', !(done)->
      n1 = n2 = null
      async.parallel [
        !(callback)->
          request-server !(client, initial-data)->
            client.on 'request-1-answer', !(data)->
              n1 := data.number
              callback!
            client.emit 'request-1'
          , 
            options: 'force new connection': false

        !(callback)->
          request-server !(client, initial-data)->
            client.on 'request-1-answer', !(data)->
              n2 := data.number
              callback!
            client.emit 'request-1'
          , 
            url: base-url + '/locations'
            options: 'force new connection': false

        ], !->
          n1.should.not.eql n2
          done! 

    can 'd) 客户端的两次连接时，如果保存了sid，则可以恢复上一次的状态', !(done)->
      sid = message = null
      request-server !(client, initial-data)->
        debug 'initial-data 1: ', initial-data
        sid := initial-data.sid
        message := initial-data.message
        client.disconnect!

        request-server !(client, initial-data)->
          debug 'initial-data 2: ', initial-data
          initial-data.message.should.eql message
          done!
        ,
          request-initial-data:
            sid: sid
      