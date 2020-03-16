<%@ page import="java.io.File,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String	FileName		= getParameter(request,"FileName");

String NewFileName = getParameter(request,"NewFileName");
if(!NewFileName.equals(""))
{
	String	FolderName		= getParameter(request,"FolderName");
	//int	SiteId		= Util.getIntParameter(request,"SiteId");
    Site site=CmsCache.getDefaultSite();
    //String SiteFolder=site.getSiteFolder();
	String SiteFolder=site.getBackupFolder();
	String  Path			= SiteFolder + "/" + FolderName + "/" + FileName;
	String  NewPath			= SiteFolder + "/" + FolderName + "/" + NewFileName;

	//String RealPath = application.getRealPath(Path);
	File file = new File(Path);

	//String NewRealPath = application.getRealPath(NewPath);
	File newfile = new File(NewPath);

	file.renameTo(newfile);

	//new Log().FileLog("重命名","/" + FolderName + "/" + FileName + " -> " + "/" + FolderName + "/" + NewFileName,userinfo_session.getId(),SiteId);

	//发布
	//FileUtil fileutil = new FileUtil();
	//fileutil.PublishFile("/" + FolderName + "/" + NewFileName,SiteFolder,userinfo_session.getId(),site);

	response.sendRedirect("../close_pop.jsp");return;
}
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script language=javascript>
function init()
{
	var Obj = top.Obj;
	if(Obj)
	{
		//alert(Obj.ChannelName);
		document.all("FolderNameLabel").innerText = Obj.FolderName;
		document.form.FolderName.value = Obj.FolderName;
		document.form.SiteId.value = Obj.SiteId;
	}
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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
<form name="form" action="renamefile.jsp" method="post" onSubmit="return check();">
        <tr> 
          <td width="60" align="center" valign="top"><img src="../images/icon46_confirm.gif" width="46" height="46"></td>
          <td class="lin28">上级目录：<label id="FolderNameLabel"></label>
          </td>
        </tr>
        <tr> 
          <td width="60" align="center" valign="top"></td>
          <td class="lin28">原文件名：
          <%=FileName%>
          </td>
        </tr>
        <tr> 
          <td width="60" align="center" valign="top"></td>
          <td class="lin28">新文件名：
          <input type=text name="NewFileName" size="32" class="textfield" value="<%=FileName%>">
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray"><input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();">
<input type="hidden" name="FolderName" value="">
<input type="hidden" name="FileName" value="<%=FileName%>">
<input type="hidden" name="SiteId" value="">
	</td>
  </tr>
</form>
</table>
</body>
</html>
