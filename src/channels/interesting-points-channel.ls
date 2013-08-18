interesting-points-manager = 
	init: (location, user, io)->
		interesting-points = io.of('/interesting-points')
		
		interesting-points.on 'connection', !(socket)->
			console.log 'interesting-points connected'
			socket.emit 'a message', {everyone: 'in', '/interesting-points': 'will get'}

module.exports <<< interesting-points-manager  