user =
  _id: 'xxxx'
  username: '张三'
  password: 'xxxxxxxx' # sha1 加密之后
  gender: 'F' # M | F | U (不确定)
  emails: # emails[0]为主email
    'zhangsan@some.com'
    ...
  avatars: # avatars[0]是当前使用的。
    'u/uid/2' # u开头是用户上传的，资源为：http://at-plus-server/avatars/u/uid/2
    'u/uid/1' # 资源为：http://at-plus-server/avatars/u/uid/2
    's/1'     # s开头是系统提供的资源为：http://at-plus-server/avatars/s/1
  signatures: # signatures[0]为当前使用的
    '彪悍的人生不需要解释'
    ...
  circles:
    * cid: 'cid-1'
      name: '@+小组'
    * cid: 'cid-2'
      name: '现代互联网应用俱乐部'
  friends: # friends是双向的
    'uid-1'
    'uid-2'
    * 大学同学: ['uid-3', 'uid-4']
      _weibo: ['昵称1', '昵称2'] #用户在微博上的好友
  follows:['uid-5', 'uid-6'] # follow是单向的
  social-accounts:
    * type: 'weibo' # weibo | qq | ……
      api-url: 'http://weibo.com/api'
      account-name: '张三微博'
      token: 'TOKEN_FOR_AUTHENTICATION'
    ...
  created-interesting-points: # !!derived from interesting point
    * ip-id: 'iid-1'
      last-read-message-time: '2013-04-02 22:11:04'
    * ip-id: 'iid-2'
      last-read-message-time: '2013-04-02 22:12:04'
  attended-interesting-points: ['iid-3', 'iid-4'] # !!derived from interesting point and message
    * ip-id: 'iid-3'
      last-read-message-time: '2013-04-02 22:11:04'
    * ip-id: 'iid-4'
      last-read-message-time: '2013-04-02 22:12:04'
  watching-interesting-points: ['iid-5', 'iid-6'] # !!derived from interesting point and message
    * ip-id: 'iid-5'
      last-read-message-time: '2013-04-02 22:11:04'
    * ip-id: 'iid-6'
      last-read-message-time: '2013-04-02 22:12:04'
  unwatching-interesting-points: ['iid-7', 'iid-8'] # 曾经关注，但是现在取消了的。用于恢复关注。
  join-chats: ['cid-1', 'cid-2'] # !!derived from chat
    * cid: 'cid-1'
      last-read-message-time: '2013-04-02 22:11:04'
    * cid: 'cid-2'
      last-read-message-time: '2013-04-02 22:12:04'
  leave-chats: ['cid-3', 'cid-4'] # 曾经参加，但是现在退出了的。