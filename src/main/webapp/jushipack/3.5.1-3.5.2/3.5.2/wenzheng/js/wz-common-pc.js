var siteUrl =  "//123.56.71.230:889/tcenter/wenzheng/web" ;

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

//获取地址栏参数
function getUrlParam(name) {
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
     if(r!=null)return  unescape(r[2]); return null;
};

//sessionStorage
function sSs(key,value){
    if(value==undefined || value===undefined ){
        return sessionStorage.getItem(key);//获取指定key本地存储的值
    }
    if(value==null){
        sessionStorage.removeItem(key);//删除指定key本地存储的值
        return true;
    }
    sessionStorage.setItem(key,value);//将value存储到key字段
    return true;
};	


;(function($) {
	var ms = {
		init: function(obj, args) {
			return(function() {
				ms.fillHtml(obj, args);
				ms.bindEvent(obj, args);
			})();
		},
		//填充html
		fillHtml: function(obj, args) {
			return(function() {
				obj.empty();
				//上一页
				if(args.current > 1) {
					obj.append('<a href="javascript:;" class="prevPage page-item">上一页</a>');
				} else {
					obj.remove('.prevPage');
					obj.append('<span class="disabled  page-item">上一页</span>');
				}
				//中间页码
				if(args.current != 1 && args.current >= 4 && args.pageCount != 4) {
					obj.append('<a href="javascript:;" class="norNumber  page-item">' + 1 + '</a>');
				}
				if(args.current - 2 > 2 && args.current <= args.pageCount && args.pageCount > 5) {
					obj.append('<span class="page-more">...</span>');
				}
				var start = args.current - 2,
					end = args.current + 2;
				if((start > 1 && args.current < 4) || args.current == 1) {
					end++;
				}
				if(args.current > args.pageCount - 4 && args.current >= args.pageCount) {
					start--;
				}
				for(; start <= end; start++) {
					if(start <= args.pageCount && start >= 1) {
						if(start != args.current) {
							obj.append('<a href="javascript:;" class="norNumber  page-item">' + start + '</a>');
						} else {
							obj.append('<span class="current page-item">' + start + '</span>');
						}
					}
				}
				if(args.current + 2 < args.pageCount - 1 && args.current >= 1 && args.pageCount > 5) {
					obj.append('<span class="page-more">...</span>');
				}
				if(args.current != args.pageCount && args.current < args.pageCount - 2 && args.pageCount != 4) {
					obj.append('<a href="javascript:;" class="norNumber page-item">' + args.pageCount + '</a>');
				}
				//下一页
				if(args.current < args.pageCount) {
					obj.append('<a href="javascript:;" class="nextPage page-item">下一页</a>');
				} else {
					obj.remove('.nextPage');
					obj.append('<span class="disabled page-item">下一页</span>');
				}
			})();
		},
		//绑定事件
		bindEvent: function(obj, args) {
			
			return(function() {
				obj.on("click", "a.norNumber", function() {
					var current = parseInt($(this).text());
					ms.fillHtml(obj, {
						"current": current,
						"pageCount": args.pageCount
					});
					if(typeof(args.backFn) == "function") {
						args.backFn(current);
					}
				});
				//上一页
				obj.on("click", "a.prevPage", function() {
					var current = parseInt(obj.children("span.current").text());
					ms.fillHtml(obj, {
						"current": current - 1,
						"pageCount": args.pageCount
					});
					if(typeof(args.backFn) == "function") {
						args.backFn(current - 1);
					}
				});
				//下一页
				obj.on("click", "a.nextPage", function() {
					var current = parseInt(obj.children("span.current").text());
					ms.fillHtml(obj, {
						"current": current + 1,
						"pageCount": args.pageCount
					});
					if(typeof(args.backFn) == "function") {
						args.backFn(current + 1);
					}
				});
			})();
		}
	}
	$.fn.createPage = function(options) {
		var args = $.extend({
			pageCount: 24,
			current: 1,
			backFn: function() {}
		}, options);
		ms.init(this, args);
	}
})(jQuery);	
