module.exports  = 

	init: !(io)->
		chats-channel = io.of('/chats-channel')
		
		chats-channel.on 'connection', !(socket)->
			console.log 'chats-channel connected'
			socket.emit 'a message', {everyone: 'in', '/chats': 'will get'}

