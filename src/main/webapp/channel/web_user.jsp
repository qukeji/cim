 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../config.jsp"%>
<script type="text/javascript" src="../common/common.js"></script>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

	int id = getIntParameter(request, "id");
	Channel channel = new Channel();
	if(id<=0){
		channel = CmsCache.getChannel(id);
	}
	else{
		channel = CmsCache.getChannel(id);
	}
	
	String CategoryName = "";
	String CategorySerialNo = "";

	String Action = getParameter(request, "Action");

	if (Action.equals("ChangeCanCategory")) 
	{
		int Status = getIntParameter(request, "Status");
		channel.setCanCategory(Status);

		channel.UpdateCanCategory();

		response.sendRedirect("channel.jsp?id=" + id);
			return;
	}

	String PublishModeDesc = "";
	PublishModeDesc = "静态发布";
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script language=javascript>

	var myObject = new Object();
	myObject.ChannelID = "<%=channel.getId()%>";
	myObject.ChannelName = "<%=channel.getName()%>";
	myObject.Type = "<%=channel.getType()%>";

function addTemplate()
{
    myObject.title = "添加模板";
	myObject.ChannelID = "<%=channel.getId()%>";
	myObject.ChannelName = "<%=channel.getName()%>";
	
	var url1 = "../modal_dialog.jsp?target=channel/template_add.jsp&TemplateType=3&ChannelID=<%=channel.getId()%>";
	var url2 = "template_add.jsp?TemplateType=3&ChannelID=<%=channel.getId()%>";
	
	var retu= showModal(580,530,url1,url2,myObject);
	if(retu!=null)
	window.location.reload();
}

function editTemplate(id,type)
{
    myObject.title = "添加模板";
	myObject.ChannelID = "<%=channel.getId()%>";
	myObject.ChannelName = "<%=channel.getName()%>";
	myObject.TemplateType = type;
	
	if(id==0)
	{
	    var url1 = "../modal_dialog.jsp?target=channel/template_add.jsp&TemplateType="+type+"&ChannelID=<%=channel.getId()%>";
		var url2 = "template_add.jsp?TemplateType="+type+"&ChannelID=<%=channel.getId()%>";
		
		var retu = showModal(500,550,url1,url2,myObject);
	}
	else
	{
		var url1 = "../modal_dialog.jsp?target=channel/template_edit.jsp&id="+id+"&ChannelID=<%=channel.getId()%>";
		var url2 = "template_edit.jsp?id="+id+"&ChannelID=<%=channel.getId()%>";

		var retu = showModal(500,550,url1,url2,myObject);
	}
		if(retu!=null)
		window.location.reload();
}

function deleteTemplate(i)
{
	if(confirm('你确认要删除吗?')) 
	{
		this.location = "channel_template_delete.jsp?Action=Delete&id="+i+"&ChannelID=<%=channel.getId()%>";
	}
}

function defineForm()
{
    myObject.title = "表单定义";
	
	var url1 = "../modal_dialog.jsp?target=channel/form.jsp";
	var url2 = "form.jsp";
	
	var retu = showModal(500,550,url1,url2,myObject);
	if(retu!=null)
	window.location.reload();
}

function newChannel()
{
    myObject.title = "新建频道";
	myObject.Type = 0;

	myObject.ChannelID = <%=channel.getId()%>;
	myObject.ChannelName = "<%=channel.getName()%>";

	var url1 = "../modal_dialog.jsp?target=channel/channel_add.jsp";
	var url2 = "channel_add.jsp";
	
	var retu = showModal(500,550,url1,url2,myObject);
	if(retu!=null)
	parent.menu.location.reload();
}

function deleteChannel()
{
		var ChannelID = <%=channel.getId()%>;
		var ChannelName = "<%=channel.getName()%>";
		if(confirm("确实要删除\"" + ChannelName + "\"吗?\r\n注意：频道被删除后不能恢复，而且其下面的子频道将一并删除!")) 
		{
			parent.location = "channel_delete.jsp?From=1&Action=Delete&id="+ChannelID;
		}
}

function editChannel()
{
    myObject.title = "编辑频道";
	myObject.Type = 0;
	myObject.ChannelID = <%=channel.getId()%>;
	myObject.ChannelName = "<%=channel.getName()%>";

	var url1 = "../modal_dialog.jsp?target=channel/channel_edit.jsp&ChannelID="+myObject.ChannelID;
	var url2 = "channel_edit.jsp?ChannelID="+myObject.ChannelID;
	
	var retu = showModal(500,550,url1,url2,myObject);
	if(retu!=null)
	parent.menu.location.reload();
	window.location.reload();
}

function setPrivilege()
{
    myObject.title = "权限设置";
	myObject.Type = 0;
	myObject.ChannelID = <%=channel.getId()%>;
	myObject.ChannelName = "<%=channel.getName()%>";
 	
	var url1 = "../modal_dialog.jsp?target=channel/channel_privilege.jsp&ChannelID="+myObject.ChannelID;
	var url2 = "channel_privilege.jsp?ChannelID="+myObject.ChannelID;
	
	var retu = showModal(600,450,url1,url2,myObject);
	if(retu!=null)
	parent.menu.location.reload();
}

function Publish()
{
    myObject.title = "发布频道";
	myObject.Type = 0;
	myObject.ChannelID = <%=channel.getId()%>;
	myObject.ChannelName = "<%=channel.getName()%>";
 	
	var url1 = "../modal_dialog.jsp?target=channel/publish_webuser.jsp&ChannelID="+myObject.ChannelID;
	var url2 = "publish_webuser.jsp?ChannelID="+myObject.ChannelID;
	
	var retu = showModal(350,300,url1,url2,myObject);
	
	if(retu!=null)
		window.location.reload();
}

