require! ['./interesting-points-manager', './channel-initial-helper']
module.exports  = 
  init: !(io)->
    channel-initial-helper.server-channel-initial-wrapper {
      channel: io.of('/locations')

      session-socket-handler: !(socket, data, callback)->
        socket.number = socket.number or Math.random!
        socket.session.message = socket.session.message or Math.random!
        callback!

      response-initial-data-getter: !(socket, data, callback)->
        callback {
          message: socket.session.message
          number: socket.number 
        }

      business-handlers: !(socket, data, callback)->
        for-session-testing socket, callback
    }

for-session-testing = !(socket, callback)->  # these handler are used in session-testing, and should be removed in future
  # console.log 'locations channel connected'
  socket.on 'request-1', !(data)->
    socket.emit 'request-1-answer',
      message: socket.session.message
      number: socket.number
  callback!
