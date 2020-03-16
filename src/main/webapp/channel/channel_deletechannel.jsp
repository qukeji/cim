<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
* 最后修改人		修改时间			备注    
*	张赫东			2013/5/27 17:42		频道删除--->删除含有子集的频道
*   张赫东          2013/5/28 17:41     不刷新页面直接提示删除频道信息
*/
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
int ChannelID = getIntParameter(request,"ChannelID");
Channel channel = new Channel(ChannelID);
//boolean booleanchild = channel.hasChild();
boolean booleanchild =true;
String IconFolder = request.getContextPath() + "/images/channel_icon/";
String Name = getParameter(request,"Name");
String Name2 = getParameter(request,"Name2");//填写的频道名称

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>

<script type="text/javascript">
var booleanchild=<%=booleanchild%>;
var ChannelID = "<%=channel.getId()%>";
var ChannelName = "<%=tidemedia.cms.util.Util.JSQuote(channel.getName())%>";
function showTab(form,form_td)
{
	var num = 5;
	for(i=1;i<=num;i++)
	{
		jQuery("#form"+i).hide();
		jQuery("#form"+i+"_td").removeClass("cur");
	}
	
	jQuery("#"+form).show();
	jQuery("#"+form_td).addClass("cur");
}

function dChannel(){
		//alert("执行了dchannel");
		var channel_tree_id_path = getCookie("channel_path");//
		
		if(channel_tree_id_path)
		{
			channel_tree_id_path = channel_tree_id_path.replace(ChannelID, "");
			//document.cookie = "channel_path=" + channel_tree_id_path;//alert(document.cookie);
			tidecms.setCookie("channel_path",channel_tree_id_path);
		}
        top.tidecms.message2("正在删除...","TideDialog_"+top.tidecms.dialognumber);
		
        var url = "channel_delete.jsp?Action=Delete&id="+ChannelID;
		$.ajax({type:"get",dataType:"json",url: url,success: function(msg){
			top.tidecms.message2("","TideDialog_"+top.tidecms.dialognumber);
			//parent.tidecms.notify("删除成功");
			//parent.top.tidecms.getLeftIfm().action({action:3,id:ChannelID});
			//parent.top.tidecms.getLeftIfm().action({action:3,id:ChannelID});
			parent.top.tidecms.getLeftIfm().action({action:3,id:ChannelID});
			top.TideDialogClose('');
		}});		
		
	}
</script>
<!--判断是否有子频道 页面加载时自动执行的函数 如果有子频道自动隐藏输入框及提示信息 张赫东 2013/5/29-->
<script>
$(function(){
if(booleanchild==false){
		$("#hdiv").hide();
		$("#delchild").html("请慎重删除！");
	}
});
</script>
<style> 
.edit-main{margin:0;position:Static;}
.edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
.edit-con{position:Static;margin:-1px 0 0;}
.edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
</style>
</head>
<body>
	<div class="openwin_iframe" id="popDiviframe" name="popDiviframe"><div class="content_2012">
	<table width="100%" border="0">
  <tr>
    <td><div><span style="color:red">警告</span>：频道被删除后不能恢复，
	<span id="delchild" name="delchild" name="Title">而且其下面的子频道将一并删除!</span></div></td>
  </tr>
  <tr><td> </td></tr>
  <tr>
    <td><div id="hdiv"><input id="channelName2" type="text" name="Name2" class="textfield" width="35"/>  
	<span id="Title"  name="Title">请输入要删除的频道名称</span></div></td>
  </tr>
</table>

	</div>
	</div>
<div class="form_button">
	<input type="hidden" id="ChannelID" name="ChannelID" value="<%=ChannelID%>">
	<input type="hidden" id="Icon" name="Icon" value="<%=channel.getIcon()%>">
	<input name="startButton" type="button" class="tidecms_btn2" value="确定"  id="startButton" onClick="check()"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>

<script>
function check()
{	
	if(booleanchild==true){
		var Name2=$("#channelName2").val();//jquery 获得input的value
		var channelname="<%=channel.getName()%>";
			
		if(Name2==""){
			$("#Title").html("频道名称输入不能为空，请重新输入。");
			return false;
		}	
		if(Name2!=channelname){
			$("#Title").html("频道名称输入不正确，请重新输入。");
			return false;
		}
		
		if(Name2==channelname){
			dChannel();
			//document.form.startButton.disabled  = true;
			$("#startButton").attr("disabled",true);
			return true;
		}
	
	}else{
		
		dChannel();
		$("#startButton").attr("disabled",true);
		//document.form.startButton.disabled  = true;
	}
}
</script>
</body>
</html>
