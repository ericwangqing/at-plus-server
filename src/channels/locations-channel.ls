require! ['./interesting-points-manager', './session-store']
locations-manager = 
  init: (io, callback)->
    (socket) <-! io.of('/locations').on 'connection'
    console.info 'locations channel connected'
    (session) <-! session-store.get-session socket
    socket.emit 'ready', message: session.message


module.exports <<< locations-manager 
