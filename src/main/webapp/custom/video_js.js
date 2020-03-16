function select_submit(obj){
	document.form.video_js.value=obj.html;
}
function select_video2(){
	//window.open("../custom/video_content2.jsp");
	var	dialog = new TideDialog();
	dialog.setWidth(570);
	dialog.setHeight(500);
	dialog.setUrl("../custom/video_content2.jsp");
	dialog.setTitle("选择视频");
	dialog.setScroll('auto');
	dialog.setLayer(2);
	dialog.show();
}
var html='<input type="button" class="submit" onclick="select_video2();" value="选择视频"/>';
jQuery("#field_video_js").append(html);