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

Channel channelParentParent = new Channel(channel.getParent());
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<style>
html,body{
	width: 100%;
	height: 100%;
}
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script type="text/javascript">
var booleanchild=<%=booleanchild%>;
var ChannelID = "<%=channel.getId()%>";
var channelParent = "<%=channel.getParent()%>";
var channelParentParent = "<%=channelParentParent.getId()%>"

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
		
        var url = "channel_delete2018.jsp?Action=Delete&id="+ChannelID;
		$.ajax({type:"get",dataType:"json",url: url,success: function(msg){
			if(channelParent == -1){
				top.TideDialogClose({refresh:'left',returnNavValue:{currentid:ChannelID,parentid:-1,type:2,site:true}});
			}else if(channelParentParent==-1){
				top.TideDialogClose({refresh:'left',returnNavValue:{currentid:ChannelID,parentid:channelParent,type:2,site:true}});
			}else{
			    top.TideDialogClose({refresh:'left',returnNavValue:{currentid:ChannelID,parentid:channelParent,type:2,site:false}});
			}
	//top.tidecms.message2("","TideDialog_"+top.tidecms.dialognumber);  后注释的
			//parent.tidecms.notify("删除成功");
			//parent.top.tidecms.getLeftIfm().action({action:3,id:ChannelID});
			//parent.top.tidecms.getLeftIfm().action({action:3,id:ChannelID});
			//parent.top.tidecms.getLeftIfm().action({action:3,id:ChannelID});
			
	//top.TideDialogClose('');    后注释的
		}});		
		
	}
	
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
			//top.TideDialogClose('');
			return true;
		}	
	}else{
		
		dChannel();
		$("#startButton").attr("disabled",true);
		//document.form.startButton.disabled  = true;
	}
	
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

</head>
<body>
	<div class="bg-white modal-box">
		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
			<div class="config-box">
				<ul>
					<li class="block">
						<div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title"><span style="color:red">警告</span>：频道被删除后不能恢复，</label>
			              <label class="wd-230" id="SuperChannelName">
			                <span id="delchild" name="delchild" name="Title">而且其下面的子频道将一并删除!</span>
			              </label>									            
	       		  		</div>
						<div class="row" id="hdiv">   
						  <label class="wd-230">
			                <input class="form-control" placeholder="" type="text" id="channelName2" name="Name2" style="width:90%">
			              </label>	
	   		  	  		  <label class="left-fn-title"><span id="Title"  name="Title">请输入要删除的频道名称</span></label>
	       		  		</div>
					</li>
				</ul>
			</div>
		</div>

		<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
      		<div class="modal-footer" >
				<input type="hidden" id="ChannelID" name="ChannelID" value="<%=ChannelID%>">
				<input type="hidden" id="Icon" name="Icon" value="<%=channel.getIcon()%>">
				<button name="startButton" type="button" class="btn btn-primary tx-size-xs"  id="startButton" onClick="check()">确认</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		    </div> 
		</div>	
	</div>
</body>
</html>
