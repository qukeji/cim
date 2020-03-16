<%@ page import="tidemedia.cms.system.Channel,
				tidemedia.cms.system.CmsCache"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
/*
 *  修改人		修改时间		备注
 *  王海龙		20130711		添加了复制视频html代码 使用ZeroClipboard.js处理跨浏览器复制功能 增加了copy() initCopy方法 删除了copyToClipboard()方法
 *  王海龙		20140225		视频预览 可以选择不同码率预览
 */
  int id = getIntParameter(request,"id");
  int channelid = getIntParameter(request,"channelid");
  Channel channel = CmsCache.getChannel(channelid);
  String externalurl= channel.getSite().getExternalUrl();
  String baseurl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"; 

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/ZeroClipboard.js"></script>
<script type="text/javascript" src="../common/videoPlayer.js"></script>
<script type="text/javascript" charset="utf-8">
      
function copy(id)
{ 
	var clip = new ZeroClipboard($("#"+id), {
		  moviePath: "../common/ZeroClipboard.swf"
		});
		
		clip.addEventListener( "complete", function(){      
			alert("复制成功！");       
		}); 	 
}  

function initCopy()
{
	$.ajax({
		url:"list_transcode_videos.jsp",
		data:"id=<%=id%>&channelid=<%=channelid%>",
		type:"post",
		dataType:"json",
		success:function(data) 
		{
			var html ='<label>码率选择</label> <select name="video_select" id="video_select" onchange="change(this);">';
			var content = "";
			$.each(data,function(index,obj){	
				var flv = obj.flv;	
				html +='<option value="'+obj.title+'" flv="'+flv+'" >'+obj.title+'</option>';				
				if(index==0)//默认显示第一个			
					changeContent(flv);
				 
			});
			html +="</select>";
            $(".v_pre_select").html(html);
		}
	
	});	 
	
       	top.$("#TideDialogClose").click(function(){
		top.$(".v_pre_select").remove("");//先移除码率选择下拉框
	});
	copy("html_code_button");
	copy("player_code_button");
	copy("player_code_url_button");		

}

//下拉框change事件
function change(data)
{
	var flv = $(data).children('option:selected').attr("flv");
	//var vtype =$(data).children('option:selected').attr("vtype");
	changeContent(flv);
}

  //弹出窗内容切换
function changeContent(flv)
{
	var htmlCode = "<script src=\"<%=baseurl%>\/common\/videoPlayer.js\"><\/script><script>showPlayer({json:\""+flv+"\"});<\/script>";
	var inputs ="<embed name=\"TIDE_PLAYER_0\" width=\"640\" height=\"512\" src=\"<%=baseurl%>common/v.swf\" wmode=\"opaque\" allowfullscreen=\"true\" allowscriptaccess=\"always\"				flashvars=\"video="+flv+"&skin=0,0,0,0&autoplay=true\" type=\"application/x-shockwave-flash\"></embed>";
	
	$("#player_code").val(inputs);
	$("#player_code_url").val(flv);
	$("#html_code").val(htmlCode);
    $(".con_video_content").html('<script>showPlayer({video:"'+flv+'",width:640,height:480,divid:"con_video_content"});<\/script>');

}

</script>
</head>
<body onload="initCopy();">
<div class="con_video_content" id="con_video_content">
<script>showPlayer({video:"",width:640,height:480,divid:"con_video_content"});</script>
</div>
  <div class="vms_video_code" id="vms_video_code" >
     <div class="v_pre_select" style="margin:0px;"></div>
    <div class="v_v_c_item">
        <div class="v_v_c_i_title"><input type='button' id = "player_code_button" class="tidecms_btn3"  data-clipboard-target="player_code" 
        data-clipboard-text="Default clipboard text from attribute" value="复制">embed代码：</div>
        <textarea id="player_code"> </textarea>
    </div>
    <div class="v_v_c_item">
        <div class="v_v_c_i_title"><input type='button' id = "player_code_url_button"  
        class="tidecms_btn3"  data-clipboard-target="player_code_url" data-clipboard-text="Default clipboard text from attribute"  
        value="复制">视频路径：</div>
        <textarea id="player_code_url"></textarea>
    </div>
     <div class="v_v_c_item">
        <div class="v_v_c_i_title"><input type='button' id="html_code_button" class="tidecms_btn3"  
        data-clipboard-target="html_code" data-clipboard-text="Default clipboard text from attribute" value="复制">html代码：</div>
        <textarea id="html_code"></textarea>
    </div>
   
 </div>
  
</body>
</html>
