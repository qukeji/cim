//相关新闻
var showConfig = {
	time : true ,
	read :true 
} ;

function listConfig(){
	$.ajax({
        url:'/config/appconfig.json',
        dataType:"json",
        success:function(data){
        	if(data.showtime==0){
        		showConfig.time = true ;
        	}else{
        	    showConfig.time = false ;
        	}
        	if(data.showread==0){
        		showConfig.read = true ;
        	}else{
        	    showConfig.read = false ;
        	}
        	configShow();
        }
    });
}
function relationNews(){
	$.ajax({
        type: 'GET',
        data: " ",
        url: "/apiv3.5.2/relation_news.php?contentid="+GlobalID,
        dataType: 'jsonp',
        success: function (data) {
        	if(data.result.length){
        	   var _html = "" ;
        	   for (var i=0;i<data.result.length;i++) {
            		_html += '<div class="news-item" onclick="newsToRelation(this)" data-url="'+data.result[i].url+'">' +
            		        '<div class="news-img-box">'+
            		        '<img src="'+data.result[i].photo+'" /></div>'+
            		        '<div class="news-text">'  +
            		        '<p class="news-title">'+data.result[i].title+'</p>'+
            		        '<p class="news-about">'+
            		        '<span class="read-num">阅读量：<i>'+data.result[i].readcount+'</i></span><span class="n-col">|</span><span class="publish-time">发布：<i>'+data.result[i].date+'</i></span>'+
            		        '</p></div></div>';			        		        
            	}
            	if(data.result.length){
            	    $(".relative-news").show();
            	}
        	    $(".relative-news .news-list").html(_html);
        	    listConfig();
        	    
        	}
        	
        },
        error: function () {
           // alert("接口请求失败！");
        }
    });
}
//相关新闻--跳转
function newsToRelation(_this){
	var _url = $(_this).attr("data-url");
	window.open(_url,"_blank");
}

//配置是否显示阅读数和发布时间

function configShow(){
	if(showConfig.time){
		$(".news-about .publish-time").show()
	}
	if(showConfig.time){
		$(".news-about .read-num").show()
		$(".news-about .n-col").show();
	}
}



//微信分享

wx.error(function (res) {
    //alert(res.errMsg);
});
wx.ready(function () {
    // 获取“分享到朋友圈”按钮点击状态及自定义分享内容接口
    wx.onMenuShareTimeline({
        title: Title, // 分享标题
        desc: Summary,
        link: shareUrl,
        imgUrl: pImg , // 分享图标
        success: function () {
            // 用户确认分享后执行的回调函数
            //alert("分享成功！");
        },
        cancle: function (){
            // 用户取消分享后执行的回调函数
        }
    });
    // 获取“分享给朋友”按钮点击状态及自定义分享内容接口
    wx.onMenuShareAppMessage({
        title: Title, // 分享标题
        desc: Summary,
        link: shareUrl,
        imgUrl: pImg , // 分享图标
        type: 'link',
        success: function () {
            //alert("分享成功！");
        },
        cancle: function (){
            // 用户取消分享后执行的回调函数
        }
    });
    wx.onMenuShareQQ({
        title: Title, // 分享标题
        desc: Summary,
        link: shareUrl,
        imgUrl: pImg , // 分享图标
        type: 'link',
        success: function () {
            //alert("分享成功！");
        },
        cancle: function (){
            // 用户取消分享后执行的回调函数
        }
    });
    wx.onMenuShareQZone({
       title: Title, // 分享标题
        desc: Summary,
        link: shareUrl,
        imgUrl: pImg , // 分享图标
        type: 'link',
        success: function () {
            //alert("分享成功！");
        },
        cancle: function (){
            // 用户取消分享后执行的回调函数
        }
    });
});


$.ajax({
    type: 'GET',
    data: " ",
    url: "/apiv3.5.2/wx_sign.php?callback=?",   
    dataType: 'jsonp',
    success: function (data) {
        //console.log(data);
        wx.config({
            debug: false,
            appId: data.result.appId,
            timestamp: data.result.timestamp,
            nonceStr: data.result.nonceStr,
            signature: data.result.signature,
            jsApiList: ['onMenuShareTimeline', 'onMenuShareAppMessage', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
        });
    },
    error: function () {
        console.log("接口请求失败！");
    }
});
    
 
 /*顶部下载和返回顶部*/   
$(function(){
    var t=0, p=0;
    $(window).scroll(function(){
        var t=$(window).scrollTop();
        if(t>p && t>=120){
             $(".download_box").removeClass("show-top-pannel");
             $(".download_box").addClass("hide-top-pannel");
        }else if(p>t){
             $(".download_box").removeClass("hide-top-pannel");
             $(".download_box").addClass("show-top-pannel");
        }
        p=t;
         
    });  
    
        // 返回顶部
    $(window).scroll(function(){
    	$('.top').show();
    	if($(window).scrollTop() <= 200){
    		$('.top').hide();
    	}
    });
    $('.top').click(function(){
    	$(window).scrollTop(0);
    });
    
});  
