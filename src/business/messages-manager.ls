require! ['./database', './config']
_ = require 'underscore'

get-recent-messages-map = !(ipids, callback)->
  (db) <-! database.get-db
  (err, messages) <-! db.at-plus.messages.find {ipid: "$in": ipids} 
    .sort create-time: -1
    .to-array
  callback create-brief-recent-messages-map messages

create-brief-recent-messages-map = (messages)->
  recent-messages-map = {}
  for message in messages
    recent-messages-map[message.ipid] ||= []
    if recent-messages-map[message.ipid].length < config.locations-channel.amount-of-recent-messages-in-interesting-points
      recent-msg = _.pick message, 'createTime', 'sendBy', 'permlink', 'textContent', 'voiceContent'
      recent-msg.reposts = [repost.url for repost in message.reposts] if message.reposts
      recent-messages-map[message.ipid].push recent-msg

  recent-messages-map


module.exports =
  get-recent-messages-map: get-recent-messages-map
  create-brief-recent-messages-map: create-brief-recent-messages-map # !!暴露出来，仅仅是为了测试