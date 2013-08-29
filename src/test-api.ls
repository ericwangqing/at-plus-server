BASE_URL = 'http://localhost:3000'

# socket = io.connect BASE_URL
# do
#   (data) <-! socket.on 'ask-location' 
#   console.log "socket on ask-location get:", data
#   console.log 'location.href: ', location.href
#   socket.emit 'answer-location', {url: location.href}
#   console.log "socket emit answer-location"

# do  
#   (data) <-! socket.on 'at-plus-server-ready'
#   console.log "socket on channels-ready get:", data
#   interesting-points = io.connect BASE_URL + '/interesting-points'
  
#   do
#     (data) <-! interesting-points.on 'connect'
#     console.log "interesting-points on connect get:", data
#     interesting-points.emit 'hi!'
#     console.log "interesting-points emit hi" 
 

client1 = io.connect BASE_URL

client1.on 'initial', !(data)->
  console.log 'data: ', data
  client1.emit 'request-1', null 

client1.on 'request-1-answer', !(data)->
  console.log 'data: ', data
