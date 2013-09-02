# describe '基本用法尝试', !->
#   can '能够同时default和location channel的connection', !(done)->
#     # client1 = io.connect base-url + '/locations', options
#     # complete = !(err, result)->
#     #   console.log err if err
#     # async.parallel [
#     #   !(complete)->
#     #     client1.on 'ready', !(data)->
#     #       console.log 'connected to locations channel, and get data: ', data
#     #       console.log 'client1: \n', client1
#     #       complete null, data
#     #   !(complete)->
#     #     client1.on 'initial', !(data)->
#     #       console.log 'connected to default channel, and get data: ', data
#     #       complete null, data
#     #   ], !->
#         done!

        
