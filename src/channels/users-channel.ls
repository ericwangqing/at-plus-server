module.exports  = 

	init: !(io, db)->
		io.of('/users-channel').on 'connection', !(socket)->
			console.log 'users-channel connected'
			socket.emit 'a message', {everyone: 'in', '/users': 'will get'}

