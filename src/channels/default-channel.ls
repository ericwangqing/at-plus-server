require! './channels-helper'
module.exports = 
  init: !(io)->
    channels-helper.channel-initial-wrapper {
      channel: io

      session-socket-handler: !(socket, data, callback)->
        console.log "default-channel handles session and socket, socket id: #{socket.id}, socket session: ", socket.session
        socket.number = socket.number or Math.random!

        if data and  data.sid
          socket.session.restore-previous socket, callback
        else
          socket.session.message = socket.session.message or Math.random!
          socket.session.save callback

      response-initial-data-getter: !(socket, data, callback)->
        callback err = null, {
          sid: socket.session.sid or socket.id
          number: socket.number
          message: socket.session.message
        }

      business-handlers: !(socket, data, callback)->
        console.log 'server handle business'
        for-session-testing socket, callback
    }

for-session-testing = !(socket, callback)->  # these handler are used in session-testing, and should be removed in future
  try-socket-data socket, callback
    # socket.emit 'a default message', {everyone: 'in', '/': 'will get'}

try-socket-data = !(socket, callback)->
  socket.on 'request-1', !(data)->
    socket.emit 'request-1-answer', number: socket.number
    console.log 'server emit request-1-answer'
  callback!

