require! ['./chats-manager', './channel-initial-wrapper']
_ = require 'underscore'

add-users-into-a-chat-room = !(sockets, cid, uids)->
  for socket in _.values sockets
    if socket.session.uid in uids
      socket.join cid 
      debug "--------- socket #{socket.id} with uid: #{socket.session.uid} join #{cid}"

fake-load-uids = !(socket, uid)->
  socket.session.uid = uid 
  debug 'fake uid loaded, session: ', socket.session

module.exports  = 
  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of('/chats')

      request-initial-handler: !(socket, data, callback)->
        fake-load-uids socket, data.uid #!!! 注意，SPIKE_chats用这句来简化用户身份的设置和获取，在SPIKE_chats之外其它任何地方，都要将这句删除掉！！
        callback!

      business-handlers-register: !(socket, data, callback)->
        socket.on 'request-create-a-chat', !(data)->
          (cid) <-! chats-manager.create-a-chat data.uids
          add-users-into-a-chat-room io.of('/chats').sockets, cid, data.uids
          socket.emit 'response-create-a-chat', cid: cid

        socket.on 'client-send-a-chat-message', !(data)->
          <-! chats-manager.add-a-message-to-chat data.cid, data.message
          socket.broadcast.to(data.cid).emit 'server-mediate-a-chat-message', {from: socket.session.uid, message: data.message}

        callback err = null, {}
        
    }
