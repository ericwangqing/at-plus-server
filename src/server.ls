require! [express, http, path, jade, 'socket.io', 'connect',
  './locations-channel', './interesting-points-channel', './config']

SessionSockets = require 'session.socket.io'

port = process.env.PORT or config.server.port 
cookie-parser = express.cookie-parser '@+ is awesome!' # 将来可替换
session-store = new connect.middleware.session.MemoryStore # 将来可换专门的Session Store for scale out or up

server = configure-at-plus-server!
initial-at-plus-server!
start-at-plus-server!
 
function configure-at-plus-server
  server = express!
  server.configure ->
    server.set 'port', port
    server.use express.favicon!
    server.use express.bodyParser!
    server.use express.methodOverride!
    server.use cookie-parser
    server.use express.session {
      # secret: 'awesome @+'
      # key: 'express.sid'
      store: session-store
    }
    server.use server.router
    server.use express.static __dirname 


  server.configure 'development', -> 
    server.use express.errorHandler!

server.get '/', !(req, res)-> # test page 
  res.sendfile __dirname + '/index.html'

function initial-at-plus-server
  server.http-server = http.createServer server # 需要用http server包装一下，才能正确初始化socket.io
  io = socket.listen server.http-server
  session-sockects = new SessionSockets io, session-store, cookie-parser

  # (err, data) <-! locations-channel.init session-sockects
  session-sockects.on 'connection', !(err, socket, session)->
    session.client = 'client1'
    session.save!
    socket.emit 'initial', session: client: session.client

    socket.on 'request-1', !(data)->
      socket.emit 'request-1-answer', session: client: session.client
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