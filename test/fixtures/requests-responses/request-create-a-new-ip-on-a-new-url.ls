intinteresting-point =
  type: 'web' # web | real
  title: '测试在新url上发布的新兴趣点' 
  content: '人类已经无法阻挡@+了' # 以后可以是HTML内容
  create-time: '2013-08-18 23:11:09'
  within-location:
    location-type: 'web' #!! derived from location
    url: 'http://some.com' # !!duplicated from location
    name: "url未知的神秘所在" #!!duplicated from location
    at-position: # position的所有信息都内嵌在这里，没有单独的position document
      position-within-web-page:
        related-text-content: '人们可以在任何网页上自由评论，吐槽' # 兴趣点圈划包括的网页上的文字。
        related-image: 'http://some.com/images/1.jpg'# 兴趣点圈划包括的网页上的图片，这里存储图片的URL。
        pin-point-dom: '.content div span 0' # $('.content div span')[0]，定位的原点
        offset: {x: '10em', y: '15em'}
        size: {width: '20em', height: '20em'}

  created-by: 'uid-1'
  is-private: false # default 当true时，只有shared-with的人才能够看到
  pictures: # 这里有待确定是在客户端捕获网页快照，还是在服务端screen scraper
    * type: 'snapshoot' # snapshoot | photo
      url: '/user-pictures/uid-1/1' # uid为creator的id，资源为：http://at-plus-server/pictures/uid/2
      createTime: "2013-02-04 12:00:04"
    ...
  tags: ['tid-1', 'tid-2']