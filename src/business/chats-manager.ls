'''
这是个FAKE，仅仅为了SPIKE_chats。
'''

require! 'node-uuid'
module.exports =
  create-a-chat: !(uids, callback)->
    callback cid = node-uuid.v4!

  add-a-message-to-chat: !(cid, message, callback)->
    callback!
