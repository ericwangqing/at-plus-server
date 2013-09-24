require! ['./database','./testing-helper-channel'.get-testing-control]

find-location-for-url = !(url-data, callback)->
  can-find = not get-testing-control!.locations-manager.get-old-or-create-new-location.is-new
  debug "*************** find-location-for-url 尚未实现，现在是个mock，通过testing-helper频道控制。能找到？#{can-find} ***************" 
  if can-find
    (db) <-! database.get-db
    (err, location) <-! db.at-plus.locations.find-one 
    callback location, null
  else
    (retrieved-html) <-! retrieve-html-and-snapshot-at-url url-data.url
    callback null, retrieved-html

retrieve-html-and-snapshot-at-url = !(url, callback)->
  debug "*************** retrieve-html-and-snapshot-at-url 尚未实现，现在直接返回预设的html ***************"
  # snapshot 网页快照
  callback {
    snapshot: null
    retrieved-html: "<html>... 假内容 ...</html>"
  }



module.exports =
  find-location-for-url: find-location-for-url