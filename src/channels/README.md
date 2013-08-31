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
  
请求将现实世界的座标或者网络世界的URL解析成为@+的location，包括：
1. 将现实时间经纬高度归并为真实地址和位置（在地址中的偏移量）
1. 将Cyberspace的URL归并为Cyberspace中的位置。@+以最终用户可见的主要内容为准进行判断，相同主要内容为同一位置。对于Web，包括以下情况：
  * 主要内容是指当前域名所提供的内容，不考虑第三方，例如广告、mashup等内容
   

  