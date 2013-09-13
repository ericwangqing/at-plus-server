'''
这是个FAKE，仅仅为了SPIKE_chats。
'''
fake-db = {}

require! 'node-uuid'
module.exports =
  create-a-chat: !(uids, callback)->
    cid = node-uuid.v4!
    fake-db[cid] = 
      uids: uids
      messages: []
    callback cid

  add-a-message-to-chat: !(cid, message, callback)->
    fake-db[cid].messages.push message
    callback!

  get-history-messages: !(query, callback)->
    if query.type is 'all' 
      callback fake-db[query.cid].messages
    else
      # 未实现
      callback!

