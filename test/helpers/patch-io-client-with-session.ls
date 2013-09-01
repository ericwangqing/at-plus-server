# 给socket.io-client打补丁，以实现cookie-based session

require! 'request'
j = null
# intial request to trigger express connect session
initial-session = !(j, url, callback)->
  request.get {
    jar: j 
    url: url
    }, !(err, resp, body)->
      if err
        console.log err 
      else
        callback!


module.exports =
  patch-io-client-with-session: !(base-url, callback)->
    j := request.jar!
    old-request = require('socket.io-client/node_modules/xmlhttprequest').XMLHttpRequest 

    #patch it!
    require('socket.io-client/node_modules/xmlhttprequest').XMLHttpRequest = !->
      old-request.apply this, arguments
      # this.setDisableHeaderCheck true 
      # xmlhttprequest 1.5才有setDisableHeaderCheck方法，socket.io 1.0会用它，但是还没有发布。在发布后，可以用这个方法，
      # 现在要去改xmlhttprequest.js的源码（注释掉forbiddenRequestHeaders中的cookie）
      
      old-open = this.open
      this.open = !->
        old-open.apply this, arguments
        cookie =  j.get {url: base-url}
          .map (c)->
            c.name + "=" + c.value
          .join "; "
        this.setRequestHeader('cookie', cookie)
        console.log "set cookie when open: ", cookie

    initial-session @j, base-url, callback


    reset-session: !(callback)->
      j := request.jar!
      initial-session @j, base-url, callback