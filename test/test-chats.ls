describe 'SPIKE Chats', !->
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
      should-users-chat-correctly {
        in-chat-uids: ['王瑜', '柏信', '嘉华']
        out-chat-uid: null
        done: done
      }

    can '局外人不会收到聊天的消息', !(done)->
      should-users-chat-correctly {
        in-chat-uids: ['王瑜', '柏信', '嘉华']
        out-chat-uid: '军令'
        done: done
      }


  describe '历史消息查询', !->
    can '查询所有历史消息，包括发给我的消息，也包括我发的消息', !(done)->
      HISTORY_MESSAGE_AMOUNT = 5
      (cid, chats) <-! set-up-a-chat in-chat = ['王瑜', '柏信'], out-chat = null
      chats['王瑜'].on 'response-history-messages', !(data)->
        data.should.have.property('messages').with.length-of (2 * HISTORY_MESSAGE_AMOUNT)
        done!

      waiter = new utils.All-done-waiter finish = !->
        chats['王瑜'].emit 'request-history-messages',
          type: 'all'
          cid: cid

      wait1 = waiter.add-wating-function!
      wait2 = waiter.add-wating-function!

      async.each-series [1 to HISTORY_MESSAGE_AMOUNT], !(i, next)->
        ensure-completely-sent-and-recieved-a-message cid, chats, '柏信', '王瑜', i, next
      ,
        wait1
        
      async.each-series [1 to HISTORY_MESSAGE_AMOUNT], !(i, next)->
        ensure-completely-sent-and-recieved-a-message cid, chats, '王瑜', '柏信', i, next
      ,
        wait2

  before-each !(done)->
    <-! server.start
    (require 'socket.io-client/lib/io.js').sockets = {} # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    done!

  after-each !(done)->
    utils.clear-and-close-db !->
      utils.Sockets-distroyer.get!.destroy-all!
      server.shutdown!
      done!

# ---------------------- 美丽的分割线，以下辅助代码 -----------------------

chats-channel-url = base-url + '/chats'

should-users-chat-correctly = !(config)->
    config.done new Error "至少要有两名用户!" if config.in-chat-uids.length < 2

    (cid, chats) <-! set-up-a-chat config.in-chat-uids, config.out-chat-uid
    should-all-users-in-chat cid, config.in-chat-uids, chats

    sender = config.in-chat-uids[0]
    recievers = config.in-chat-uids.slice 1, config.in-chat-uids.length

    should-all-recievers-recieve-message chats, recievers, sender, config.done
    should-sender-not-recieve-message chats, sender
    should-out-chat-user-not-recieve-message chats, config.out-chat-uid
    start-chat cid, chats, sender, recievers

set-up-a-chat = !(in-chat-uids, out-chat-uid, callback)->
  (sockets) <-! connect-all-users-to-chats-channel in-chat-uids.concat out-chat-uid
  (cid) <-! initial-a-chat sockets, in-chat-uids
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

should-all-users-in-chat = !(cid, uids, chats)->
  should.exist cid
  for uid in uids
    should.exist chats[uid] 

should-all-recievers-recieve-message = !(chats, recievers, sender, done)->   
  waiter = new utils.All-done-waiter done
  for reciever in recievers
    chats[reciever].on 'server-mediate-a-chat-message', waiter.add-wating-function( 
      !(data)->
        # debug "#{reciever} get message: #{data.message}"
        data.from.should.eql sender
    )

should-sender-not-recieve-message = !(chats, sender)->
  chats[sender].on 'server-mediate-a-chat-message', !(data)->
    should.fail '收到了自己的消息'
    done!

should-out-chat-user-not-recieve-message = !(chats, out-chat-uid)->
  chats[out-chat-uid].on 'server-mediate-a-chat-message', !(data)->
    should.fail '局外人收到了消息'
    config.done!

start-chat = !(cid, chats, sender, recievers)->
  chats[sender].emit 'client-send-a-chat-message',
    cid: cid
    message: "#{sender} --> #{recievers * ', '}"


ensure-completely-sent-and-recieved-a-message = !(cid, chats, sender, reciever, seq-no, done)->
  # debug "ensure-completely-sent-and-recieved-a-message, seq-no: ", seq-no
  chats[reciever].on 'server-mediate-a-chat-message', handler = !(data)->
    data.from.should.eql sender
    data.message.should.include seq-no
    chats[reciever].remove-listener 'server-mediate-a-chat-message', handler
    done!
  chats[sender].emit 'client-send-a-chat-message',
    cid: cid
    message: "#{sender} --> #{reciever}：#{seq-no}"





