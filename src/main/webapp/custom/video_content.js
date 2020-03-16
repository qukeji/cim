//document.form.videostatus.readOnly=true;
jQuery("#tr_videostatus").hide();
function field_videoid(){
var GlobalID=document.form.GlobalID.value;
var Action=document.form.Action.value;
if(GlobalID=='0'){
var url='http://122.11.50.154:890/cms/util/get_video_gid.jsp?ChannelID=4347';
	 jQuery.ajax({
				  type:"GET",
				  url:url,
				  global:false,
				 dataType:"json",
				   success: function(json){
					if(json.length>0){
					GlobalID=json[0].GlobalID;
					document.form.GlobalID.value=GlobalID;
					document.form.Action.value='Update';
					document.form.ItemID.value=json[0].ItemId;
window.open('http://192.168.5.124:8080/pm/index.jsp?user='+userId+'&globalid='+GlobalID+'&catalogcode=&username='+userName+'&usergroup='+userGroupId);
				  }
				   }
				   
				});
}else{
window.open('http://192.168.5.124:8080/pm/index.jsp?user='+userId+'&globalid='+GlobalID+'&catalogcode=&username='+userName+'&usergroup='+userGroupId);
}
}

var videoid=document.form.videoid.value;
if(videoid!=""){
//document.form.videoid.disabled=true;
document.form.videoid.readOnly=true;
}else{
jQuery("#field_videoid").append('<input type="button" value="选择视频" onClick="field_videoid();" class="submit">');
}