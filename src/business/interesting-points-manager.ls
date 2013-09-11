require! './event-bus'
faked-other-business-of-create-comment = !(comment-data, callback)->
  callback {}

module.exports =
  create-comment: !(comment-data, callback)->
    (result) <-! faked-other-business-of-create-comment comment-data
    event-bus.emit 'user-create-interesting-point-comment', comment-data
    callback result


  get-interesting-points: !(location, callback)->
    connection = database.get-db!
    (err, interesting-points) <-! connection.interesting-points.find '{belongs-to-location.url: location.url}'
    callback err, interesting-points 