require! './interesting-points-manager'
locations-manager = 
  init: (io, callback)->
    (socket) <-! io.of('/locations').on 'connection'
    console.info 'locations channel connected'
    socket.emit 'ready', message: 'ready'


module.exports <<< locations-manager 
