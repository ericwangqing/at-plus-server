require! ['./channel-initial-wrapper', './session-store']
module.exports = 
  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io

      response-initial-handler: !(socket, data, callback)->
        # socket.session.message = 'hello'
        callback err = null, {
          sid: socket.id
          message: socket.session.message or 'hello'
        }

      business-handlers-register: !(socket, data, callback)->
        socket.on 'change-session-request', !(data, save-session)->
          socket.session.message = 'world'
          save-session!
          socket.emit 'change-session-response', null
        callback err = null, {
        }
    }


