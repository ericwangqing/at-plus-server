require! './interesting-points-manager'
locations-manager = 
  init: (io, callback)->
    (socket) <-! io.sockets.on 'connection'
    console.log 'locations-manager: connected'
    socket.emit 'ask-location'
    (data) <-! socket.on 'answer-location'
    console.log 'answer-location:', data
    (error, interesting-points) <-! interesting-points-manager.get-interesting-points location 
    socket.emit 'server-error', "can't get interesting points" if error
    socket.emit 'interesting-points', interesting-points
    callback error, data

module.exports <<< locations-manager
