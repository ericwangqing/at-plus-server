users =
  xiaodong =
    _id: 'uid-1'
    username: '小东'
    password: 'xxxxxxxx' # sha1 加密之后
    gender: 'F' # M | F | U (不确定)
    emails: # emails[0]为主email
      'xiaodong@some.com'
      ...
    avatars: # avatars[0]是当前使用的。
      '/avatars/u/uid-1/2' # u开头是用户上传的，资源为：http://at-plus-server/avatars/u/uid/2
      '/avatars/u/uid-1/1' # 资源为：http://at-plus-server/avatars/u/uid/2
      '/avatars/s/1'     # s开头是系统提供的资源为：http://at-plus-server/avatars/s/1
    signatures: # signatures[0]为当前使用的
      '彪悍的人生不需要解释'
      ...
    circles:
      * cid: 'cid-1'
        name: '@+小组'
      * cid: 'cid-2'
        name: '现代互联网应用俱乐部'
    friends: # friends是双向的
      'uid-3'
      'uid-2'
      * 大学同学: ['uid-3', 'uid-4'] # ‘大学同学’就是group的id，gid
        _weibo: ['昵称1', '昵称2'] # 用户在微博上的好友，下划线开头的，不是用户自定义的group，是系统分组
    follows:['uid-5', 'uid-6'] # follow是单向的
    third-part-accounts:
      * type: 'weibo' # weibo | qq | ……
        api-url: 'http://weibo.com/api'
        account-name: '小东微博'
        token: 'TOKEN_FOR_AUTHENTICATION'
      ...
    created-interesting-points: # !!derived from interesting point
      * ip-id: 'ipid-1'
        last-access-time: '2013-04-02 22:11:04'
      * ip-id: 'ipid-2'
        last-access-time: '2013-04-02 22:12:04'
    attended-interesting-points:  # !!derived from interesting point and message
      * ip-id: 'ipid-3'
        last-access-time: '2013-04-02 22:11:04'
      * ip-id: 'ipid-4'
        last-access-time: '2013-04-02 22:12:04'
    watching-interesting-points: # !!derived from interesting point and message
      * ip-id: 'ipid-5'
        last-access-time: '2013-04-02 22:11:04'
      * ip-id: 'ipid-6'
        last-access-time: '2013-04-02 22:12:04'
    unwatching-interesting-points: ['ipid-7', 'ipid-8'] # 曾经关注，但是现在取消了的。用于恢复关注。
    join-chats:  # !!derived from chat
      * cid: 'cid-1'
        last-access-time: '2013-04-02 22:11:04'
      * cid: 'cid-2'
        last-access-time: '2013-04-02 22:12:04'
    leave-chats: ['cid-3', 'cid-4'] # 曾经参加，但是现在退出了的。

  baixin =
    _id: 'uid-2'
    username: '柏信'
    password: 'xxxxxxxx' # sha1 加密之后
    gender: 'F' # M | F | U (不确定)
    emails: # emails[0]为主email
      'baixin@some.com'
      ...
    avatars: # avatars[0]是当前使用的。
      '/avatars/u/uid-2/1' # 资源为：http://at-plus-server/avatars/u/uid/2
      '/avatars/s/1'     # s开头是系统提供的资源为：http://at-plus-server/avatars/s/1
    signatures: # signatures[0]为当前使用的
      '彪悍的人生不需要解释'
      ...
    circles:
      * cid: 'cid-1'
        name: '@+小组'
      ...
    friends: ['uid-1']# friends是双向的
    follows:['uid-5'] # follow是单向的
    created-interesting-points: # !!derived from interesting point
      * ip-id: 'ipid-3'
        last-access-time: '2013-04-02 22:11:04'
      ...
    attended-interesting-points:  # !!derived from interesting point and message
      * ip-id: 'ipid-1'
        last-access-time: '2013-04-02 22:11:04'
      * ip-id: 'ipid-3'
        last-access-time: '2013-04-02 22:12:04'
    watching-interesting-points: # !!derived from interesting point and message
      * ip-id: 'ipid-6'
        last-access-time: '2013-04-02 22:12:04'
      ...
    unwatching-interesting-points: ['ipid-7'] # 曾经关注，但是现在取消了的。用于恢复关注。
    join-chats:  # !!derived from chat
      * cid: 'cid-1'
        last-access-time: '2013-04-02 22:11:04'
      ...

  wangyu =
    _id: 'uid-3'
    username: '王瑜'
    password: 'xxxxxxxx' # sha1 加密之后
    gender: 'M' # M | F | U (不确定)
    emails: # emails[0]为主email
      'wangyu@some.com'
      ...
    avatars: # avatars[0]是当前使用的。
      '/avatars/s/1'     # s开头是系统提供的资源为：http://at-plus-server/avatars/s/1
      ...
    friends: # friends是双向的
      'uid-1'
    follows:['uid-5'] # follow是单向的
    attended-interesting-points:  # !!derived from interesting point and message
      * ip-id: 'ipid-3'
        last-access-time: '2013-04-02 22:12:04'
      ...

  u4 =
    _id: 'uid-4'
    username: 'User 4'
    password: 'xxxxxxxx' # sha1 加密之后
    gender: 'M' # M | F | U (不确定)
    emails: # emails[0]为主email
      'u4@some.com'
      ...
    avatars: # avatars[0]是当前使用的。
      '/avatars/s/1'     # s开头是系统提供的资源为：http://at-plus-server/avatars/s/1
      ...
    attended-interesting-points:  # !!derived from interesting point and message
      * ip-id: 'ipid-1'
        last-access-time: '2013-04-02 22:12:04'
      * ip-id: 'ipid-2'
        last-access-time: '2013-04-02 22:12:04'

  u5 =
    _id: 'uid-5'
    username: 'User 5'
    password: 'xxxxxxxx' # sha1 加密之后
    gender: 'M' # M | F | U (不确定)
    emails: # emails[0]为主email
      'u5@some.com'
      ...
    avatars: # avatars[0]是当前使用的。
      '/avatars/s/1'     # s开头是系统提供的资源为：http://at-plus-server/avatars/s/1
      ...

  u8 =
    _id: 'uid-8'
    username: 'User 8'
    password: 'xxxxxxxx' # sha1 加密之后
    gender: 'M' # M | F | U (不确定)
    emails: # emails[0]为主email
      'u8@some.com'
      ...
    avatars: # avatars[0]是当前使用的。
      '/avatars/s/1'     # s开头是系统提供的资源为：http://at-plus-server/avatars/s/1
      ...
    attended-interesting-points:  # !!derived from interesting point and message
      * ip-id: 'ipid-1'
        last-access-time: '2013-04-02 22:12:04'
      * ip-id: 'ipid-2'
        last-access-time: '2013-04-02 22:12:04'
      * ip-id: 'ipid-3'
        last-access-time: '2013-04-02 22:12:04'


  OTHER_ONE_NOT_FOUND_IN_TEST =
    _id: 'uid-x'
    username: '不会在测试中被发现的人'
    password: 'xxxxxxxx' # sha1 加密之后
    gender: 'M' # M | F | U (不确定)
    emails: # emails[0]为主email
      'mr-invisible@some.com'
      ...
    avatars: # avatars[0]是当前使用的。
      '/avatars/s/1'     # s开头是系统提供的资源为：http://at-plus-server/avatars/s/1
      ...


