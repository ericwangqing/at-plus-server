require! [express, http, path, jade, 'socket.io', 'connect',
  './default-channel', './locations-channel', './interesting-points-channel', './chats-channel', 
  './users-channel', './config', './session-store']

port = process.env.PORT or config.server.port 
 
server = null
configure-at-plus-server = !->
  server := express!
  session-store.config config.session-store
  server.configure ->
    server.set 'port', port
    server.use server.router
    server.use express.static __dirname 

  server.configure 'development', -> 
    server.use express.errorHandler!

  server.get '/', !(req, res)-> # test page 
    res.sendfile __dirname + '/index.html'

initial-at-plus-server = !->
  server.http-server = http.createServer server # 需要用http server包装一下，才能正确初始化socket.io
  io = socket.listen server.http-server
  io.set 'log level', 1

  default-channel.init io
  locations-channel.init io
  users-channel.init io
  interesting-points-channel.init io
  chats-channel.init io

patch-io-socket-with-accross-namespaces-session =!-> 
  SocketNamespace = require 'socket.io/lib/namespace.js'  
  SocketNamespace.prototype.on = !(event, listener)->
    if event is 'connection'
      new-listener = !->
        socket = arguments[0]
        args = arguments
        session-store.get-session socket, !(err, session)->
          if err
            console.log "can't get session: ", err
            socket.session = {}
          else
            socket.session = session
          listener.apply listener, args
    else
      new-listener = listener
    process.EventEmitter.prototype.on.call this, event, new-listener

patch-io-socket-with-accross-namespaces-session!

module.exports =
  start: !(done)->
    console.info "****************** start server **********************"
    configure-at-plus-server!
    initial-at-plus-server!
    server.http-server.listen port, ->
      console.log "at-plus is listening on port #{port}" 
      done! if done 
  shutdown: !->
    console.info "****************** close server **********************" 
    server.http-server.close!
