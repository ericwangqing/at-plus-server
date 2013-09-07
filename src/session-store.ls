'''
在同一用户连接多个channels时，保持跨channels的session。可以配置为in-memory，或者redis的。当为redis的时候，需要先运行redis服务器。
'''

require! redis

redis-store = null
memory-store = {}

get = get-in-memory = !(sid, fn)->
  fn and fn(memory-store[sid] or {})

set = set-in-memory = !(sid, session, fn)->
  fn and fn(memory-store[sid] = session)

restore = restore-in-memory = !(new-sid, old-sid, fn)->
  if memory-store[old-sid]
    memory-store[new-sid] = memory-store[old-sid]
    delete memory-store[old-sid]
  fn memory-store[new-sid]

get-in-redis = !(sid, fn)->
  redis-store.get sid, !(err, result)->
    if err then fn(err) else fn(JSON.parse result)

set-in-redis = !(sid, session, fn)->
  redis-store.set sid, (JSON.stringify session), !(err, result)->
    if err then fn(err) else fn(session)

restore-in-redis = !(new-sid, old-sid, fn)->
  redis-store.get old-sid, (err, old-session)->
    if err
      fn(err)
    else redis-store.set new-sid, old-session, !(err, result)->
      if err then fn(err) else fn(old-session)


module.exports =
  get: get
  set: set
  restore: restore-in-memory
  config: !(cfg)->
    if cfg.type is 'redis'
      redis-store := redis.create-client() if not redis-store
      get = get-in-redis
      set = set-in-redis
      restore = restore-in-redis
    else
      get = get-in-memory
      set = set-in-memory
      restore = restore-in-memory

