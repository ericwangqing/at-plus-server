require 'socket.io-client'
locations-channel-url = 'http://0.0.0.0:3000/locations'

options = 
  transports: ['websocket'] 
  'force new connection': true

can = it # it在LiveScript中被作为缺省的参数，因此我们先置换为can

