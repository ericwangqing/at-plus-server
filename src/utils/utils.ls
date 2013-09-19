require! async
_ = require 'underscore'
create-parallel-task = (task)->
  !(callback)->
    task!
    callback!

module.exports =
  simple-parallel: !(tasks, callback)->
    async.parallel [create-parallel-task task for task in tasks], callback
  visit-object: visit-object