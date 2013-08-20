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
  friends:
    * 'uid-1'
    * 'uid-2'
    * group1: ['uid-3', 'uid-4']

