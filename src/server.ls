require! [express, http, path, jade, 'socket.io', 'connect',
  './locations-channel', './interesting-points-channel', './config']

SessionSockets = require 'session.socket.io'

port = process.env.PORT or config.server.port 

server = configure-at-plus-server!
initial-at-plus-server!
start-at-plus-server!
 
function configure-at-plus-server
  server = express!
  server.configure ->
    server.set 'port', port
    server.use server.router
    server.use express.static __dirname 

  server.configure 'development', -> 
    server.use express.errorHandler!

server.get '/', !(req, res)-> # test page 
  res.sendfile __dirname + '/index.html'

function initial-at-plus-server
  server.http-server = http.createServer server # 需要用http server包装一下，才能正确初始化socket.io
  io = socket.listen server.http-server

  io.on 'connection', (socket)->
    try-session-for-testing socket

  locations-channel.init io


function try-session-for-testing socket
  socket.client = socket.client or Math.random!
  socket.emit 'initial', session: client: socket.client

  socket.on 'request-1', !(data)->
    socket.emit 'request-1-answer', session: client: socket.client
  # users-channal.init io
  # interesting-points-channel.init io
  # circles-channel.init io
  # nitification-channel.init io
  # do
  #   (location) <-! locations-channel.init io
  #   # (user) <-! users-channel.init io, location
  #   interesting-points-channel.init location, user = null, io 
  #   # chats-channel.init location, user, io
  #   # notifications-channel.init location, user, io

function start-at-plus-server
  server.http-server.listen port, ->
    console.log "at-plus is listening on port #{port}"  