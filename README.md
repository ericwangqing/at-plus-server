at-plus-server
==============
@+ server新架构，基于socket.io和Pub-Sub模式。

为了BDD，需要patch现在的socket.io-client。目前需要进入/node_modules/socket.io-client/node_modules/xmlhttprequest/lib/XMLHttpRequest.js 将其中forbiddenRequestHeaders的cookie注释掉。
