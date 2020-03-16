<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.page.*,
				tidemedia.cms.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

Channel channel = CmsCache.getChannel(id);

Page p = new Page(id);

String CategoryName = "";
String CategorySerialNo = "";

//if(channel.getType()==2)
//{
//	response.sendRedirect("page.jsp?id="+id);return;
//}

String Action = getParameter(request,"Action");

if(Action.equals("ChangeCanCategory"))
{
	int Status = getIntParameter(request,"Status");
	channel.setCanCategory(Status);

	channel.UpdateCanCategory();

	response.sendRedirect("channel.jsp?id="+id);return;
}

String PublishModeDesc = "";
PublishModeDesc = "静态发布";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script language=javascript>

function Page()
{
	  	var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		//var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;

  		var url="../page/page.jsp?id=<%=id%>&Type=1";
		//window.open(url,"",Feature);
		window.open(url,"");
}

function Content()
{
	  	var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		//var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;

  		var url="../page/page.jsp?id=<%=id%>";
		//window.open(url,"",Feature);
		window.open(url,"");
}

function editPage()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(350);
	dialog.setUrl("page/page_edit2.jsp?ChannelID=<%=id%>");
	dialog.setTitle("页面属性");
	dialog.show();
}

function deletePage()
{
	var ChannelID = <%=id%>;
	var ChannelName = "<%=channel.getName()%>";

	if(confirm("确实要删除\"" + ChannelName + "\"吗?\r\n警告：页面被删除后不能恢复，如果下面有子频道也将一并删除!")) 
	{
		var channel_tree_id_path = tidecms.getCookie("channel_path");//alert(channel_tree_id_path);
		if(channel_tree_id_path)
		{
			channel_tree_id_path = channel_tree_id_path.replace(ChannelID, "");
			tidecms.setCookie("channel_path",channel_tree_id_path);
		}

		tidecms.message("正在删除...");
		var url = "../channel/channel_delete.jsp?Action=Delete&id="+ChannelID;
		$.ajax({type:"get",dataType:"json",url: url,success: function(msg){
			tidecms.notify("删除成功");
			top.tidecms.getLeftIfm().action({action:3,id:ChannelID});
		}}); 
	}
}
</script>
</head>

<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%=channel.getName()%></div>

<div class="tidecms_notify" id="tidecms_notify" style="margin:6px 0 0 6px;">
	<div class="tn_top"></div>
	<div class="tn_main"></div>
	<div class="tn_bot"></div>
</div>

    <div class="content_new_post">
	<%if(!channel.isRootChannel()){%>

				 
				<div class="tidecms_btn" onClick="deletePage();">
					<div class="t_btn_pic"><img src="../images/icon/del.png" /></div>
					<div class="t_btn_txt">删除页面</div>
				</div>
	
	<%}%>
	
				 
				<div class="tidecms_btn" onClick="editPage();">
					<div class="t_btn_pic"><img src="../images/icon/edit.png" /></div>
					<div class="t_btn_txt">修改属性</div>
				</div>
	</div>
    
</div>
 
 <%if (channel.getType()!=3){%>
<div class="content_2012">
	<div>
    	<div style="padding:0 0 12px;">
        	<span class="toolbar1">页面属性：</span>
            <span class="toolbar1">[名称：<span class="font-blue"><%=channel.getName()%></span> 　　页面地址：<a href="<%=Util.ClearPath(p.getSite().getUrl()+"/"+p.getFullTargetName())%>" target="_blank"><span class="font-blue"><%=p.getTargetName()%>　　</span></a>编号：<span class="font-blue"><%=channel.getId()%></span>　　]</span>
			<div class="clear"></div>
        </div>

		<div style="padding:0 0 3px;line-height:24px">
			<span class="toolbar1">操作：</span>
            <span class="toolbar1">
 
			<input name="Publish" type="button" class="tidecms_btn2" value="维护页面" onClick="Content()"/>
<%if(userinfo_session.isAdministrator() || userinfo_session.getUsername().equals("liuyun")){%>
		 
		  <input name="Publish" type="button" class="tidecms_btn2" value="编辑页面" onClick="Page()"/>
		  <%}%></span>
			<div class="clear"></div>
		</div>

    </div>
</div><%}%>
 
</body>
</html>
