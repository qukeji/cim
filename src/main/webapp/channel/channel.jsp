 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
* 最后修改人		修改时间			备注    
*	张赫东			2013/5/27 17:42		频道删除
*  王海龙		2016/2/15					addTemplate的表单设置改为添加模板
*/
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
Channel channel = CmsCache.getChannel(id);

if(channel==null){out.println("该频道不存在，编号："+id+".");return;}
boolean booleanchild = channel.hasChild();
String CategoryName = "";
String CategorySerialNo = "";

if(channel.getType()==2)
{
	response.sendRedirect("../page/page_info.jsp?id="+id);return;
}

if (channel.getType() == 3) 
{
	response.sendRedirect("app_info.jsp?id=" + id);
		return;
}

String Action = getParameter(request,"Action");

if(Action.equals("ChangeCanCategory"))
{
	int Status = getIntParameter(request,"Status");
	channel.setCanCategory(Status);

	channel.UpdateCanCategory();

	response.sendRedirect("channel.jsp?id="+id);return;
}

if(Action.equals("TemplateInherit"))
{
	int flag = getIntParameter(request,"flag");
	channel.UpdateTemplateInherit(flag);

	response.sendRedirect("channel.jsp?id="+id);return;
}

String PublishModeDesc = "静态发布";

String SiteAddress = channel.getSite().getUrl();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>



<script language=javascript>
var myObject = new Object();

var ChannelID = "<%=channel.getId()%>";
var ChannelName = "<%=tidemedia.cms.util.Util.JSQuote(channel.getName())%>";
var booleanchild=<%=booleanchild%>;
function addTemplate()
{
	var url='channel/template_add.jsp?TemplateType=3&ChannelID=<%=channel.getId()%>';
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle("添加模板");
		dialog.show();
}

function editTemplate(id,type)
{
	var url;
	var title;
	if(id==0){
		title='添加板模'
		url="channel/template_add.jsp?TemplateType="+type+"&ChannelID=<%=channel.getId()%>";
	}
	else{
		title='修改模板'
		url="channel/template_edit.jsp?id="+id+"&ChannelID=<%=channel.getId()%>";
	}
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle(title);
		dialog.show();
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
	var url='channel/form_view.jsp?ChannelID=<%=channel.getId()%>&ShowAll=1&Scrolling=auto';
	var	dialog = new top.TideDialog();
		dialog.setWidth(800);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setScroll('auto');
		dialog.setTitle("表单设置");
		dialog.show();
}

function newChannel()
{
	var url='channel/channel_add_pre.jsp?ChannelID=<%=channel.getId()%>&Type=0';
	url+='&ChannelName=<%=java.net.URLEncoder.encode(channel.getName(),"UTF-8")%>';

	tidecms.dialog(url,400,200,"新建频道");
}
//张赫东 2013/5/28 删除频道判断
function deleteChannel_1()
{
	if(booleanchild==false){

		var  url='channel/channel_deletechannelNoChild.jsp?ChannelID=<%=channel.getId()%>';
		var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(180);
		dialog.setUrl(url);
		dialog.setTitle("删除频道");
		dialog.show();
		
		}else{
	
		var  url='channel/channel_deletechannel.jsp?ChannelID=<%=channel.getId()%>';
		var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(210);
		dialog.setUrl(url);
		dialog.setTitle("删除频道");
		dialog.show();
		}
}

function deleteChannel()
{
		var  url='channel/channel_deletechannel.jsp?ChannelID=<%=channel.getId()%>';		 
		var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(145);
		dialog.setUrl(url);
		dialog.setTitle("删除频道");
		dialog.show();
}

function editChannel()
{
	var  url='channel/channel_edit.jsp?ChannelID=<%=channel.getId()%>';
	var	dialog = new top.TideDialog();
		dialog.setWidth(600);
		dialog.setHeight(450);
		dialog.setUrl(url);
		dialog.setTitle('修改属性');
		dialog.show();
}

