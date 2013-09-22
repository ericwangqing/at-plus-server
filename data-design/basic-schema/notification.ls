notification =
  _id: 'xxxx'
  type: 'unread-chat' # unread-chat | friend-request | system | ……
  from: ['uid-4'] # system 消息时为 'system'
  to: ['uid-1', 'cid-1']
  message: '''
      你的好友<a href="http://at-plus.com/users/xxx">张三</a>
      给你发了<a href="http://at-plus.com/messages/xxx">消息</a>
    ''' 