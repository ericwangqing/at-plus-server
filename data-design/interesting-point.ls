interesting-point =
  _id: 'xxxx'
  type: 'web' # web | real
  title: '无法阻挡的@+' 
  content: '人类已经无法阻挡@+了' # 
  create-time: '2013-08-18 23:11:09'
  belongs-to-location:
    lid: 'lid-1'
    location-type: 'web' #!! derived from location
    name: '@+主页' #!!duplicated from location
    at-poisition: # position的所有信息都内嵌在这里，没有单独的position document
      is-exist: true # default
      is-private: false # default
      owners: ['uid-1', 'cid-1'] # only available when is-private is true 
      position-within-web-page:
        related-text-content: '人们可以在任何网页上自由评论，吐槽' # 兴趣点圈划包括的网页上的文字。
        related-image: 'http://some.com/images/1.jpg'# 兴趣点圈划包括的网页上的图片，这里存储图片的URL。
        pin-point-dom: '.content div span 0' # $('.content div span')[0]，定位的原点
        offset: {x: '10em', y: '15em'}
        size: {width: '20em', height: '20em'}
      postion-within-real-world-location: # 和上边position-within-web-page互斥
        name: '我的卧室' # nullable
        longitude: '123'
        latitude: '123'
        altitude: '123' # nullable
  created-by: 'uid-1'
  is-private: false # default 当true时，只有shared-with的人才能够看到
  shared-with: ['uid-2', 'gid-3'] # @过的人，分享给的人。
  subscribed-by: ['uid-4', 'uid-5'] # is-private false才可以订阅。
  pictures:
    * type: 'snapshoot' # snapshoot | photo
      url: 'uid/2' # uid为creator的id，资源为：http://at-plus-server/pictures/uid/2
    * type: 'photo' # 注意！这里是示例。实际上photo类和snapshot类是互斥的。
      url: 'uid/4'
      highlights:
        * offset: {x: '123', y: '123'}
          size: {width: '123' height: '123'}
        ...
  reposts:
    * type: 'weibo' # 各个SNS，先暂时为weibo
      url: 'http://weibo.com/xxxx' # repost的地址
    ...
