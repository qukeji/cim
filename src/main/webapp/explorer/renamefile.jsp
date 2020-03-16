<%@ page import="java.io.File,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String	FolderName		= getParameter(request,"FolderName");
int	SiteId		= Util.getIntParameter(request,"SiteId");
String	FileName		= getParameter(request,"FileName");
if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}

String NewFileName = getParameter(request,"NewFileName");
if(!NewFileName.equals(""))
{

    Site site=CmsCache.getSite(SiteId);
    String SiteFolder=site.getSiteFolder();
	
	String  Path			= SiteFolder + "/" + FolderName + "/" + FileName;
	String  NewPath			= SiteFolder + "/" + FolderName + "/" + NewFileName;

	//String RealPath = application.getRealPath(Path);
	File file = new File(Path);

	//String NewRealPath = application.getRealPath(NewPath);
	File newfile = new File(NewPath);

	file.renameTo(newfile);

	//new Log().FileLog("重命名","/" + FolderName + "/" + FileName + " -> " + "/" + FolderName + "/" + NewFileName,userinfo_session.getId(),SiteId);
	new Log().FileLog(LogAction.file_edit, "/" + FolderName + "/" + FileName + " -> " + "/" + FolderName + "/" + NewFileName,userinfo_session.getId(),SiteId);
	//发布
	FileUtil fileutil = new FileUtil();
	fileutil.PublishFile("/" + FolderName + "/" + NewFileName,SiteFolder,userinfo_session.getId(),site);

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script src="../common/common.js"></script>
<script type="text/javascript">
function init()
{
	document.form.NewFileName.focus();
	document.form.NewFileName.select();
}

function check()
{
	if(isEmpty(document.form.NewFileName,"请输入文件名."))
		return false;

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
</script>
</head>
<body  onload="init();">
<form name="form" action="renamefile.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
 <tr>
    <td align="right" valign="middle">上级目录：</td>
    <td valign="middle"><%=FolderName%></td>
  </tr>
    <tr>
    <td align="right" valign="middle">原文件名：</td>
    <td valign="middle"><%=FileName%></td>
  </tr>
    <tr>
    <td align="right" valign="middle">新文件名：</td>
    <td valign="middle"><input type="text" name="NewFileName" id="NewFileName"  size="28" value="<%=FileName%>" class="textfield"/></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input type="hidden" name="FolderName" value="<%=FolderName%>">
	<input type="hidden" name="FileName" value="<%=FileName%>">
	<input type="hidden" name="SiteId" value="<%=SiteId%>">
 
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>

</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>