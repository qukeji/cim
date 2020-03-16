<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
				java.io.*,
				tidemedia.cms.util.FileUtil,
				tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
int		pageID		= getIntParameter(request,"pageID");
int		moduleID	= getIntParameter(request,"moduleID");


Page p = new Page(pageID);
PageModule pm = new PageModule();

if(moduleID>0)
	pm = new PageModule(moduleID);

if(! new ChannelPrivilege().hasRight(userinfo_session,pageID,ChannelPrivilege.PageContentEdit))
{
	out.println("<script>top.getDialog().Close();</script>");return;
}

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Content			= getParameter(request,"Content");

	p.updateModule(moduleID,Content);
/*
	if(ModuleID==0)
	{
		pm = new PageModule();
		pm.setPage(PageID);
		pm.setTemplate(0);
		pm.setType(2);
		pm.setContent(Content);
		pm.setActionUser(userinfo_session.getId());
		pm.Add();
	}
	else
	{
		pm = new PageModule(ModuleID);
		pm.setContent(Content);
		pm.setActionUser(userinfo_session.getId());
		//pm.setModuleType(2);
		pm.Update();
	}

	if(ModuleID==0)
		p.AddModuleCode(pm,Index);
	else
		p.EditModuleCode(pm);
*/

	out.println("<script>top.TideDialogClose({refresh:'main'});</script>");return;
}

String SiteAddress = p.getSite().getUrl();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/dialog.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/document.js"></script>
<script type="text/javascript" src="../editor/fckeditor.js"></script>
<script language=javascript>
var Pages=1;
var curPage = 1;
var Contents = new Array();
Contents["t1"]="";

function init()
{
	top.TideDialogSetTitle("编辑模块内容");
	top.TideDialogResize(800,550);
}

function initContent1()
{
try{
			var content = '<%=Util.JSQuote(pm.getContent())%>';//alert(content);
			<%if(!SiteAddress.equals("")){%>content = content.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;<%}%>
			SetContent(1,content);
}catch(er){	window.setTimeout("initContent1()",5);}
}

function initContent()
{
	//window.setTimeout("initContent1()",1);
}

function check()
{
	Save_Content();
//	if(isEmpty(document.form.ChannelName,"请选择频道或分类."))
//		return false;
//	if(isEmpty(document.form.SerialNo,"请输入唯一标识编码."))
//		return false;


	return true;
}

function isEmpty(field,msg)
{	
	if(field.value == "")
	{
		alert(msg);
		field.focus();
		return true;
	}
	return false;
}

function selectChannel()
{
	var myObject = new Object();
    myObject.title = "选择频道或分类";

 	var Feature = "dialogWidth:32em; dialogHeight:22em;center:yes;status:no;help:no";
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=channel/select_channel_category.jsp",myObject,Feature);
	if(retu!=null)
	{
		document.form.ChannelName.value = retu.Name;
		document.form.ChannelID.value = retu.ChannelID;
	}
}

function selectTemplate(){
  	 	var Feature = "dialogWidth:34em; dialogHeight:27em;center:yes;status:no;help:no";
		var FileName = window.showModalDialog("../modal_dialog.jsp?target=channel/selecttemplate.jsp",null,Feature);
		if (FileName!=null) {
		  document.form.Template.value=FileName;
		  //var filename;// = FileName.substring(0,FileName.lastIndexOf("."))+".html";
		  document.form.TargetName.value = FileName.substring(FileName.lastIndexOf("/")+1);
		  }
}

function Save_Content()
{
	//保存正文,内容
	//document.ContentEditor.preparesubmit();
	var editor = document.getElementById("FCKeditor1___Frame").contentWindow;
	var FCK			= editor.getFCK() ;
	var FCKConfig	= editor.getFCKConfig();

	var str = FCK.GetXHTML( FCKConfig.FormatSource );
	var localhost = document.location.protocol+ "//" + document.location.hostname;
	if (document.location.port!="80")
  		localhost = localhost + ":" + document.location.port;
<%if(!SiteAddress.equals("")){%>localhost = "<%=SiteAddress%>";<%}%>
		var reg = new RegExp(localhost,"gi");
		//var str = document.all.ContentEditor.GetContent(1);
		str = str.replace(reg, "");

		document.form.Content.value = str;
		document.form.Page.value = "1";
}

function Delete()
{
	if(confirm('你确认要删除吗?')) 
	{
		this.location = "pagemodule_delete.jsp?pageID=<%=pageID%>&ModuleID=<%=moduleID%>&Action=Delete";
	}
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();" scroll="no">
<form name="form" action="pagemodule_add_2.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">


<script type="text/javascript">
<!--

var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath	= '../editor/' ;
oFCKeditor.Height	= 420 ;
//oFCKeditor.Config['FullPage'] = true ;

var content = '<%=Util.JSQuote(pm.getContent())%>';//alert(content);
<%if(!SiteAddress.equals("")){%>content = content.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;<%}%>
oFCKeditor.Value	= content ;

var ChannelID=<%=pageID%>;
oFCKeditor.Create() ;
//-->
		</script>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>

<div class="form_button">
	<input name="startButton" type="submit" class="button" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
<input type="hidden" name="Submit" value="Submit">
	  <input type="hidden" name="ChannelID" value="<%=p.getParent()%>">
	  <input type="hidden" name="pageID" value="<%=pageID%>">
	  <input type="hidden" name="moduleID" value="<%=moduleID%>">
	  <input type="hidden" name="Submit" value="Submit">
	  <input type="hidden" name="Content" value="">
	  <input type="hidden" name="Page" value="">
</div>
</form>
</body>
</html>
