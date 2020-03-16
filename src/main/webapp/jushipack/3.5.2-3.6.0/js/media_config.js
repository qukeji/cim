
var ipurl="/apiv3.6";
var session= getUrl("session");
var site=53;
var Global={
	init:function() {
		this.htmlFontSize();
	},
	//设置根元素的font-size
	htmlFontSize:function(){
		var doc = document;
		var win = window;
		function initFontSize(){
			var docEl = doc.documentElement,
				resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',
				recalc = function(){
					var clientWidth = docEl.clientWidth;
					if(!clientWidth) return;
					if(clientWidth>750){
						clientWidth=750;
					}
					fontSizeRate = (clientWidth / 375);
					var baseFontSize = 50*fontSizeRate;
					docEl.style.fontSize =  baseFontSize + 'px';
				}
			recalc();
			if(!doc.addEventListener) return;
			win.addEventListener(resizeEvt, recalc, false);
			doc.addEventListener('DOMContentLoaded', recalc,false);
		}
		initFontSize();
	}

};
Global.init();
//读取地址栏参数
function getUrl(name) {
	 var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
	 var r = window.location.search.substr(1).match(reg);
	 if(r!=null)return  unescape(r[2]); return null;
};
//公共弹窗函数
function commonPop(tips){
	$("#commonpop").stop().hide();
	$("#commonpop span").html(tips);		 
	$("#commonpop").fadeIn(1);
	var popInterval = setTimeout(function() {		    	
		$("#commonpop").fadeOut(300);
		clearTimeout(popInterval);
	}, 3000);  
}
//写cookies
function setCookie(name,value){
	var Days = 30;
	var exp = new Date();
	exp.setTime(exp.getTime() + Days*24*60*60*1000);
	document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}
function getCookie(name){
	var cookies = {};
	document.cookie.split(";").map(function(i){
		var cookie = i.trim().split('=');
		cookies[cookie[0]] = cookie[1];
	});
	return cookies[name];
}
function getCookies(name) {
	var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));
	if (arr != null) return unescape(arr[2]); return null;
};
			
function delCookie(name){
	var exp = new Date();
	exp.setTime(exp.getTime() - 1);
	var cval=getCookie(name);
	if(cval!=null)
	document.cookie= name + "="+cval+";expires="+exp.toGMTString();
}	
