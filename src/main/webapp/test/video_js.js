function select_submit(obj){
	document.form.video_js.value=obj.html;
}
function select_video2(){
	//window.open("../custom/video_content2.jsp");
	var	dialog = new TideDialog();
	dialog.setWidth(810);
	dialog.setHeight(500);
	dialog.setUrl("../custom/video_content_index.jsp?type=2");//表示表单中的视频编码
	dialog.setTitle("选择视频");
	dialog.setScroll('auto');
	dialog.setLayer(2);
	dialog.show();
}
var html='<input type="button" class="submit" onclick="select_video2();" value="选择视频"/>';
jQuery("#field_video_js").append(html);