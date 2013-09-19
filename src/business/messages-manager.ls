require! ['./database', './config']
_ = require 'underscore'

get-recent-messages-map = !(ipids, callback)->
  (db) <-! database.get-db
  # cursor = db.at-plus.messages.find {ipid: "$in": ipids} 
  (err, messages) <-! db.at-plus.messages.find {ipid: "$in": ipids} 
    # .limit config.locations-channel.amount-of-recent-messages-in-interesting-points
    .sort create-time: -1
    .to-array
  callback create-brief-recent-messages-map messages

create-brief-recent-messages-map = (messages)->
  recent-messages-map = {}
  for message in messages
    recent-messages-map[message.ipid] ||= []
    if recent-messages-map[message.ipid].length < config.locations-channel.amount-of-recent-messages-in-interesting-points
      recent-msg =
        _id: message._id
        create-time: message.create-time
        send-by: message.send-by
        permlink: message.permlink
      recent-msg.reposts = [repost.url for repost in message.reposts] if message.reposts
      recent-msg.text-content = message.text-content if message.text-content
      recent-msg.voice-content = message.voice-content if message.voice-content
      recent-messages-map[message.ipid].push recent-msg

  recent-messages-map


module.exports =
  get-recent-messages-map: get-recent-messages-map
  create-brief-recent-messages-map: create-brief-recent-messages-map # !!暴露出来，仅仅是为了测试