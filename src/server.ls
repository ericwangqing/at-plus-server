require! [express, http, path, jade, 'socket.io', 'connect', './database', './patchs'
  './default-channel', './interesting-points-channel', './users-channel', './config', './session-store']

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
  interesting-points-channel.init io
  users-channel.init io

patchs.patch-socket-with-accross-namespaces-session!

module.exports =
  start: !(done)->
    if not process.env.SERVER_ALREADY_RUNNING
      console.info "\n****************** start server **********************"
      configure-at-plus-server!
      initial-at-plus-server!
      server.http-server.listen port, ->
        console.info "at-plus is listening on port #{port}" 
        done! if done 
    else
      done! if done
  shutdown: !->
    if not process.env.SERVER_ALREADY_RUNNING
      console.info "****************** close server **********************" 
      server.http-server.close!
