require! './database'
interesting-points-manager =
  get-interesting-points: !(location, callback)->
    connection = database.get-connection!
    (err, interesting-points) <-! connection.interesting-points.find '{belongs-to-location.url: location.url}'
    callback err, interesting-points 