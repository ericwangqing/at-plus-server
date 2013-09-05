require! ['./interesting-points-manager', './session-store']
module.exports  = 
  init: !(io)->
    locations-channel = io.of('/locations')

    locations-channel.on 'connection', !(socket)->
      socket.number = socket.number or Math.random!
      console.info 'locations channel connected'
      socket.session.message = socket.session.message or Math.random!
      <-! socket.session.save
      socket.on 'request-1', !(data)->
        socket.emit 'request-1-answer',
          message: socket.session.message
          number: socket.number

      socket.emit 'ready', 
        message: socket.session.message
        number: socket.number 