function setPrivilege()
{
	var  url='channel/channel_privilege.jsp?ChannelID=<%=channel.getId()%>';
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle('权限设置');
		dialog.setScroll('auto');
		dialog.show();
}

function Publish()
{
	var  url='channel/publish.jsp?ChannelID=<%=channel.getId()%>';
	var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(300);
		dialog.setUrl(url);
		dialog.setTitle('发布频道');
		dialog.show();
}

function ChangeCanCategory(i)
{
	if(i==1)
		this.location = "channel.jsp?Action=ChangeCanCategory&id=<%=channel.getId()%>&Status=1";
	else
		this.location = "channel.jsp?Action=ChangeCanCategory&id=<%=channel.getId()%>&Status=0";
}

function ViewTemplate(TemplateID)
{
  		var url="../template/template_edit.jsp?TemplateID="+TemplateID;
  		if(TemplateID!="")
			window.open(url);
}

function TemplateInherit(flag,id)
{
	var url = "channel.jsp?Action=TemplateInherit&id="+id+"&flag="+flag;
	this.location.href = url;
}

function InheritTemplate()
{
	var  url='channel/template_inherit.jsp?ChannelID=<%=channel.getId()%>';
	var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(300);
		dialog.setUrl(url);
		dialog.setTitle('模板继承');
		dialog.show();
}

function enable(id,flag)
{
	var msg = "确实要";
	if(flag==1) msg += "允许";
	else if(flag==2) msg += "禁止";
	else return;
	msg += "该模板配置吗?";

	if(confirm(msg))
	{
		var url="channel_template_enable.jsp?id="+id+"&flag="+flag;
		$.ajax({type: "GET",url: url,success: function(msg){document.location.href=document.location.href;}});
	}
}

</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%=channel.getName()%></div>


<div class="tidecms_common_tips" id="tidecms_notify" style="margin:6px 0 0 6px;"><div class="tn_top"></div><div class="tct"></div><div class="tn_bot"></div></div>

    <div class="content_new_post">
		
		<div class="tidecms_btn" onClick="newChannel();">
			<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
			<div class="t_btn_txt">新建</div>
		</div>
		
		<%if(!channel.isRootChannel()){%><%if((new UserPerm().canDeleteChannel(userinfo_session))){%>
		<div class="tidecms_btn" onClick="deleteChannel();">
			<div class="t_btn_pic"><img src="../images/icon/del.png" /></div>
			<div class="t_btn_txt">删除频道</div>
		</div>
		<%}%><%}%>

		<div class="tidecms_btn"  onClick="editChannel();">
			<div class="t_btn_pic"><img src="../images/icon/edit.png" /></div>
			<div class="t_btn_txt">修改属性</div>
		</div>
	
		<%if(channel.isTableChannel()){%>
		<div class="tidecms_btn"  onClick="defineForm();">
			<div class="t_btn_pic"><img src="../images/icon/form.png" /></div>
			<div class="t_btn_txt">表单设置</div>
		</div>
		<%}%>
        
    </div>
