interesting-points =
  sysu-location_1 =
    _id: 'ipid-1'
    type: 'web' # web | real
    title: '无法阻挡的@+' 
    content: '人类已经无法阻挡@+了' # 以后可以是HTML内容
    create-time: '2013-08-18 23:11:09'
    within-location:
      lid: 'lid-1'
      location-type: 'web' #!! derived from location
      urls: ["http://ss.sysu.edu.cn/InformationSystem/", "http://ss.sysu.edu.cn/"]
      name: "中山大学软件学院" #!!duplicated from location
      at-position: # position的所有信息都内嵌在这里，没有单独的position document
        is-exist: true # default
        position-within-web-page:
          related-text-content: '人们可以在任何网页上自由评论，吐槽' # 兴趣点圈划包括的网页上的文字。
          related-image: 'http://some.com/images/1.jpg'# 兴趣点圈划包括的网页上的图片，这里存储图片的URL。
          pin-point-dom: '.content div span 0' # $('.content div span')[0]，定位的原点
          offset: {x: '10em', y: '15em'}
          size: {width: '20em', height: '20em'}
    created-by: 'uid-1'
    is-private: false # default 当true时，只有shared-with的人才能够看到
    commented-by: ['uid-2', 'gid-3', 'uid-4', 'uid-8'] # 参与评论的人。 !! derived from message and interesting-point
    shared-with: ['uid-2', 'gid-3'] # @过的人，分享给的人。
    watched-by: ['uid-4', 'uid-5'] # is-private false才可以订阅。
    pictures: # 兴趣点的快照
      * type: 'snapshoot' # snapshoot | photo
        url: '/user-pictures/uid-1/1' # uid为creator的id，资源为：http://at-plus-server/pictures/uid/2
        create-time: '2013-02-04 12:00:04'
      ...

    reposts:
      * type: 'weibo' # 各个SNS，先暂时为weibo
        repost-id: 'weibo-1' # 在weibo上的id，可用于查询回复和转发
        url: 'http://weibo.com/1' # repost的地址
      ...
    tags: ['tid-1', 'tid-2']

  sysu-location_2 =
    _id: 'ipid-2'
    type: 'web' # web | real
    title: '再次无法阻挡的@+' 
    content: '人类已经无法阻挡@+了' # 以后可以是HTML内容
    create-time: '2013-08-18 23:11:09'
    within-location:
      lid: 'lid-1'
      location-type: 'web' #!! derived from location
      urls: ["http://ss.sysu.edu.cn/InformationSystem/", "http://ss.sysu.edu.cn/"]
      name: "中山大学软件学院" #!!duplicated from location
      at-position: # position的所有信息都内嵌在这里，没有单独的position document
        is-exist: true # default
        position-within-web-page:
          related-text-content: '人们可以在任何网页上自由评论，吐槽' # 兴趣点圈划包括的网页上的文字。
          related-image: 'http://some.com/images/1.jpg'# 兴趣点圈划包括的网页上的图片，这里存储图片的URL。
          pin-point-dom: '.content div span 0' # $('.content div span')[0]，定位的原点
          offset: {x: '10em', y: '15em'}
          size: {width: '20em', height: '20em'}
    created-by: 'uid-1'
    is-private: false # default 当true时，只有shared-with的人才能够看到
    commented-by: ['uid-2', 'gid-3', 'uid-4', 'uid-8'] # 参与评论的人。 !! derived from message and interesting-point
    shared-with: ['uid-2', 'gid-3'] # @过的人，分享给的人。
    watched-by: ['uid-4', 'uid-5'] # is-private false才可以订阅。
    pictures: # 兴趣点的快照
      * type: 'snapshoot' # snapshoot | photo
        url: '/user-pictures/uid-1/2' # uid为creator的id，资源为：http://at-plus-server/pictures/uid/2
        create-time: '2013-02-04 12:00:04'
      ...

    reposts:
      * type: 'weibo' # 各个SNS，先暂时为weibo
        repost-id: 'weibo-2' # 在weibo上的id，可用于查询回复和转发
        url: 'http://weibo.com/2' # repost的地址
      ...
    tags: ['tid-1', 'tid-2']

  youku-location_1 =
    _id: 'ipid-3'
    type: 'web' # web | real
    title: '仍然无法阻挡的@+' 
    content: '人类已经无法阻挡@+了' # 以后可以是HTML内容
    create-time: '2013-08-18 23:11:09'
    within-location:
      lid: 'lid-2'
      location-type: 'web' #!! derived from location
      name: "【全场集锦】-于大宝郑龙2球张稀哲传射 国足6-1践行誓言—在线播放—优酷网，视频高清在线观看",
      urls: ["http://v.youku.com/v_show/id_XNjA1OTQ2OTI0.html"],
      at-position: # position的所有信息都内嵌在这里，没有单独的position document
        is-exist: true # default
        position-within-web-page:
          related-text-content: '人们可以在任何网页上自由评论，吐槽' # 兴趣点圈划包括的网页上的文字。
          related-image: 'http://some.com/images/1.jpg'# 兴趣点圈划包括的网页上的图片，这里存储图片的URL。
          pin-point-dom: '.content div span 0' # $('.content div span')[0]，定位的原点
          offset: {x: '10em', y: '15em'}
          size: {width: '20em', height: '20em'}
    created-by: 'uid-2'
    is-private: false # default 当true时，只有shared-with的人才能够看到
    commented-by: ['uid-3', 'gid-3', 'uid-4', 'uid-8'] # 参与评论的人。 !! derived from message and interesting-point
    shared-with: ['uid-3', 'gid-3'] # @过的人，分享给的人。
    watched-by: ['uid-4', 'uid-5'] # is-private false才可以订阅。
    pictures: # 兴趣点的快照
      * type: 'snapshoot' # snapshoot | photo
        url: '/user-pictures/uid-1/3' # uid为creator的id，资源为：http://at-plus-server/pictures/uid/2
        create-time: '2013-02-04 12:00:04'
      ...
    tags: ['tid-2']

  OTHER_ONE_NOT_FOUND_IN_TEST =
    _id: 'ipid-x'
    type: 'web' # web | real
    title: 'xxx' 
    content: 'xxx' # 以后可以是HTML内容
    create-time: '2013-08-18 23:11:09'
    within-location:
      lid: 'lid-x'
      location-type: 'web' #!! derived from location
      name: "xxx",
      urls: ["xxx"],
      at-position: # position的所有信息都内嵌在这里，没有单独的position document
        is-exist: true # default
        position-within-web-page:
          related-text-content: 'xxx' # 兴趣点圈划包括的网页上的文字。
          related-image: 'xxx'# 兴趣点圈划包括的网页上的图片，这里存储图片的URL。
          pin-point-dom: 'xxx' # $('.content div span')[0]，定位的原点
          offset: {x: '10em', y: '15em'}
          size: {width: '20em', height: '20em'}
    created-by: 'uid-1'
    is-private: false # default 当true时，只有shared-with的人才能够看到
    commented-by: ['uid-2', 'gid-3', 'uid-4', 'uid-8'] # 参与评论的人。 !! derived from message and interesting-point
    shared-with: ['uid-2', 'gid-3'] # @过的人，分享给的人。
    watched-by: ['uid-4', 'uid-5'] # is-private false才可以订阅。
    pictures: # 兴趣点的快照
      * type: 'snapshoot' # snapshoot | photo
        url: 'xxx' # uid为creator的id，资源为：http://at-plus-server/pictures/uid/2
        create-time: '2013-02-04 12:00:04'
      ...
    tags: ['tid-2']


