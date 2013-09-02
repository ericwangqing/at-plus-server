describe '能够通过session区分不同的用户', !->
  can '在同一个用户多次请求之间保存状态', !(done)->
    client1 = io.connect base-url, options
    n = null

    client1.on 'initial', !(data)->
      n := data.number
      client1.emit 'request-1', null

    client1.on 'request-1-answer', !(data)->
      data.number.should.eql n
      done!

  can '能够区分多个用户的请求', !(done)-> # option中 'force new connection': true
    n1 = n2 = null
    client1 = io.connect base-url, {'force new connection': true} <<< options  # 如果没有force new connection: true，将使用已有socket，无法区分

    client1.on 'initial', !(data)->
      n1 := data.number
      client1.emit 'request-1', null 

    client1.on 'request-1-answer', !(data)->
      # 此时才发起client2的连接，以保证n1已经取得。
      client2 = io.connect base-url, {'force new connection': true} <<< options 

      client2.on 'initial', !(data)->
        client1.socket.sessionid.should.not.eql client2.socket.sessionid
        n2 := data.number
        n2.should.not.eql n1
        client2.emit 'request-1', null 

      client2.on 'request-1-answer', !(data)->
        data.number.should.eql n2
        data.number.should.not.eql n1 
        done!

# describe '能够在同一用户连接多个channel时，保持数据正确', !->

#   can '多个channels有同样的sessionid', !(done)->
#     client1 = io.connect base-url, options 
#     client2 = io.connect base-url + '/locations', options 
#     client1.on 'initial', !(data)->
#       client1.socket.sessionid.should.eql client2.socket.sessionid
#       client2.on 'ready', !(data)->
#         console.log 'data of connected to /locations: ', data
#         done!

#   can '在多个channels间分享用户数据', !(done)->
#     m1 = m2 = null
#     client1 = io.connect base-url, options
#     client1.on 'initial', !(data)->
#       m1 := data.message
#       client2 = io.connect base-url + '/locations', {'force new connection': false} <<< options 
#       client2.on 'ready', !(data)->
#         console.log "client2 on ready with data: ", data
#         m2 := data.message
#         m1.should.eql m2
#         done!

#   can '不同channel可以各自使用自己的数据', !(done)->
#     done!
