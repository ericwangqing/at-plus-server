module.exports = 
	init: !(io)->
		io.of('/interesting-points').on 'connection', !(socket)->
			console.log 'interesting-points connected'
			socket.emit 'a message', {everyone: 'in', '/interesting-points': 'will get'}

