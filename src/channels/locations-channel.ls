require! ['./interesting-points-manager', './session-store']
locations-manager = 
  init: (io, callback)->
    do
      (socket) <-! io.of('/locations').on 'connection'
      socket.number = socket.number or Math.random!
      console.info 'locations channel connected'
      (session) <-! session-store.get-session socket
      session.message = session.message or Math.random!
      <-! session.save
      socket.on 'request-1', !(data)->
        socket.emit 'request-1-answer',
          message: session.message
          number: socket.number

      socket.emit 'ready', 
        message: session.message
        number: socket.number

    callback!


module.exports <<< locations-manager 
