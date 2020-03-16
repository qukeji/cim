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

