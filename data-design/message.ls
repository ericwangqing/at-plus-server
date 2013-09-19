message =
  _id: 'xxxx'
  type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
  ipid: void # interesting point id
  r-mid: void # the message replied to, only available when type either is ip-rpl or chat-rpl
  cid: 'cid-1' # chat id
  original-content-type: 'text' # text | voice
  text-content: '快乐无极限' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
  voice-content: void 
  at-users: ['uid-1', 'uid-2', 'cid-1']
  create-time: '2013-02-04 12:03:02'
  send-by: 'uid-4'
  reposts:
    * type: 'weibo' # 各个SNS，先暂时为weibo
      repost-id: 'xxxx'
      url: 'http://weibo.com/xxxx' # repost的地址
    ...
  is-copied-from-third-part: false # 用户在@+之外的平台上发送的消息，被我们汇集到@+时，此值为true
  origin-url: 'http://weibo.com/xxxx' # 原来的出处
  permlink: 'http://at-plus.com/xxxx' # 可收藏的永久链接