</div>

 <%if (channel.getType()!=3){%>
<div class="content_2012">
	<div class="toolbar" style="height:80px;">
    	<div style="padding:0 0 3px;">
        	<span class="toolbar1">频道属性：</span>
            <span class="toolbar1">[名称：<span class="font-blue"><%=channel.getName()%></span>　目录名：<span class="font-blue"><%=channel.getFolderName()%></span>　频道地址：<a href="<%=SiteAddress+channel.getFullPath()%>" target="_blank"><span class="font-blue"><%=channel.getFullPath()%></span>　</a>
<input type="hidden" name="tide001" value="<%=channel.getChannelCode()%>"><span title="<%=channel.getChannelCode()%>" onClick="$('#channel_code').show();">编号：<span class="font-blue" ><%=channel.getId()%></span></span>　<span id="channel_code" style="display:none">编号路径：<%=channel.getChannelCode()%>  </span>标识名：<span class="font-blue"><%=channel.getSerialNo()%></span> <%if(channel.getType() == Channel.MirrorChannel_Type){%>镜像频道：<span class="font-blue"><%=channel.getLinkChannel().getName()%></span><%}%>]</span>
			<div class="clear"></div>
        </div>
		<div style="padding:0 0 3px;">
			<span class="toolbar1">频道操作：</span>
            <span class="toolbar1">  
			<input name="Publish" type="button" class="tidecms_btn2" value="发布频道" onClick="Publish()"/>
		  <%if(channel.getTemplateInherit()==1){%>
		  <input name="InheritTemplate" type="button" class="tidecms_btn2" value="模板继承" onClick="InheritTemplate()"/><%}%></span>
			<div class="clear"></div>
		</div>
		<div style="padding:0 0 3px;">
			<span class="toolbar1">模板设置：</span><span class="toolbar1">
			
			<input name="Button4" type="button" class="tidecms_btn2" value="添加模板" onClick="addTemplate()"/></span>
			<div class="clear"></div>
		</div>
    </div>
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1"	align="center" valign="middle" width="100">类型</th>
    				<th class="v8"  align="center" valign="middle">模板</th>
    				<th class="v4"  align="left" valign="middle" style="padding-left:10px;">目标文件</th>
    				<th class="v9" align="center" valign="middle" width="100">>></th>
  		</tr>
</thead>
 <tbody>
 <%
int IsInherit = 0;
ArrayList cts = channel.getChannelTemplates(1);
if(cts!=null && cts.size()>0)
{
	for(int i = 0;i<cts.size();i++)
	{
		ChannelTemplate ct = (ChannelTemplate)cts.get(i);
		String TargetName = ct.getTargetName();
		int id_ = ct.getId();
		int templateID=ct.getTemplateID();
		TemplateFile tf = CmsCache.getTemplate(templateID);
%>
  <tr>
	<td class="v1" align="center" valign="middle">索引页面模板</td>
    <td class="v8"  title="<%=tf.getGroupTree()%>"><%=tf.getFileName()%> <%=ct.getLabel()%></td>
     <td class="v4"  style="color:#666666;"><a href="<%=Util.ClearPath(SiteAddress+(TargetName.startsWith("/")?"":channel.getFullPath()+"/")+TargetName)%>"
							target="_blank"><span class="font-blue"><%=TargetName%></span></a></td>
	<td class="v9">
	<div class="v9_button" onclick="editTemplate('<%=id_%>',1);"><img src="../images/property.gif" title="设置" /></div>
<%if (templateID>0) {%>
<div class="v9_button" onclick="ViewTemplate('<%=templateID%>');"><img src="../images/preview.gif" title="查看" /></div>
	<div class="v9_button" onclick="deleteTemplate(<%=id_%>);"><img src="../images/del2.gif" title="删除" /></div>
	<%if(ct.getActive()==1){%><a href="javascript:enable(<%=id_%>,2)"><img src="../images/icon/02.png"></a><%}else if(ct.getActive()==0){%>
	<a href="javascript:enable(<%=id_%>,1)"><img src="../images/icon/01.png"></a><%}%>
	<%}%>
	</td>
  </tr>
<%}
}else{%>
  <tr>
	<td class="v1" align="center" valign="middle">索引页面模板</td>
    <td class="v8"></td>
     <td class="v4"  style="color:#666666;"></td>
	<td class="v9">
		<div class="v9_button" onclick="editTemplate('0',1);"><img src="../images/property.gif" title="设置" /></div></td>
  </tr>
<%}cts = channel.getChannelTemplates(2);
if(cts!=null && cts.size()>0)
{
	for(int i = 0;i<cts.size();i++)
	{
		ChannelTemplate ct = (ChannelTemplate)cts.get(i);
		String TargetName = ct.getTargetName();
		int id_ = ct.getId();
		int templateID=ct.getTemplateID();
		TemplateFile tf = CmsCache.getTemplate(templateID);%>
  <tr>
	<td class="v1" align="center" valign="middle">内容页面模板</td>
    <td class="v8"  title="<%=tf.getGroupTree()%>"><%=tf.getFileName()%> <%=ct.getLabel()%></td>
     <td class="v4"  style="color:#666666;"><a
							href="<%=SiteAddress+(TargetName.startsWith("/")?"":channel.getFullPath()+"/")+TargetName%>"
							target="_blank"><span class="font-blue"><%=TargetName%></span></a></td>
	<td class="v9">
		<div class="v9_button" onclick="editTemplate('<%=id_%>',2);"><img src="../images/property.gif" title="设置" /></div>
<%if (templateID>0) {%><div class="v9_button" onclick="ViewTemplate('<%=templateID%>');"><img src="../images/preview.gif" title="查看" /></div>
	<div class="v9_button" onclick="deleteTemplate(<%=id_%>);"><img src="../images/del.gif" title="删除" /></div>
	<%if(ct.getActive()==1){%><a href="javascript:enable(<%=id_%>,2)"><img src="../images/icon/02.png"></a><%}else if(ct.getActive()==0){%>
	<a href="javascript:enable(<%=id_%>,1)"><img src="../images/icon/01.png"></a><%}%>	
	<%}%>
	</td>
  </tr>
<%}
}else{%>
  <tr>
	<td class="v1" align="center" valign="middle">内容页面模板</td>
    <td class="v8"></td>
     <td class="v4"  style="color:#666666;"></td>
	<td class="v9">
		<div class="v9_button" onclick="editTemplate('0',2);"><img src="../images/property.gif" title="设置" /></div></td>
  </tr>
<%}%>
   <tr>
	<td class="v1" align="center" valign="middle">……</td>
    <td class="v8">……</td>
     <td class="v4"  style="color:#666666;">……</td>
	<td class="v9">……</td>
  </tr>
<%
cts = channel.getChannelTemplates(3);
if(cts!=null && cts.size()>0)
{
	for(int i = 0;i<cts.size();i++)
	{
		ChannelTemplate ct = (ChannelTemplate)cts.get(i);
		String TargetName = ct.getTargetName();
		int id_ = ct.getId();
		int templateID=ct.getTemplateID();
		TemplateFile tf = CmsCache.getTemplate(templateID);
%>
  <tr>
	<td class="v1" align="center" valign="middle">附加页面模板</td>
    <td class="v8"  title="<%=tf.getGroupTree()%>"><%=tf.getFileName()%> <%=ct.getLabel()%></td>
     <td class="v4"  style="color:#666666;"><a
							href="<%=SiteAddress+(TargetName.startsWith("/")?"/":channel.getFullPath()+"/")+TargetName%>"
							target="_blank"><span class="font-blue"><%=TargetName%></span></a></td>
	<td class="v9">
		<div class="v9_button" onclick="editTemplate('<%=id_%>',3);"><img src="../images/property.gif" title="设置" /></div>
	<div class="v9_button" onclick="ViewTemplate('<%=templateID%>');"><img src="../images/preview.gif" title="查看" /></div>
	<div class="v9_button" onclick="deleteTemplate(<%=id_%>);"><img src="../images/del.gif" title="删除" /></div>
		<%if(ct.getActive()==1){%><a href="javascript:enable(<%=id_%>,2)"><img src="../images/icon/02.png"></a><%}else if(ct.getActive()==0){%>
	<a href="javascript:enable(<%=id_%>,1)"><img src="../images/icon/01.png"></a><%}%>
	</td>
  </tr>
<%}
}%>
 </tbody> 
</table>
        </div>   
        <div class="viewpane_pages"> </div>
  </div>
</div>
<%}%>

<!--16ms-->
</body>
</html>