console.log 'get it'

BASE_URL = 'http://localhost:3000'

socket = io.connect BASE_URL
do
  (data) <-! socket.on 'ask-location' 
  console.log "socket on ask-location get:", data
  socket.emit 'answer-location', {web-url: window.href, world-position: null}
  console.log "socket emit answer-location"

do  
  (data) <-! socket.on 'at-plus-server-ready'
  console.log "socket on channels-ready get:", data
  interesting-points = io.connect BASE_URL + '/interesting-points'
  
  do
    (data) <-! interesting-points.on 'connect'
    console.log "interesting-points on connect get:", data
    interesting-points.emit 'hi!'
    console.log "interesting-points emit hi" 
 

