'''
1) 所有channels都需要在on 'conncetion'，得到socket之后，在其request-initial方法中，注册业务handlers。
2) 所有client都需要在on 'connect', 得到socket之后，在其response-initial方法中，注册业务handler，并最后emit 'request-initial'，启动与server的交互。
参考：http://my.ss.sysu.edu.cn/wiki/pages/viewpage.action?pageId=215646217 （Server与Client（浏览器、手机端）监听器的注册顺序）
本helper就是帮助各channels，统一、安全地完成这一步骤。
'''
get-safe-config= (config)->
  safe-config! <<< config

get-safe-method = (method)->
  method or safe-method

safe-config = ->
  channel: null
  request-initial-handler: safe-method
  business-handlers-register: safe-method
  response-initial-handler: safe-method

safe-method = !->
    arguments[arguments.length - 1] null, null
  
module.exports = 

  # config:
  #   channel: # socket.io的namesapce对象，常常通过io.of('channel-name')获得。mandatory
  #   request-initial-handler: # 在这里处理初始化时，对session和socket的操作。不用恢复session，此时@+已经恢复了session。optional
  #   business-handlers-register: # 这个时最最重要的部分，所有的业务逻辑监听都在这里进行。optional
  #   response-initial-handler: # 在这里设定通过reponse-initial事件给回client的数据. optional

  server-channel-initial-wrapper: !(config)->
    config = get-safe-config config
    config.channel.on 'connection', !(socket)->
      (data, done) <-! socket.on 'request-initial'
      (err, result) <-! config.request-initial-handler socket, data 
      (err, result) <-! config.business-handlers-register socket, data # bussniess-handler、response-initial-handler可能都用不上data，加上data是为了API的整洁、漂亮
      (err, result) <-! config.response-initial-handler socket, data
      socket.emit 'response-initial', result
      done!


  # config:
  #   io: # socket.io提供，用于连接。mandatory
  #   url: # channel的url。mandatory
  #   business-handlers-register: # 这个时最最重要的部分，所有的业务逻辑监听都在这里进行。optional
  #   request-initial-data-getter: # 在这里设定通过repuest-initial事件发送给server的数据. optional

  client-channel-initial-wrapper: !(config)->
    client = config.io.connect config.url, config.options
    throw new Error "config MUST have url" if !config or !config.url

    <-! client.on 'connect'
    client.on 'response-initial', !(data)->
      (err, result) <-! (get-safe-method config.business-handlers-register) client, data 
    (err, result) <-! (get-safe-method config.resquest-initial-data-getter)
    client.emit 'request-initial', config.request-initial-data or {}
