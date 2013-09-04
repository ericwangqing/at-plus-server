module.exports = 
	init: !(io)->
		interesting-points-channel = io.of('/interesting-points')
		
		interesting-points-channel.on 'connection', !(socket)->
			console.log 'interesting-points connected'
			socket.emit 'a message', {everyone: 'in', '/interesting-points': 'will get'}

