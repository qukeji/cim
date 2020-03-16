//version 1.0 
var tools = tidecms_tools = tidecms = {
        version:1.0,        
	addBookmark:function(msg)
	{
		Addnum("collect");
		try
	　　 {
	　　 window.external.addFavorite(location.href, document.title);
	　　 }
	　　 catch (e)
	　　 {
	　　 try
	　　 {
	　　 window.sidebar.addPanel(document.title, location.href, "");
	　　 }
	　　 catch (e)
	　　 {
	　　 alert("加入收藏失败，请使用Ctrl+D进行添加");
	　　 }
	　　 }
	},
//视频播放器
	videoPlayer:function(divid,video,width,height)
	{
		var html = '<embed src="/images/video_player.swf?v='+encodeURIComponent(video)+'&volume=0.1&autoPlay=true" allowFullScreen="true" quality="high" width="'+width+'" height="'+height+'" wmode="transparent" align="middle" allowScriptAccess="always" type="application/x-shockwave-flash"></embed>';
	
		$("#"+divid).html(html);
	},
//插入图片集
		showPic:function()
		{
			//window.console.info("info:"+arrayList);
			var arrayList=[];//初始化接收数组
			var photos_level1=eval(tide_photos);
			var photos_level1=photos_level1['items'];
			var photos_level2;
			for(key in photos_level1){
				photos_level2=photos_level1[key];
				arrayList.push({title:photos_level2['title'],summary:photos_level2['summary'],photo:photos_level2['photo'],photo_b:photos_level2['photo_b'],href:'index.shtml',pg:arrayList.length+1})
			};
			//window.console.info("info1:"+arrayList);
			window.arrayList=arrayList;
			img_play({play:'#play',pause:'#pause',btnPrev:'#btnPrev',btnNext:'#btnNext',arrayList:arrayList,refresh:false,interval:2});
	}
}
