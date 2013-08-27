require! [express, http, 'socket.io', 
  './locations-channel', './interesting-points-channel', './config']

port = process.env.PORT or config.server.port 
server = configure-at-plus-server!
initial-at-plus-server!
start-at-plus-server!
 
function configure-at-plus-server
  server = express!
  server.configure ->
    server.set 'port', port
    server.use express.favicon!
    server.use express.bodyParser!
    server.use express.static __dirname 
  
  server.configure 'development', -> 
    server.use express.errorHandler!

function initial-at-plus-server
  server.http-server = http.createServer server # 需要用http server包装一下，才能正确初始化socket.io
  io = socket.listen server.http-server

  locations-channel.init io
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