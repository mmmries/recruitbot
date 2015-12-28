!function(){"use strict";var e="undefined"==typeof window?global:window;if("function"!=typeof e.require){var t={},n={},i={},o={}.hasOwnProperty,r="components/",s=function(e,t){var n=0;t&&(0===t.indexOf(r)&&(n=r.length),t.indexOf("/",n)>0&&(t=t.substring(n,t.indexOf("/",n))));var o=i[e+"/index.js"]||i[t+"/deps/"+e+"/index.js"];return o?r+o.substring(0,o.length-".js".length):e},u=/^\.\.?(\/|$)/,a=function(e,t){for(var n,i=[],o=(u.test(t)?e+"/"+t:t).split("/"),r=0,s=o.length;s>r;r++)n=o[r],".."===n?i.pop():"."!==n&&""!==n&&i.push(n);return i.join("/")},c=function(e){return e.split("/").slice(0,-1).join("/")},l=function(t){return function(n){var i=a(c(t),n);return e.require(i,t)}},h=function(e,t){var i={id:e,exports:{}};return n[e]=i,t(i.exports,l(e),i),i.exports},f=function(e,i){var r=a(e,".");if(null==i&&(i="/"),r=s(e,i),o.call(n,r))return n[r].exports;if(o.call(t,r))return h(r,t[r]);var u=a(r,"./index");if(o.call(n,u))return n[u].exports;if(o.call(t,u))return h(u,t[u]);throw new Error('Cannot find module "'+e+'" from "'+i+'"')};f.alias=function(e,t){i[t]=e},f.register=f.define=function(e,n){if("object"==typeof e)for(var i in e)o.call(e,i)&&(t[i]=e[i]);else t[e]=n},f.list=function(){var e=[];for(var n in t)o.call(t,n)&&e.push(n);return e},f.brunch=!0,f._cache=n,e.require=f}}(),require.register("deps/phoenix/web/static/js/phoenix",function(e,t,n){"use strict";function i(e){return e&&"undefined"!=typeof Symbol&&e.constructor===Symbol?"symbol":typeof e}function o(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}var r=function(){function e(e,t){for(var n=0;n<t.length;n++){var i=t[n];i.enumerable=i.enumerable||!1,i.configurable=!0,"value"in i&&(i.writable=!0),Object.defineProperty(e,i.key,i)}}return function(t,n,i){return n&&e(t.prototype,n),i&&e(t,i),t}}();Object.defineProperty(e,"__esModule",{value:!0});var s="1.0.0",u={connecting:0,open:1,closing:2,closed:3},a=1e4,c={closed:"closed",errored:"errored",joined:"joined",joining:"joining"},l={close:"phx_close",error:"phx_error",join:"phx_join",reply:"phx_reply",leave:"phx_leave"},h={longpoll:"longpoll",websocket:"websocket"},f=function(){function e(t,n,i,r){o(this,e),this.channel=t,this.event=n,this.payload=i||{},this.receivedResp=null,this.timeout=r,this.timeoutTimer=null,this.recHooks=[],this.sent=!1}return r(e,[{key:"resend",value:function(e){this.timeout=e,this.cancelRefEvent(),this.ref=null,this.refEvent=null,this.receivedResp=null,this.sent=!1,this.send()}},{key:"send",value:function(){this.hasReceived("timeout")||(this.startTimeout(),this.sent=!0,this.channel.socket.push({topic:this.channel.topic,event:this.event,payload:this.payload,ref:this.ref}))}},{key:"receive",value:function(e,t){return this.hasReceived(e)&&t(this.receivedResp.response),this.recHooks.push({status:e,callback:t}),this}},{key:"matchReceive",value:function(e){var t=e.status,n=e.response;e.ref;this.recHooks.filter(function(e){return e.status===t}).forEach(function(e){return e.callback(n)})}},{key:"cancelRefEvent",value:function(){this.refEvent&&this.channel.off(this.refEvent)}},{key:"cancelTimeout",value:function(){clearTimeout(this.timeoutTimer),this.timeoutTimer=null}},{key:"startTimeout",value:function(){var e=this;this.timeoutTimer||(this.ref=this.channel.socket.makeRef(),this.refEvent=this.channel.replyEventName(this.ref),this.channel.on(this.refEvent,function(t){e.cancelRefEvent(),e.cancelTimeout(),e.receivedResp=t,e.matchReceive(t)}),this.timeoutTimer=setTimeout(function(){e.trigger("timeout",{})},this.timeout))}},{key:"hasReceived",value:function(e){return this.receivedResp&&this.receivedResp.status===e}},{key:"trigger",value:function(e,t){this.channel.trigger(this.refEvent,{status:e,response:t})}}]),e}(),p=e.Channel=function(){function e(t,n,i){var r=this;o(this,e),this.state=c.closed,this.topic=t,this.params=n||{},this.socket=i,this.bindings=[],this.timeout=this.socket.timeout,this.joinedOnce=!1,this.joinPush=new f(this,l.join,this.params,this.timeout),this.pushBuffer=[],this.rejoinTimer=new m(function(){return r.rejoinUntilConnected()},this.socket.reconnectAfterMs),this.joinPush.receive("ok",function(){r.state=c.joined,r.rejoinTimer.reset(),r.pushBuffer.forEach(function(e){return e.send()}),r.pushBuffer=[]}),this.onClose(function(){r.socket.log("channel","close "+r.topic),r.state=c.closed,r.socket.remove(r)}),this.onError(function(e){r.socket.log("channel","error "+r.topic,e),r.state=c.errored,r.rejoinTimer.setTimeout()}),this.joinPush.receive("timeout",function(){r.state===c.joining&&(r.socket.log("channel","timeout "+r.topic,r.joinPush.timeout),r.state=c.errored,r.rejoinTimer.setTimeout())}),this.on(l.reply,function(e,t){r.trigger(r.replyEventName(t),e)})}return r(e,[{key:"rejoinUntilConnected",value:function(){this.rejoinTimer.setTimeout(),this.socket.isConnected()&&this.rejoin()}},{key:"join",value:function(){var e=arguments.length<=0||void 0===arguments[0]?this.timeout:arguments[0];if(this.joinedOnce)throw"tried to join multiple times. 'join' can only be called a single time per channel instance";return this.joinedOnce=!0,this.rejoin(e),this.joinPush}},{key:"onClose",value:function(e){this.on(l.close,e)}},{key:"onError",value:function(e){this.on(l.error,function(t){return e(t)})}},{key:"on",value:function(e,t){this.bindings.push({event:e,callback:t})}},{key:"off",value:function(e){this.bindings=this.bindings.filter(function(t){return t.event!==e})}},{key:"canPush",value:function(){return this.socket.isConnected()&&this.state===c.joined}},{key:"push",value:function(e,t){var n=arguments.length<=2||void 0===arguments[2]?this.timeout:arguments[2];if(!this.joinedOnce)throw"tried to push '"+e+"' to '"+this.topic+"' before joining. Use channel.join() before pushing events";var i=new f(this,e,t,n);return this.canPush()?i.send():(i.startTimeout(),this.pushBuffer.push(i)),i}},{key:"leave",value:function(){var e=this,t=arguments.length<=0||void 0===arguments[0]?this.timeout:arguments[0],n=function(){e.socket.log("channel","leave "+e.topic),e.trigger(l.close,"leave")},i=new f(this,l.leave,{},t);return i.receive("ok",function(){return n()}).receive("timeout",function(){return n()}),i.send(),this.canPush()||i.trigger("ok",{}),i}},{key:"onMessage",value:function(e,t,n){}},{key:"isMember",value:function(e){return this.topic===e}},{key:"sendJoin",value:function(e){this.state=c.joining,this.joinPush.resend(e)}},{key:"rejoin",value:function(){var e=arguments.length<=0||void 0===arguments[0]?this.timeout:arguments[0];this.sendJoin(e)}},{key:"trigger",value:function(e,t,n){this.onMessage(e,t,n),this.bindings.filter(function(t){return t.event===e}).map(function(e){return e.callback(t,n)})}},{key:"replyEventName",value:function(e){return"chan_reply_"+e}}]),e}(),d=(e.Socket=function(){function e(t){var n=this,i=arguments.length<=1||void 0===arguments[1]?{}:arguments[1];o(this,e),this.stateChangeCallbacks={open:[],close:[],error:[],message:[]},this.channels=[],this.sendBuffer=[],this.ref=0,this.timeout=i.timeout||a,this.transport=i.transport||window.WebSocket||d,this.heartbeatIntervalMs=i.heartbeatIntervalMs||3e4,this.reconnectAfterMs=i.reconnectAfterMs||function(e){return[1e3,2e3,5e3,1e4][e-1]||1e4},this.logger=i.logger||function(){},this.longpollerTimeout=i.longpollerTimeout||2e4,this.params=i.params||{},this.endPoint=t+"/"+h.websocket,this.reconnectTimer=new m(function(){n.disconnect(function(){return n.connect()})},this.reconnectAfterMs)}return r(e,[{key:"protocol",value:function(){return location.protocol.match(/^https/)?"wss":"ws"}},{key:"endPointURL",value:function(){var e=v.appendParams(v.appendParams(this.endPoint,this.params),{vsn:s});return"/"!==e.charAt(0)?e:"/"===e.charAt(1)?this.protocol()+":"+e:this.protocol()+"://"+location.host+e}},{key:"disconnect",value:function(e,t,n){this.conn&&(this.conn.onclose=function(){},t?this.conn.close(t,n||""):this.conn.close(),this.conn=null),e&&e()}},{key:"connect",value:function(e){var t=this;e&&(console&&console.log("passing params to connect is deprecated. Instead pass :params to the Socket constructor"),this.params=e),this.conn||(this.conn=new this.transport(this.endPointURL()),this.conn.timeout=this.longpollerTimeout,this.conn.onopen=function(){return t.onConnOpen()},this.conn.onerror=function(e){return t.onConnError(e)},this.conn.onmessage=function(e){return t.onConnMessage(e)},this.conn.onclose=function(e){return t.onConnClose(e)})}},{key:"log",value:function(e,t,n){this.logger(e,t,n)}},{key:"onOpen",value:function(e){this.stateChangeCallbacks.open.push(e)}},{key:"onClose",value:function(e){this.stateChangeCallbacks.close.push(e)}},{key:"onError",value:function(e){this.stateChangeCallbacks.error.push(e)}},{key:"onMessage",value:function(e){this.stateChangeCallbacks.message.push(e)}},{key:"onConnOpen",value:function(){var e=this;this.log("transport","connected to "+this.endPointURL(),this.transport.prototype),this.flushSendBuffer(),this.reconnectTimer.reset(),this.conn.skipHeartbeat||(clearInterval(this.heartbeatTimer),this.heartbeatTimer=setInterval(function(){return e.sendHeartbeat()},this.heartbeatIntervalMs)),this.stateChangeCallbacks.open.forEach(function(e){return e()})}},{key:"onConnClose",value:function(e){this.log("transport","close",e),this.triggerChanError(),clearInterval(this.heartbeatTimer),this.reconnectTimer.setTimeout(),this.stateChangeCallbacks.close.forEach(function(t){return t(e)})}},{key:"onConnError",value:function(e){this.log("transport",e),this.triggerChanError(),this.stateChangeCallbacks.error.forEach(function(t){return t(e)})}},{key:"triggerChanError",value:function(){this.channels.forEach(function(e){return e.trigger(l.error)})}},{key:"connectionState",value:function(){switch(this.conn&&this.conn.readyState){case u.connecting:return"connecting";case u.open:return"open";case u.closing:return"closing";default:return"closed"}}},{key:"isConnected",value:function(){return"open"===this.connectionState()}},{key:"remove",value:function(e){this.channels=this.channels.filter(function(t){return!t.isMember(e.topic)})}},{key:"channel",value:function(e){var t=arguments.length<=1||void 0===arguments[1]?{}:arguments[1],n=new p(e,t,this);return this.channels.push(n),n}},{key:"push",value:function(e){var t=this,n=e.topic,i=e.event,o=e.payload,r=e.ref,s=function(){return t.conn.send(JSON.stringify(e))};this.log("push",n+" "+i+" ("+r+")",o),this.isConnected()?s():this.sendBuffer.push(s)}},{key:"makeRef",value:function(){var e=this.ref+1;return e===this.ref?this.ref=0:this.ref=e,this.ref.toString()}},{key:"sendHeartbeat",value:function(){this.isConnected()&&this.push({topic:"phoenix",event:"heartbeat",payload:{},ref:this.makeRef()})}},{key:"flushSendBuffer",value:function(){this.isConnected()&&this.sendBuffer.length>0&&(this.sendBuffer.forEach(function(e){return e()}),this.sendBuffer=[])}},{key:"onConnMessage",value:function(e){var t=JSON.parse(e.data),n=t.topic,i=t.event,o=t.payload,r=t.ref;this.log("receive",(o.status||"")+" "+n+" "+i+" "+(r&&"("+r+")"||""),o),this.channels.filter(function(e){return e.isMember(n)}).forEach(function(e){return e.trigger(i,o,r)}),this.stateChangeCallbacks.message.forEach(function(e){return e(t)})}}]),e}(),e.LongPoll=function(){function e(t){o(this,e),this.endPoint=null,this.token=null,this.skipHeartbeat=!0,this.onopen=function(){},this.onerror=function(){},this.onmessage=function(){},this.onclose=function(){},this.pollEndpoint=this.normalizeEndpoint(t),this.readyState=u.connecting,this.poll()}return r(e,[{key:"normalizeEndpoint",value:function(e){return e.replace("ws://","http://").replace("wss://","https://").replace(new RegExp("(.*)/"+h.websocket),"$1/"+h.longpoll)}},{key:"endpointURL",value:function(){return v.appendParams(this.pollEndpoint,{token:this.token})}},{key:"closeAndRetry",value:function(){this.close(),this.readyState=u.connecting}},{key:"ontimeout",value:function(){this.onerror("timeout"),this.closeAndRetry()}},{key:"poll",value:function(){var e=this;(this.readyState===u.open||this.readyState===u.connecting)&&v.request("GET",this.endpointURL(),"application/json",null,this.timeout,this.ontimeout.bind(this),function(t){if(t){var n=t.status,i=t.token,o=t.messages;e.token=i}else var n=0;switch(n){case 200:o.forEach(function(t){return e.onmessage({data:JSON.stringify(t)})}),e.poll();break;case 204:e.poll();break;case 410:e.readyState=u.open,e.onopen(),e.poll();break;case 0:case 500:e.onerror(),e.closeAndRetry();break;default:throw"unhandled poll status "+n}})}},{key:"send",value:function(e){var t=this;v.request("POST",this.endpointURL(),"application/json",e,this.timeout,this.onerror.bind(this,"timeout"),function(e){e&&200===e.status||(t.onerror(status),t.closeAndRetry())})}},{key:"close",value:function(e,t){this.readyState=u.closed,this.onclose()}}]),e}()),v=e.Ajax=function(){function e(){o(this,e)}return r(e,null,[{key:"request",value:function(e,t,n,i,o,r,s){if(window.XDomainRequest){var u=new XDomainRequest;this.xdomainRequest(u,e,t,i,o,r,s)}else{var u=window.XMLHttpRequest?new XMLHttpRequest:new ActiveXObject("Microsoft.XMLHTTP");this.xhrRequest(u,e,t,n,i,o,r,s)}}},{key:"xdomainRequest",value:function(e,t,n,i,o,r,s){var u=this;e.timeout=o,e.open(t,n),e.onload=function(){var t=u.parseJSON(e.responseText);s&&s(t)},r&&(e.ontimeout=r),e.onprogress=function(){},e.send(i)}},{key:"xhrRequest",value:function(e,t,n,i,o,r,s,u){var a=this;e.timeout=r,e.open(t,n,!0),e.setRequestHeader("Content-Type",i),e.onerror=function(){u&&u(null)},e.onreadystatechange=function(){if(e.readyState===a.states.complete&&u){var t=a.parseJSON(e.responseText);u(t)}},s&&(e.ontimeout=s),e.send(o)}},{key:"parseJSON",value:function(e){return e&&""!==e?JSON.parse(e):null}},{key:"serialize",value:function(e,t){var n=[];for(var o in e)if(e.hasOwnProperty(o)){var r=t?t+"["+o+"]":o,s=e[o];"object"===("undefined"==typeof s?"undefined":i(s))?n.push(this.serialize(s,r)):n.push(encodeURIComponent(r)+"="+encodeURIComponent(s))}return n.join("&")}},{key:"appendParams",value:function(e,t){if(0===Object.keys(t).length)return e;var n=e.match(/\?/)?"&":"?";return""+e+n+this.serialize(t)}}]),e}();v.states={complete:4};var m=function(){function e(t,n){o(this,e),this.callback=t,this.timerCalc=n,this.timer=null,this.tries=0}return r(e,[{key:"reset",value:function(){this.tries=0,clearTimeout(this.timer)}},{key:"setTimeout",value:function(e){function t(){return e.apply(this,arguments)}return t.toString=function(){return e.toString()},t}(function(){var e=this;clearTimeout(this.timer),this.timer=setTimeout(function(){e.tries=e.tries+1,e.callback()},this.timerCalc(this.tries+1))})}]),e}()}),require.register("deps/phoenix_html/web/static/js/phoenix_html",function(e,t,n){"use strict";for(var i=document.querySelectorAll("[data-submit^=parent]"),o=i.length,r=0;o>r;++r)i[r].addEventListener("click",function(e){var t=this.getAttribute("data-confirm");return(null===t||confirm(t))&&this.parentNode.submit(),e.preventDefault(),!1},!1)}),require.register("web/static/js/app",function(e,t,n){"use strict";function i(e){return e&&e.__esModule?e:{"default":e}}t("deps/phoenix_html/web/static/js/phoenix_html");var o=t("./socket");i(o)}),require.register("web/static/js/socket",function(e,t,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var i=t("deps/phoenix/web/static/js/phoenix"),o=new i.Socket("/socket",{params:{token:window.userToken}});o.connect();var r=function(e){return document.getElementsByClassName(e)[0]},s=o.channel("roomba",{});s.join().receive("ok",function(e){document.getElementById("forward").addEventListener("mousedown",function(e){console.log("forward"),s.push("drive",{velocity:100,radius:0})}),document.getElementById("backward").addEventListener("mousedown",function(e){console.log("backward"),s.push("drive",{velocity:-100,radius:0})}),document.getElementById("left").addEventListener("mousedown",function(e){console.log("left"),s.push("drive",{velocity:100,radius:10})}),document.getElementById("right").addEventListener("mousedown",function(e){console.log("right"),s.push("drive",{velocity:100,radius:-10})}),document.addEventListener("mouseup",function(e){console.log("stop!"),s.push("drive",{velocity:0,radius:0})}),console.log("Joined successfully",e)}).receive("error",function(e){console.log("Unable to join",e)}),s.on("sensor_update",function(e){r("bumper_left").setAttribute("fill",0==e.bumper_left?"black":"red"),r("bumper_right").setAttribute("fill",0==e.bumper_right?"black":"red"),r("light_bumper_left").setAttribute("display",0==e.light_bumper_left?"none":"block"),r("light_bumper_left_front").setAttribute("display",0==e.light_bumper_left_front?"none":"block"),r("light_bumper_left_center").setAttribute("display",0==e.light_bumper_left_center?"none":"block"),r("light_bumper_right").setAttribute("display",0==e.light_bumper_right?"none":"block"),r("light_bumper_right_front").setAttribute("display",0==e.light_bumper_right_front?"none":"block"),r("light_bumper_right_center").setAttribute("display",0==e.light_bumper_right_center?"none":"block")}),e["default"]=o}),require("web/static/js/app");