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
      done!

  can '能够区分多个用户的请求', !(done)->
    cid1 = cid2 = null
    client1 = io.connect base-url, options 

    client1.on 'initial', !(data)->
      cid1 := data.session.client
      console.log '\ncid1: ', cid1
      client1.emit 'request-1', null 

    client1.on 'request-1-answer', !(data)->
      console.log 'client1 request1 answer data: ', data
      data.session.client.should.eql cid1

      client2 = io.connect base-url, options
      client2.on 'initial', !(data)->
        cid2 := data.session.client
        console.log 'cid2: ', cid2
        client2.emit 'request-1', null 

      client2.on 'request-1-answer', !(data)->
        console.log 'client2 request1 answer data: ', data
        data.session.client.should.eql cid2
        data.session.client.should.not.eql cid1
        done!




