# 这里不测试建立聊天的过程，直接自动进入聊天室

describe 'SPIKE Chats', !->
  before-each !(done)->
    <-! server.start
    (require 'socket.io-client/lib/io.js').sockets = {} # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    done!

  describe '私聊', !->
    can '两人能够收到对方的消息，而不会收到自己的消息', !(done)->
      should-users-chat-correctly {
        in-chat-uids: ['王瑜', '柏信']
        out-chat-uid: null
        done: done
      }

    can '局外人不会收到聊天的消息', !(done)->
      should-users-chat-correctly {
        in-chat-uids: ['王瑜', '柏信']
        out-chat-uid: '嘉华'
        done: done
      }

  describe '群聊', !->
    can '大家能够收到对方的消息，而不会收到自己的消息', !(done)->
      (cid, chats) <-! set-up-a-chat ['王瑜', '柏信', '嘉华']
      should-users-chat-correctly {
        in-chat-uids: ['王瑜', '柏信', '嘉华']
        out-chat-uid: null
        done: done
      }

    can '局外人不会收到聊天的消息', !(done)->
      (cid, chats) <-! set-up-a-chat ['王瑜', '柏信', '嘉华']
      should-users-chat-correctly {
        in-chat-uids: ['王瑜', '柏信', '嘉华']
        out-chat-uid: '军令'
        done: done
      }


  # describe '历史消息查询', !(done)->
  #   can '查询历史消息'


  after-each !(done)->
    debug 'io: ', (require 'socket.io-client/lib/io.js').sockets 
    utils.clear-and-close-db !->
      utils.Sockets-distroyer.get!.destroy-all!
      server.shutdown!
      done!

# ---------------------- 美丽的分割线，以下辅助代码 -----------------------

chats-channel-url = base-url + '/chats'

should-users-chat-correctly = !(config)->

    done new Error "至少要有两名用户!" if config.in-chat-uids.length < 2
    (cid, chats) <-! set-up-a-chat config.in-chat-uids
    should.exist cid
    for uid in config.in-chat-uids
      should.exist chats[uid] 

    sender = config.in-chat-uids[0]
    recievers = config.in-chat-uids.slice 1, config.in-chat-uids.length

    if config.out-chat-uid
      (chat) <-! connect-chats-channel config.out-chat-uid
      chat.on 'server-mediate-a-chat-message', !(data)->
        should.fail '局外人收到了消息', data
        config.done!

    waiter = new utils.All-done-waiter config.done

    for reciever in recievers
      chats[reciever].on 'server-mediate-a-chat-message', waiter.get-wating-function( 
        !(data)->
          debug "#{reciever} get message: #{data.message}"
          data.from.should.eql sender
      )

    chats[sender].on 'server-mediate-a-chat-message', !(data)->
      should.fail '收到了自己的消息'
      done!

    chats[sender].emit 'client-send-a-chat-message',
      cid: cid
      message: "#{sender} --> #{recievers * ', '}"
    
    waiter.start!

set-up-a-chat = !(uids, callback)->
  (sockets) <-! connect-all-users-to-chats-channel uids
  (cid) <-! initial-a-chat sockets, uids
  callback cid, sockets

initial-a-chat = !(sockets, uids, callback)->
  socket = sockets[uids[0]]
  socket.on 'response-create-a-chat', !(data)->
    callback data.cid
  socket.emit 'request-create-a-chat', uids: uids

connect-all-users-to-chats-channel = !(uids, callback)->
  sockets = {}
  (err) <-! async.each uids, !(uid, next)->
    connect-chats-channel uid, !(socket)->
      sockets[uid] = socket
      next!
  console.log err if err
  callback sockets

connect-chats-channel = !(uid, callback)->
  request-server {
    url: chats-channel-url
    request-initial-data: uid: uid # !!真实@+应用中，uid是用户登录之后存储在session中的，这里做了简化。
  },
  !(socket, initial-data)->
    utils.Sockets-distroyer.get!.add-socket socket # 为了在每个测试结束，关闭服务端的socket，以便隔离各个测例。
    callback socket



