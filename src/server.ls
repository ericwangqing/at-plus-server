require! [express, http, path, jade, 'socket.io', 'connect', './database'
  './default-channel', './locations-channel', './config', './session-store']

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
  io.set 'log level', 1

  (db-connection) <-! database.get-db
  default-channel.init io, db-connection
  locations-channel.init io, db-connection

patch-socket-with-accross-namespaces-session = !->
  Socket = require 'socket.io/lib/socket.js'


  Socket.prototype.on = !(event, listener)->
    new-listener = !->
      debug "***************** capture #{event} at #{@.id} the session is: ", @session, " ***************"
      done = save-seesion = !~> # patched to each handler, need running at the end of handlers to save-session
        session-store.set @.id, @session, !(session)~>

      Array.prototype.push.call arguments, done
      new-arg = arguments

      if !@session
        session-store.get @.id, !(session)~>
          @session = session <<< {sid: @.id}
          listener.apply listener, new-arg
      else
        listener.apply listener, new-arg
        
    process.EventEmitter.prototype.on.call @, event, new-listener

patch-socket-with-accross-namespaces-session!

module.exports =
  start: !(done)->
    console.info "****************** start server **********************"
    configure-at-plus-server!
    initial-at-plus-server!
    server.http-server.listen port, ->
      console.info "at-plus is listening on port #{port}" 
      done! if done 
  shutdown: !->
    console.info "****************** close server **********************" 
    server.http-server.close!
