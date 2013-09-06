'''
在同一用户连接多个channels时，保持跨channels的session。可以配置为in-memory，或者redis的。当为redis的时候，需要先运行redis服务器。
'''

require! redis

session-store-type = 'in-momery'
redis-store = null
in-momery-session-store = {}

Session = (@sid)->


Session.prototype.save = !(callback)->
  if session-store-type is 'redis'
    redis-store.set @sid, (JSON.stringify @), !(err, result)->
      if err
        console.log "can't save key: #{@sid}, value: #{JSON.stringify session} to redis with err: ", err
      callback err, result
  else if session-store-type is 'in-momery'
    in-momery-session-store[@sid] = @
    callback! 

Session.prototype.restore-previous = !(previous-socket-id, callback)->
  if session-store-type is 'redis'
      console.log "previous-socket-id: ", previous-socket-id
      callback! if not previous-socket-id
      redis-store.get previous-socket-id, !(err, result)~>
        if err
          console.log "can't find previous session #{previous-socket-id} from redis, with err: ", err
          callback err, result
        else
          callback! if not result
          console.log('@ befoer <<<:', @)
          @ <<< JSON.parse(result)
          console.log('@ after <<<:', @)
          (err, result) <-! redis-store.set @sid, (JSON.stringify @) 
          callback err, result if err
          (err, result) <-! redis-store.del previous-socket-id
          callback err, result
  else if session-store-type is 'in-momery'
    console.log "pre: in-momery-session-store[#{previous-socket-id}]: ", in-momery-session-store[previous-socket-id]
    console.log "socket: in-momery-session-store[#{@sid}]: ", in-momery-session-store[@sid]
    if previous-socket-id
      @ <<< in-momery-session-store[@.sid] = in-momery-session-store[previous-socket-id]
      delete in-momery-session-store[previous-socket-id]
    console.log "socket: in-momery-session-store[#{@sid}]: ", in-momery-session-store[@sid]
    callback!

module.exports = 
  config: !(cfg)->
    if cfg.session-store-type in ['in-momery', 'redis']
      session-store-type := cfg.session-store-type
    redis-store := redis.create-client() if cfg.session-store-type is 'redis'

  get-session: (socket, callback)-> # sid likes cookie, which is stored by client, and provide in request. It is used to implement peresist session across multiple running of the client.
    session = new Session socket.id
    if session-store-type is 'redis'
      redis-store.get session.sid, !(err, result)->
        if err
          console.log "can't retrive #{@sid} from redis, with err: ", err
        else
          console.log "get session #{result}"
          session <<< ((JSON.parse result) or {} )
          callback session
    else if session-store-type is 'in-momery'
      session <<< (in-momery-session-store[session.sid] or {})
      callback session