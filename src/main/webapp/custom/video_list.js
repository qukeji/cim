function Preview2(itemid){
		var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(430);
		dialog.setUrl("util/showvideo.jsp?ItemID=" + itemid + Parameter);
		dialog.setTitle("播放视频");
		dialog.show();
}

function chankan(){
	window.open("http://autobus.vodone.com/videoEncode/");
}
var html='<a class="first" href="javascript:chankan();">转码</a>';
jQuery("div.content_new_post").prepend(html);