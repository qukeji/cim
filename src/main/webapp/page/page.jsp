<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.page.*,
				tidemedia.cms.util.*,
				java.io.*,
				java.net.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int id			= getIntParameter(request,"id");
int Type	= getIntParameter(request,"Type");//Type=0 维护页面

//if(!(userinfo_session.isAdministrator() || userinfo_session.getUsername().equals("liuyun")))
//{ Type=0;}

if(Type==0)
{
ChannelPrivilege cp = new ChannelPrivilege();
if(!cp.hasRight(userinfo_session,id,ChannelPrivilege.PageContentEdit))
{
	out.println("<script>self.close();</script>");return;
}
}

if(Type==1)
{
ChannelPrivilege cp = new ChannelPrivilege();
if(!cp.hasRight(userinfo_session,id,ChannelPrivilege.PageModuleEdit))
{
	out.println("<script>self.close();</script>");return;
}
}

Page p = new Page(id);

String userName = "";
if(p.getModifiedUser()>0)
	userName = CmsCache.getUser(p.getModifiedUser()).getName();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>页面编辑 - TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />

<style type="text/css">
html{height:100%;overflow:hidden;}
body{height:100%;overflow:hidden;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.draggable.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script language=javascript>
var pageId = <%=id%>;

function init()
{
	window.onresize=reSize;
	reSize();
}

function reSize() {
	document.getElementById("main").style.height = Math.max(document.body.clientHeight - document.getElementById("main").offsetTop, 0) + "px";
	//alert(document.body.clientHeight);
	//alert(document.getElementById("main").offsetTop);
	//document.getElementById("t_menu").style.display = "";
}

function showSource()
{
	$("#startButton").show();
	$("#main").attr("src","page_source.jsp?id=" + pageId);
}

function showEdit()
{	
	$("#startButton").hide();
	$("#main").attr("src","page_edit.jsp?id=" + pageId + "&type=1");
}

function showFrame()
{
	$("#startButton").hide();
	$("#main").attr("src","page_edit.jsp?type=2&id=" + pageId);
}
//function showtidebox(){
	//var tide = new tidebox();
	//tide.frame_1();
	//$("#divPanel")show();
	//$("#divPanel").easydrag();
	//$("#divPanel").setHandler("divTitle");
//}
function pageSave()
{
	window.frames["main"].Save();
}

function preview()
{
	window.open("page_preview.jsp?id="+pageId);
}

function publish()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(240);
	dialog.setUrl("page_publish.jsp?id="+pageId);
	dialog.setTitle("发布页面");
	dialog.setLayer(2);
	dialog.show();
}

function showProperty()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(240);
	dialog.setUrl("property.jsp?id="+pageId);
	dialog.setTitle("属性设置");
	dialog.setLayer(2);
	dialog.show();
}

function showHistory()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(700);
	dialog.setHeight(430);
	dialog.setUrl("page_history.jsp?id="+pageId);
	dialog.setTitle("修改历史");
	dialog.setLayer(2);
	dialog.show();
}

function Save()
{

	tidecms.message("<font color=red>正在保存...</font>");
	var o = $(window.frames["main"].document).find("#tbContentElement");
	if(o)
	{
		var tbContentElement = o.val();

		if(tbContentElement==undefined || tbContentElement===undefined || tbContentElement=="undefined")
		{
			alert("读取内容发生错误，请联系产商检查");
			return;
		}

		$.ajax({
				type:"POST",
				url:"save.jsp",
				data:"id=<%=id%>&Content="+encodeURIComponent(tbContentElement),
				success: function(msg){
					tidecms.notify("保存完成");
					var time = msg.split("&")[0];
					var uname = msg.split("&")[1];
					var txtinfo = uname+" 保存于 "+time;
					$(".edit-info").find(".txt").html(txtinfo);
			}
		}); 
	}
	else
	{
		tidecms.message("<font color=red>没有读取到内容</font>");
	}
}
</script>
</head>
<body onLoad="init();">

<div class="header">
	<div class="logo"><a href="#" title="TideCMS"><img src="../images/logo.png" alt="TideCMS" /></a></div>
    <div class="edit-info" style="width:530px;">
    	<div class="txt"><%=userName%> 保存于 <%=p.getModifiedDate()%></div>
        <ul class="button">
			<!--<li name="startButton" type="submit" class="button" value="保存" id="startButton" onClick="Save();"/>-->
			<li  style="display:none" id="tidecms_notify"><span class="tn_main"></span></li>
			<li id="startButton" name="startButton"  style="display:none"><a href="javascript:Save();"><span>保存</span></a></li>
            <li><a href="javascript:publish();"><span>发布</span></a></li>
            <li><a href="javascript:preview()"><span>预览</span></a></li>
            <li><a href="javascript:self.close();"><span>关闭</span></a></li>
        </ul>
    </div>
    <div class="clear"></div>
</div>
<div class="edit_page_topbar">
	<div class="edit_page_title">网页名称：<%=p.getName()%></div>
<%if(Type>0){%>
<%if(new ChannelPrivilege().hasRight(userinfo_session,id,ChannelPrivilege.PageModuleEdit)){%>
    <div class="edit_page_tools">
    	 
		<div class="tidecms_btn" onClick="showEdit();">
			<div class="t_btn_pic"><img src="../images/icon/page_edit.png" /></div>
			<div class="t_btn_txt">编辑</div>
		</div>
<%}%>
<%if(new ChannelPrivilege().hasRight(userinfo_session,id,ChannelPrivilege.PageFrameEdit)){%>
         
		<div class="tidecms_btn" onClick="showFrame();">
			<div class="t_btn_pic"><img src="../images/icon/page_frame.png" /></div>
			<div class="t_btn_txt">框架</div>
		</div>
<%}%>
<%if(new ChannelPrivilege().hasRight(userinfo_session,id,ChannelPrivilege.PageSourceEdit)){%>
        
		<div class="tidecms_btn" onClick="showSource();">
			<div class="t_btn_pic"><img src="../images/icon/page_source.png" /></div>
			<div class="t_btn_txt">源代码</div>
		</div>
		
        
		<div class="tidecms_btn" onClick="showProperty();">
			<div class="t_btn_pic"><img src="../images/icon/page_property.png" /></div>
			<div class="t_btn_txt">属性</div>
		</div>
<%}%>		
         
		<div class="tidecms_btn" onClick="showHistory();">
			<div class="t_btn_pic"><img src="../images/icon/page_userlist.png" /></div>
			<div class="t_btn_txt">修改记录</div>
		</div>
         
		<div class="tidecms_btn" onClick="">
			<div class="t_btn_pic"><img src="../images/icon/page_main.png" /></div>
			<div class="t_btn_txt">返回控制台</div>
		</div>
    </div>
	<%}%>
</div>
<iframe id="main" name="main" frameborder="0" scrolling1="no" style="width:100%;height:100%;" src="page_edit.jsp?id=<%=id%>&type=<%=Type%>"></iframe>

</body>
</html>