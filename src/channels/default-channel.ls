module.exports = 
  init: !(io)->
    default-channel = io.on 'connection', !(socket)->
      socket.on 'request-initial', (data)->
        sid = data?.sid
        (err, result) <-! socket.session.restore-previous sid

        socket.emit 'response-initial', 
          sid: socket.session.sid or socket.id
          message: socket.session.message
          # friends: user-manager.get-all-friends socket.session.uid
          # hots: interesting-manager.get-hots
          # circls: interesting-manager.get-circls-updates socket.session.uid
          # listens: 
          #   users-updates: interesting-manager.get-users-updates user-manager.get-listened-users sockect.session.uid
          #   interesting-points-updates: interesting-manager.get-listend-interesting-points-updates
          # history: interesting-manager.get-my-history socket.session.uid

      for-session-testing socket
      socket.emit 'ready',  
        message: 'locations-channel initialized, ready for events' 


for-session-testing = !(socket)->  # these handler are used in session-testing, and should be removed in future
  <-! try-session-data socket  
  try-socket-data socket
    # socket.emit 'a default message', {everyone: 'in', '/': 'will get'}

try-session-data = !(socket, next)->
  socket.session.message = socket.session.message or Math.random!
  socket.session.save next

try-socket-data = !(socket)->
  socket.number = socket.number or Math.random!
  socket.emit 'initial',  
    number: socket.number
    message: socket.session.message

  socket.on 'request-1', !(data)->
    socket.emit 'request-1-answer', number: socket.number
