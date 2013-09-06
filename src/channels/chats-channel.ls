module.exports  = 

	init: !(io)->
		io.of('/chats-channel').on 'connection', !(socket)->
			console.log 'chats-channel connected'
			socket.emit 'a message', {everyone: 'in', '/chats': 'will get'}

