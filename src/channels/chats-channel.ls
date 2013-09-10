module.exports  = 

	init: !(io, db)->
		io.of('/chats-channel').on 'connection', !(socket)->
			console.info 'chats-channel connected'
			socket.emit 'a message', {everyone: 'in', '/chats': 'will get'}

