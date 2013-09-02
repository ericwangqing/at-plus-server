require! ['./interesting-points-manager', './session-store']
locations-manager = 
  init: (io, callback)->
    do
      (socket) <-! io.of('/locations').on 'connection'
      console.info 'locations channel connected'
      (session) <-! session-store.get-session socket
      socket.emit 'ready', message: session.message
    callback!


module.exports <<< locations-manager 
