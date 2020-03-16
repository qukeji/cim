;$(function(){
	var videoUrl = "" ;	
	var tideLiveId = $(".td-liveid").val();
	var globalid = $(".globalid").val();
	var playerCover = $(".player-cover").val() ? $(".player-cover").val() : "/images/videoqj.png";
	
	//请求播放地址
    $.ajax({
    	url:"/apiv3.6.0/m3u8_notoken.php?channelid="+tideLiveId,
    	dateType:"json",
    	type:"get",
    	success:function(data1){
    	    var data = JSON.parse(data1) ;
    	    console.log(data);
    		videoUrl = data.address ;
    		var fileFormat= videoUrl.substr(videoUrl.lastIndexOf(".")).toLowerCase().substring(1); //获得文件后缀名
			if(fileFormat=="m3u8"){
				H5Player.status = "live" ;
			}else{
				H5Player.status = "" ;
			}
			H5Player.x5VideoPlay(videoUrl , true, playerCover );
        }
    })

	var timeContainer = $('.time-sp') ; 
	//getCurrentTime();
	function getCurrentTime(){
		var time = new Date(); 
		var h = time.getHours() ;
		var m = time.getMinutes() ;
		var s = time.getSeconds() ;
		var t = ((h<10)?"0"+h:h) + ":" +( (m<10)?"0"+m:m) + ":" +((s<10)? "0"+s : s );
		$('.time-sp').text(t) ;  

	}
	//setInterval( getCurrentTime , 1000); 
	
	function getNowFormatDate(str) {
		var date = str ? new Date(str) : new Date() ; 
		//console.log(str,"|",date)
	    var seperator1 = "-";
	    var seperator2 = ":";
	    function addZero(m){
	    	return m<10 ? '0'+m : m  ;
	    }
	    var currentdate = addZero( date.getHours() ) + seperator2 + addZero(date.getMinutes()) ;			    
	    return currentdate;
	} 
	//格式化时间以比较早晚
	function formatTime(time){
		return new Date(time.replace("-", "/").replace("-", "/"));
	}
				
    //请求节目单
    $.ajax({
    	url:"/apiv3.6.0/epg_list.php?globalid="+globalid,
    	dateType:"json",
    	type:"get",
    	success:function(data1){
    		var data = JSON.parse(data1) ;
    		console.log(data);
    		var dateHtml = "" ;
    		var programHtml = "" ;
    		var listHtml = "" ;
    		var currentTime = new Date() ;
			for (var i=0;i<data.list.length;i++) {
				if(i==data.list.length-1){
					dateHtml += '<li class="current">'+data.list[i].title+'</li>' 
				}else{
					dateHtml += '<li class="">'+data.list[i].title+'</li>' 
				}	        			
				if(data.list[i].epg.length){
					listHtml = "" ;
					for (var j=0;j<data.list[i].epg.length;j++) {
						if(formatTime(data.list[i].epg[j].starttime)<=currentTime && formatTime(data.list[i].epg[j].endtime) >= currentTime ){
							listHtml +='<li class="cur" data-start="'+data.list[i].epg[j].starttime+'" data-end="'+data.list[i].epg[j].endtime+'">'
						}else{
							listHtml +='<li class="" data-start="'+data.list[i].epg[j].starttime+'" data-end="'+data.list[i].epg[j].endtime+'">'
						}	
						listHtml += '<span class="l-time">'+getNowFormatDate(formatTime(data.list[i].epg[j].starttime))+'</span>'									
						listHtml +='<span class="l-title">'+data.list[i].epg[j].title+'</span>'	 
						listHtml += '<span class="living">直播中</span></li>'
					}
					$(".p-li").eq(i).html('<ul>'+listHtml+'</ul>');
				}
				
			}
    		$(".date-list").html(dateHtml) ;
    	}
    })
    ////切换日期
    $(".date-list").delegate("li","click",function(){
    	var _index = $(this).index();
    	$(this).addClass("current").siblings("li").removeClass("current") ;
    	console.log(_index)
    	$(".program-content li.p-li").hide().eq(_index).show();
    	//此时重新判断直接直接段
    	findTheLive();
    })
    //重新找到当前正在直播的节目高亮
    function findTheLive(){
    	var activeLiChild  = $(".p-li.active").find("li") ;
    	var curTime = new Date() ;
    	$.each(activeLiChild, function(vi,va) {
    		if( formatTime($(va).attr("data-start")) <= curTime && formatTime( $(va).attr("data-end") ) >=curTime){
    			activeLiChild.removeClass("cur");
    			$(va).addClass("cur");
    		}
    	});
    }
    //每隔一分钟检查一次当前直播节目
    setInterval( findTheLive , 60000); 	
    
    
    $(".program-content li.p-li ul").delegate("li","click",function(){
    	var _index = $(this).index();
    	$(this).addClass("ac").siblings("li").removeClass("ac") ;
    	videoUrl = $(this).attr("data-url") ;
    	H5Player.x5VideoPlay(videoUrl , true,"images/videoqj.png");
    })
    
    resizeHeight(); 
   
})

function resizeHeight(){
	var windowHeight = $("body").height(),
	    headerHeight = $("header").outerHeight(true),
		introH = $(".live-detail").outerHeight(true),
		dateListH = $(".date-list").outerHeight(true),
		listbox = $('.program-content') ;
		listboxH = windowHeight - headerHeight - introH - dateListH - 20;
		listbox.css("height",listboxH);				
}
$(window).resize(function () {
	H5Player.setX5VideoStyle();
	resizeHeight();
	var angle = window.orientation;
	if (angle == 0) {
		if (H5Player.isX5Video()) {
			$("#video").height(document.documentElement.clientHeight);
		}
	} else {
		if (H5Player.isX5Video()) {
			$("#video").height("100%");
		}
	}
})
		
