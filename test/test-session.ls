describe '能够通过session区分不同的用户', !->
  can '在同一个用户多次请求之间保存状态', !(done)->
    client1 = io.connect base-url, options
    cid = null

    client1.on 'initial', !(data)->
      console.log 'data: ', data
      cid := data.session.client
      client1.emit 'request-1', null

    client1.on 'request-1-answer', !(data)->
      console.log 'data: ', data
      data.session.client.should.eql cid
      console.log 'io: ', io.disconnect
      done!

  can '能够区分多个用户的请求', !(done)->
    cid1 = cid2 = null
    client1 = io.connect base-url, {'force new connection': true} <<< options

    client1.on 'initial', !(data)->
      cid1 := data.session.client
      console.log '\ncid1: ', cid1
      client1.emit 'request-1', null 

    client1.on 'request-1-answer', !(data)->
      console.log 'client1 request1 answer data: ', data
      data.session.client.should.eql cid1
      client2 = io.connect base-url, {'force new connection': true} <<< options
      # console.log "client1.socket.session: ", client1.socket.sessionid
      # console.log "client2.socket.session: ", client2.socket.sessionid

      client2.on 'initial', !(data)->
        cid2 := data.session.client
        console.log 'cid2: ', cid2
        client2.emit 'request-1', null 

      client2.on 'request-1-answer', !(data)->
        console.log 'client2 request1 answer data: ', data
        data.session.client.should.eql cid2
        data.session.client.should.not.eql cid1 
        client1.socket.sessionid.should.not.eql client2.socket.sessionid
        done!

  describe '能够在同一用户连接多个channel时，保持数据正确', !->

    can '多个channels有同样的sessionid', !(done)->
      cid1 = cid2 = null
      client1 = io.connect base-url, options
      client2 = io.connect base-url + '/locations', options
      client1.socket.sessionid.should.eql client2.socket.sessionid
     
      done!

    can '在多个channels间分享用户数据', !(done)->
      cid1 = cid2 = null
      client1 = io.connect base-url, options
      client2 = io.connect base-url + '/locations', options
     
      done!

    can '不同channel可以各自使用自己的数据', !(done)->
      done!




