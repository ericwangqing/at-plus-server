'''
1) 所有channels都需要在on 'conncetion'，得到socket之后，在其request-initial方法中，注册业务handlers。
2) 所有client都需要在on 'connect', 得到socket之后，在其response-initial方法中，注册业务handler，并最后emit 'request-initial'，启动与server的交互。
参考：http://my.ss.sysu.edu.cn/wiki/pages/viewpage.action?pageId=215646217 （Server与Client（浏览器、手机端）监听器的注册顺序）
本helper就是帮助各channels，统一、安全地完成这一步骤。
'''
get-safe-obj= (obj)->
  safe-obj! <<< obj

get-safe-method = (method)->
  method or safe-method

safe-obj = ->
  io: null
  request-initial-hanlder: safe-method
  business-handlers: safe-method
  response-initial-data-getter: safe-method

safe-method = !->
    arguments[arguments.length - 1] null, null
  
module.exports = 
  channel-initial-wrapper: !(obj)->
    obj = get-safe-obj obj
    obj.io.on 'connection', !(socket)->
      (data) <-! socket.on 'request-initial'
      (err, result) <-! obj.request-initial-hanlder socket, data 
      (err, result) <-! obj.business-handlers socket, data # bussniess-handler、response-initial-data-getter可能都用不上data，加上data是为了API的整洁、漂亮
      (err, result) <-! obj.response-initial-data-getter socket, data
      socket.emit 'response-initial', result

  client-initial-wrapper: !(obj)->
    client = obj.io.connect obj.url, obj.options
    throw new Error "obj MUST have url" if !obj or !obj.url

    <-! client.on 'connect'
    client.on 'response-initial', !(data)->
      (err, result) <-! (get-safe-method obj.business-handlers) client, data 
    (err, result) <-! (get-safe-method obj.resquest-initial-data-getter)
    client.emit 'request-initial'

