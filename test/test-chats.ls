# 这里不测试建立聊天的过程，直接自动进入聊天室

chats-channel-url = base-url + '/chats'

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
    sockets-distroyer.get!.add-socket socket # 为了在每个测试结束，关闭服务端的socket，以便隔离各个测例。
    callback socket

class sockets-distroyer # Singleton
  instance = null

  class destroyer
    !->
      @client-sockets = []
    add-socket: (socket)->
      @client-sockets.push socket
    destroy-all: !->
      for socket in @client-sockets
        socket = socket.socket if socket.socket # 当socket.io 连接到有namespace的情况要用socket.socket.disconnect!
        socket.disconnect!

  @get = (socket)->
    instance ?:= new destroyer socket


describe 'SPIKE Chats', !->
  before-each !(done)->
    debug 'io: ', (require 'socket.io-client/lib/io.js').sockets 

    <-! server.start
    (require 'socket.io-client/lib/io.js').sockets = {} # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    done!

  describe '私聊', !->
    can '两人能够收到对方的消息，而不会收到自己的消息', !(done)->
      (cid, chats) <-! set-up-a-chat ['王瑜', '柏信']
      should.exist cid
      should.exist chats['王瑜']
      should.exist chats['柏信']

      chats['王瑜'].on 'server-mediate-a-chat-message', !(data)->
        data.message.should.eql '柏信-->王瑜'
        data.from.should.eql '柏信'
        done!

      chats['柏信'].on 'server-mediate-a-chat-message', !(data)->
        should.fail '收到了自己的消息'
        done!

      chats['柏信'].emit 'client-send-a-chat-message',
        cid: cid
        message: '柏信-->王瑜'

    can '局外人不会收到聊天的消息', !(done)->
      (chat) <-! connect-chats-channel '嘉华'
      chat.on 'server-mediate-a-chat-message', !(data)->
        should.fail '局外人收到了消息', data
        done!

      (cid, chats) <-! set-up-a-chat ['王瑜', '柏信']
      chats['王瑜'].on 'server-mediate-a-chat-message', !(data)->
        data.message.should.eql '柏信-->王瑜'
        data.from.should.eql '柏信'
        done!

      chats['柏信'].emit 'client-send-a-chat-message',
        cid: cid
        message: '柏信-->王瑜'

  # describe '群聊', !->
  #   can '参与者都会收到他人的消息', !(done)->
  #     done!

  #   can '参与者不会收到自己的消息', !(done)->
  #     done!

  #   '局外者不会收到任何消息'

  # describe '历史消息查询', !(done)->
  #   can '查询历史消息'


  after-each !(done)->
    debug 'io: ', (require 'socket.io-client/lib/io.js').sockets 
    utils.clear-and-close-db !->
      sockets-distroyer.get!.destroy-all!
      server.shutdown!
      done!