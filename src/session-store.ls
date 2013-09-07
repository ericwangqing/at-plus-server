'''
在同一用户连接多个channels时，保持跨channels的session。可以配置为in-memory，或者redis的。当为redis的时候，需要先运行redis服务器。
'''

require! redis

session-store-type = 'in-momery'
redis-store = null
in-momery-session-store = {}

Session = (@sid)->


Session.prototype.save = !(callback)->
  console.log "session stored: ", @
  if session-store-type is 'redis'
    redis-store.set @sid, (JSON.stringify @), !(err, result)->
      if err
        console.log "can't save key: #{@sid}, value: #{JSON.stringify session} to redis with err: ", err
      callback err, result
  else if session-store-type is 'in-momery'
    in-momery-session-store[@sid] = @
    console.log 'in-momery-session-store: ', in-momery-session-store
    callback null, null

Session.prototype.restore-previous = !(socket, callback)->
  previous-socket-id = socket.id
  if session-store-type is 'redis'
      if not previous-socket-id
        callback!
      else 
        redis-store.get previous-socket-id, !(err, result)~>
          if err
            console.log "can't find previous session #{previous-socket-id} from redis, with err: ", err
            callback err, result
          else if not result
            callback!
          else
            @ <<< JSON.parse(result)
            (err, result) <-! redis-store.set @sid, (JSON.stringify @) 
            if err
              callback err, result
            else
              (err, result) <-! redis-store.del previous-socket-id
              if err
                callback err, result
              else
                console.log "session restored successful: ", @
                callback null, null
  else if session-store-type is 'in-momery'
    if previous-socket-id
      @ <<< in-momery-session-store[@.sid] = in-momery-session-store[previous-socket-id]
      delete in-momery-session-store[previous-socket-id]
    callback null, null

module.exports = 
  config: !(cfg)->
    if cfg.session-store-type in ['in-momery', 'redis']
      session-store-type := cfg.session-store-type
    redis-store := redis.create-client() if cfg.session-store-type is 'redis'

  get-session: !(socket, callback)-> # sid likes cookie, which is stored by client, and provide in request. It is used to implement peresist session across multiple running of the client.
    if socket.session
      console.log "the session of the socket: #{socket.id} already exist: ", socket.session
      callback null, socket.session
    else
      console.log "the session of the socket: #{socket.id} doesn't exist, create a new one"
      if session-store-type is 'redis'
        redis-store.get session.sid, !(err, result)->
          if err
            console.log "can't retrive #{@sid} from redis, with err: ", err
            callback err, result
          else
            session = new Session socket.id
            session <<< ((JSON.parse result) or {})
            callback null, session
      else if session-store-type is 'in-momery'
        if in-momery-session-store[socket.id]
          console.log 'old session in session-store exist: ', in-momery-session-store[socket.id]
          callback null, in-momery-session-store[socket.id]
        else
          callback null, in-momery-session-store[socket.id] = new Session socket.id
