require! ['./interesting-points-manager', './session']
locations-manager = 
  init: (io, callback)->
    (socket) <-! io.of('/locations').on 'connection'
    console.info 'locations channel connected'
    socket.emit 'ready', message: (session.get-session socket).message


module.exports <<< locations-manager 
