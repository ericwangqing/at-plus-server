require! ['./interesting-points-manager']
module.exports  = 
  init: !(io)->
    io.of('/locations').on 'connection', !(socket)->
      for-session-testing socket

function for-session-testing socket  # these handler are used in session-testing, and should be removed in future
  socket.number = socket.number or Math.random!
  # console.log 'locations channel connected'
  socket.session.message = socket.session.message or Math.random!
  <-! socket.session.save
  socket.on 'request-1', !(data)->
    socket.emit 'request-1-answer',
      message: socket.session.message
      number: socket.number

  socket.emit 'ready',  
    message: socket.session.message 
    number: socket.number 
