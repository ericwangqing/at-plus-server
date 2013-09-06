require! './channels-helper'
module.exports = 
  init: !(io)->
    channels-helper.channel-initial-wrapper {
      io: io

      request-initial-hanlder: !(socket, data, callback)->
        sid = data?.sid
        socket.session.restore-previous sid, callback

      response-initial-data-getter: !(socket, data, callback)->
        callback {
          sid: socket.session.sid or socket.id
          message: socket.session.message
        }

      business-handlers: !(socket, data, callback)->
        for-session-testing socket
        callback!
    }

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
