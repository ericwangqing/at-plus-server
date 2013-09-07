require! [express, http, path, jade, 'socket.io', 'connect', 
  './default-channel', './locations-channel', './interesting-points-channel', './chats-channel', 
  './users-channel', './config', './session-store']

debug = require('debug')('at-plus')

port = process.env.PORT or config.server.port 
 
server = null
configure-at-plus-server = !->
  server := express!
  session-store.config config.session-store
  server.configure ->
    server.set 'port', port
    server.use server.router
    server.use express.static __dirname 

  # server.configure 'development', -> 
  #   server.use express.errorHandler!

  server.get '/', !(req, res)-> # test page 
    res.sendfile __dirname + '/index.html'

initial-at-plus-server = !->
  server.http-server = http.createServer server # 需要用http server包装一下，才能正确初始化socket.io
  io = socket.listen server.http-server
  # io.set 'log level', 1

  default-channel.init io
  locations-channel.init io
  users-channel.init io
  interesting-points-channel.init io
  chats-channel.init io

patch-socket-with-accross-namespaces-session = !->
  Socket = require 'socket.io/lib/socket.js'
  Socket.prototype.on = !(event, listener)->
    new-listener = !->
      debug "***************** capture #{event} at #{@.id} **********************"
      if !@session
        session-store.get-session @, !(err, result)~>
          if err
            console.log "can't get session for #{@id}, error: ", err
          else
            debug "result: ", result
            @session = result
      debug "socket #{@id} session is: ", @session
      listener.apply listener, arguments
    process.EventEmitter.prototype.on.call @, event, new-listener

patch-socket-with-accross-namespaces-session!

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
