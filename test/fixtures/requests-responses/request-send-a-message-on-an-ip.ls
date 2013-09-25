message =
  mid: 'mid-1'
  type: 'ip-msg' # ip-msg | ip-rpl | chat-msg | chat-rpl
  ipid: void # interesting point id
  r-mid: void # the message replied to, only available when type either is ip-rpl or chat-rpl
  cid: 'ipid-1' # ip id
  original-content-type: 'text' # text | voice
  text-content: '这是小东在足球兴趣点上的一次发言' # When origin content is voice, it will be interpreted text. May be HTML for colorful messages.
  within-location:
     youku-location = 
         _id: "lid-2" # 今后将由@+（mongoDB）自动生成
         type: "web"
         name: "【全场集锦】-于大宝郑龙2球张稀哲传射 国足6-1践行誓言—在线播放—优酷网，视频高清在线观看"
         duration: ''
         from: '2013-02-04 12:00:04'
         to: '2014-02-04 12:00:04' # 第一次报告这个location时from与to相同，之后，to是最后一次报告的时间
         is-existing: true
         is-internal: false # default 为true时，指不能够从公网访问的网页，或者公众无法进入的现实区域
         urls: ["http://v.youku.com/v_show/id_XNjA1OTQ2OTI0.html"]
         retrieved-html: '<html>... 假内容 ...</html>'
         # web-page-snapshot: '/web-page-snapshot/l网页的快照，用于定位兴趣点，可直接从_id推算出，不再存储。
            
  voice-content: void 
  at-users: ['uid-3', 'uid-2', 'cid-1']
  create-time: '2013-02-04 12:03:02'
  send-by: 'uid-1'
  reposts:
    * type: 'weibo' # 各个SNS，先暂时为weibo
      repost-id: 'xxxx'
      url: 'http://weibo.com/xxxx' # repost的地址
    ...
  is-copied-from-third-part: false # 用户在@+之外的平台上发送的消息，被我们汇集到@+时，此值为true
  origin-url: 'http://weibo.com/xxxx' # 原来的出处
  permlink: 'http://at-plus.com/xxxx' # 可收藏的永久链接

