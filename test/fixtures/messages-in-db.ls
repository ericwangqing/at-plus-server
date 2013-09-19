messages =
  * _id: 'mid-1'
    type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
    ipid: 'ipid-1' # interesting point id
    original-content-type: 'text' # text | voice
    text-content: '快乐无极限' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
    at-users: ['uid-2', 'uid-4']
    create-time: '2013-02-04 12:03:02'
    send-by: 'uid-8'
    reposts:
      * type: 'weibo' # 各个SNS，先暂时为weibo
        repost-id: 'weibo-1'
        url: 'http://weibo.com/xxxx' # repost的地址
      ...
    permlink: 'http://at-plus.com/messages/mid-1' # 可收藏的永久链接  

  * _id: 'mid-2'
    type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
    ipid: 'ipid-1' # interesting point id
    original-content-type: 'text' # text | voice
    text-content: '快乐无极限+1' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
    create-time: '2013-02-04 12:13:02'
    send-by: 'uid-4'
    permlink: 'http://at-plus.com/messages/mid-2' # 可收藏的永久链接  

  * _id: 'mid-3'
    type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
    ipid: 'ipid-1' # interesting point id
    original-content-type: 'text' # text | voice
    text-content: '快乐无极限+2' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
    create-time: '2013-02-04 12:23:02'
    send-by: 'uid-2'
    permlink: 'http://at-plus.com/messages/mid-3' # 可收藏的永久链接  

  * _id: 'mid-4'
    type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
    ipid: 'ipid-2' # interesting point id
    original-content-type: 'text' # text | voice
    text-content: '生活无极限' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
    create-time: '2013-02-04 12:23:02'
    send-by: 'uid-2'
    permlink: 'http://at-plus.com/messages/mid-4' # 可收藏的永久链接  

  * _id: 'mid-5'
    type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
    ipid: 'ipid-2' # interesting point id
    original-content-type: 'text' # text | voice
    text-content: '生活无极限+1' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
    create-time: '2013-02-04 12:33:02'
    send-by: 'uid-4'
    permlink: 'http://at-plus.com/messages/mid-' # 可收藏的永久链接  

  * _id: 'mid-6'
    type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
    ipid: 'ipid-2' # interesting point id
    original-content-type: 'text' # text | voice
    text-content: '生活无极限+2' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
    create-time: '2013-02-04 12:43:02'
    send-by: 'uid-8'
    permlink: 'http://at-plus.com/messages/mid-6' # 可收藏的永久链接  

  * _id: 'mid-7'
    type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
    ipid: 'ipid-3' # interesting point id
    original-content-type: 'text' # text | voice
    text-content: '漂亮无极限' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
    create-time: '2013-02-04 12:13:02'
    send-by: 'uid-3'
    permlink: 'http://at-plus.com/messages/mid-7' # 可收藏的永久链接  

  * _id: 'mid-8'
    type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
    ipid: 'ipid-3' # interesting point id
    original-content-type: 'text' # text | voice
    text-content: '漂亮无极限+1' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
    create-time: '2013-02-04 12:23:02'
    send-by: 'uid-4'
    permlink: 'http://at-plus.com/messages/mid-8' # 可收藏的永久链接  

  * _id: 'mid-9'
    type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
    ipid: 'ipid-3' # interesting point id
    original-content-type: 'text' # text | voice
    text-content: '漂亮无极限+2' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
    create-time: '2013-02-04 12:33:02'
    send-by: 'uid-8'
    permlink: 'http://at-plus.com/messages/mid-9' # 可收藏的永久链接  

  OTHER_ONE_NOT_FOUND_IN_TEST = 
    _id: 'mid-x' 
    type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
    ipid: 'ipid-x' # interesting point id
    original-content-type: 'text' # text | voice
    text-content: 'xxxxxx' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
    create-time: '2013-02-04 12:23:02'
    send-by: 'uid-8'
    permlink: 'http://at-plus.com/messages/mid-x' # 可收藏的永久链接  

