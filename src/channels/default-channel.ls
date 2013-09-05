require! './session-store'

try-session-data = !(socket, next)->
  socket.session.message = socket.number or Math.random!
  socket.session.save next

try-socket-data = !(socket)->
  socket.number = socket.number or Math.random!
  socket.emit 'initial', 
    number: socket.number
    message: socket.session.message

  socket.on 'request-1', !(data)->
    socket.emit 'request-1-answer', number: socket.number

module.exports = 
  init: !(io)->
    io.on 'connection', !(socket)->
      # ！！以下两方法用于测试，正式发布时应当去除
      <-! try-session-data socket  
      try-socket-data socket
      # console.log 'default channel connected'
      # socket.emit 'a default message', {everyone: 'in', '/': 'will get'}


