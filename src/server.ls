require! [express, http, path, jade, 'socket.io', 'connect',
  './locations-channel', './interesting-points-channel', './config', './session-store']

port = process.env.PORT or config.server.port 
 
server = null
socket-list = []
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


initial-at-plus-server = !(callback)->
  server.http-server = http.createServer server # 需要用http server包装一下，才能正确初始化socket.io
  io = socket.listen server.http-server
  # console.log "io: ", io
  # io.set 'close timeout', 0.01 

  io.on 'connection', (socket)->
    # ！！以下两方法用于测试，正式发布时应当去除
    track-socket socket
    <-! try-session-data socket
    try-socket-data socket

  locations-channel.init io, callback

track-socket = !(socket)->
  socket-list.push socket
  socket.on 'close', !->
    console.log "socket: #{socket.id} closed"
    socket-list.splice socket-list.index-of(socket), 1

try-session-data = !(socket, next)->
  (session) <-! session-store.get-session socket
  session.message = 'Good'
  session.save next

try-socket-data = !(socket)->
  socket.number = socket.number or Math.random!
  (session) <-! session-store.get-session socket
  socket.emit 'initial', 
    number: socket.number
    message: session.message

  socket.on 'request-1', !(data)->
    socket.emit 'request-1-answer', number: socket.number

module.exports =
  start: !(done)->
    console.log "****************** start server **********************"
    configure-at-plus-server!
    initial-at-plus-server ->
      server.http-server.listen port, ->
        console.log "at-plus is listening on port #{port}" 
        done! if done
  shutdown: !->
    console.log "****************** close server **********************" 
    for socket in socket-list
      socket.disconnect!
    server.http-server.close!
