require! './session-store'

module.exports =
  patch-socket-with-accross-namespaces-session: !->
    Socket = require 'socket.io/lib/socket.js'


    Socket.prototype.on = !(event, listener)->
      new-listener = !->
        debug "***************** capture #{event} at #{@.id} the session is: ", @session, " ***************"
        done = save-seesion = !~> # patched to each handler, need running at the end of handlers to save-session
          session-store.set @.id, @session, !(session)~>

        Array.prototype.push.call arguments, done
        new-arg = arguments

        if !@session
          session-store.get @.id, !(session)~>
            @session = session <<< {sid: @.id}
            listener.apply listener, new-arg
        else
          listener.apply listener, new-arg
          
      process.EventEmitter.prototype.on.call @, event, new-listener
