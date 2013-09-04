module.exports  = 

	init: !(io)->
		users-channel = io.of('/users-channel')
		
		users-channel.on 'connection', !(socket)->
			console.log 'users-channel connected'
			socket.emit 'a message', {everyone: 'in', '/users': 'will get'}

