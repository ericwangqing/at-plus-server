Locations Channel Protocol
====
![image](http://)
Server Client    
ask resolving location 
                         
answer resolved location =>

                         <= ask locations interesting points
answer locations interesting points =>

Details
----
### ask resolving location

API: client-socket.emit 'ask resolving location', type, data 
type: 
  source: web | real
  is-private: true | false

data: coordinate | url

coordinate: {longitude: 111, latitude: 222, altitude: 333 # nullable}
url: 
  


  