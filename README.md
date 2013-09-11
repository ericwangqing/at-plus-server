SPIKE说明
====

真实需求场景
-----
各个channels之间，并非完全割裂。例如：当用户通过interesting-points频道，评论一个兴趣点，并在评论中@好友时，users频道将向这个好友发送通知。

@+技术分析
----
当interesting-points频道接收请求后，将调用interesting-points-manager执行业务逻辑。此时，interesting-points-manager将通过event-bus，发出'user-add-interesting-points'事件。users频道在初始化中，注册了event-bus上的'user-add-interesting-points'事件，在事件发生后，就发送通知。

SPIKE精简
----
为突出重点，这里将精简@+真实需求里面，其它和本SPIKE无关的业务逻辑。