function ChangeCanCategory(i)
{
	if(i==1)
		this.location = "channel.jsp?Action=ChangeCanCategory&id=<%=channel.getId()%>&Status=1";
	else
		this.location = "channel.jsp?Action=ChangeCanCategory&id=<%=channel.getId()%>&Status=0";
}

function ViewTemplate(TemplateFile)
{
		var foldername = "";
		var filename = "";
	  	var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;

		if(TemplateFile.lastIndexOf("/")!=-1)
		{
			filename = TemplateFile.substring(TemplateFile.lastIndexOf("/")+1);
			foldername = TemplateFile.substring(0,TemplateFile.lastIndexOf("/"));
		}
		
  		var url="../template/notepad.jsp?FolderName="+foldername+"&FileName=" + filename;
  		if(filename!="")
			window.open(url,"",Feature);
}

function editApp()
{
    myObject.title = "编辑应用属性";
	myObject.Type = 3;
	myObject.ChannelID = <%=id%>;
	myObject.ChannelName = "<%=channel.getParentChannel().getName()%>";

	var url1 = "../modal_dialog.jsp?target=channel/app_edit.jsp&ChannelID="+myObject.ChannelID+"&Type=3";
	var url2 = "app_edit.jsp?ChannelID="+myObject.ChannelID+"&Type=3";

	var retu = showModal(530,400,url1,url2,myObject);
	if(retu!=null)
	{
		parent.menu.location.reload();
		window.location.reload();
	}
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0"
	cellspacing="0">
	<tr>
		<td valign="top">
		<table width="100%" height="38" border="0" cellpadding="0"
			cellspacing="0" class="box-tint">
			<tr>
				<td align="right">
				<%if (channel.getType()!=4){%>  
				<a href="javascript:editApp();">
					<img src="../images/icon_modifichannel_s.gif" width="32" height="32" align="absmiddle" border="0"> 
						修改模块属性 
				</a>
				<%}%> 
				<%if (channel.isTableChannel()||channel.getType()==4) {%>
				<a href="javascript:defineForm();">
					<img src="../images/icon_fromchannel_s.gif" width="32" height="32" align="absmiddle" border="0"> 
						表单设置 
				</a> 
				<%}%> 
				<a href="javascript:setPrivilege();">
					<img src="../images/icon_userchannel_s.gif" width="32" height="32" align="absmiddle" border="0"> 
						权限设置 
						</span> 
				</a>
				</td>
				<td width="20" align="right"></td>
			</tr>
		</table>
		<br>
		<table width="98%" border="0" align="center" cellpadding="0"
			cellspacing="10">
			
			<%if (channel.getType() == 4)
			  {
				WebUser w = new WebUser(id);
			%>
			<tr>	
				<td>应用属性：</td>
          		<td>
          		[应用名称：<span class="font-blue"><%=channel.getName()%></span> 　　
          		页面地址：<a href="<%=channel.getSite().getUrl()+"/"+w.getFullTargetName()%>" target="_blank">
          		<span class="font-blue"><%=w.getTargetName()%>　　</span>
          		</a>
          		编号：<span class="font-blue"><%=channel.getId()%></span>　　]
          		</td>
          	</tr>
          	<%
          		if(!w.getTemplate().equals("")){
          	%>
          	<tr>
				<td>发布方式：</td>
				<td>
					<input type=button class="tidecms_btn3" name="Publish" value="发布应用" onClick="Publish()"> <%//}%>
				</td>
			</tr>
			<%}}%>
			
			<%if (channel.getType()==4){%>
			<tr>
				<td valign="top">应用模板：</td>
				<td>
				<table width="100%" border="0" cellpadding="4" cellspacing="1"
					bgcolor="#6699BF">
					<tr align="center" bgcolor="#96B9D3">
						<td width="80">类型</td>
						<td>路径</td>
						<td>对应的程序名</td>
						<td width="76">模板操作</td>
					</tr>
					<%
						String Template = "";
						String TargetName = "";

						int id_ = 0;
						int IsInherit = 0;

						String Sql = "select * from channel_template where TemplateType=6 and Channel="+ channel.getId();
						ResultSet rs = channel.executeQuery(Sql);

						if (rs.next()) {
							id_ = rs.getInt("id");
							Template = convertNull(rs.getString("Template"));
							TargetName = convertNull(rs.getString("TargetName"));
							IsInherit = rs.getInt("IsInherit");
						}

						channel.closeRs(rs);
					%>
					<tr bgcolor="#FFFFFF" <%=(IsInherit==1)?"class='rows2'":""%>>
						<td align="center">应用页面模板</td>
						<td><span class="font-blue"><%=Template%></span></td>
						<td>
							<a href="<%=channel.getSite().getUrl()+(TargetName.startsWith("/")?"":channel.getFullPath()+"/")+TargetName%>"target="_blank">
								<span class="font-blue"><%=TargetName%></span>
							</a>
						</td>
						<td>
							<input name="Submit21" type="button" class="tidecms_btn3" value="设置" onClick="editTemplate('<%=id_%>',6);">&nbsp;
							<%if (id_ > 0 && !Template.equals("")) {%>
							<input name="Submit2" type="button" class="tidecms_btn3" value="查看" onClick="ViewTemplate('<%=Template%>');"> 
							<input name="Submit2" type="button" class="tidecms_btn3" value="删除" onClick="deleteTemplate(<%=id_%>);">
							<%}%>
						</td>
					</tr><%}%>
				</table>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td height="13">&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</body>
</html>

