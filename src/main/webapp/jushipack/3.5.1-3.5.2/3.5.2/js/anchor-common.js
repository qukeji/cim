var jxlivelistUrl = "//api.juyun.tv/list.php" ;
var fansListUrl = "/apiv3.5.2/anchor_fans.php" ;
var anchorListUrl = "/anchorshow/anchor/anchor_recommend.json?number="+Math.random() ;
var lunboUrl = "/anchorshow/pics/anchor_lunbo.json" ;


//根字体设置
var Global = {
	init: function() {
		this.htmlFontSize();
	},
	//设置根元素的font-size
	htmlFontSize: function() {
		var doc = document;
		var win = window;
		function initFontSize() {
			var docEl = doc.documentElement,
				resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',
				recalc = function() {
					var clientWidth = docEl.clientWidth;
					if (!clientWidth) return;
					if (clientWidth > 750) {
						clientWidth = 750;
					}
					fontSizeRate = (clientWidth / 375);
					var baseFontSize = 50 * fontSizeRate;
					docEl.style.fontSize = baseFontSize + 'px';
				}
			recalc();
			if (!doc.addEventListener) return;
			win.addEventListener(resizeEvt, recalc, false);
			doc.addEventListener('DOMContentLoaded', recalc, false);
		}
		initFontSize();
	}
};
Global.init();

//获取地址栏参数
function getUrl(name) {
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
     if(r!=null)return  unescape(r[2]); return null;
};

//isios
function isIOS(){
    return /(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent);
}
;$(function(){
     // 返回顶部
    $('.top').click(function(){
    	$("body").animate({scrollTop:0},300);
    });
})


function nofind(_this){
    $(_this).attr("src","/images/user.png")
}
