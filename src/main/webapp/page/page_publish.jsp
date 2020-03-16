<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
				tidemedia.cms.util.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
 *
 *		姓名		日期		说明
 *
 *		wanghailong	20140211	修改发布 发布整个目录改成发布单个文件  PublishFolder方法改成PublishFile方法
 */
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

Page p = new Page(id);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	//String TemplateFolder = p.getSite().getSiteFolder();
	//String Path	= TemplateFolder + "/" + p.getFullTargetName();
	//File file = new File(Path);
	String SiteFolder = p.getSite().getSiteFolder();
	FileUtil fileutil = new FileUtil();
	//fileutil.PublishFolder(file,SiteFolder,userinfo_session.getId(),p.getSite());
	fileutil.PublishFile(p.getFullTargetName(),SiteFolder,userinfo_session.getId(),p.getSite());
	
	out.println("<script>top.TideDialogClose();</script>");
	return;
	//response.sendRedirect("../close_pop.jsp");	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/dialog.css" type="text/css" rel="stylesheet" />
<script language=javascript>
function init()
{
}

function check()
{
	//document.form.Button2.disabled  = true;

	return true;
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">
<form name="form" action="page_publish.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
        <tr> 
          <td align="right"></td>
          <td class="lin28">页面地址：<a href="<%=Util.ClearPath(p.getSite().getUrl()+"/"+p.getFullTargetName())%>" target="_blank"><span class="font-blue"><%=p.getTargetName()%>　　</span></a>
          </td>
        </tr>
        <tr> 
          <td align="right"></td>
          <td class="lin28">
         你要发布本页面吗？
          </td>
        </tr>
      </table>
    </td>
  </tr>
<script language=javascript>init();</script>
</table>

</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>

<div class="form_button">
	<input name="startButton" type="submit" class="button" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
<input type="hidden" name="id" value="<%=id%>">
	  <input type="hidden" name="Submit" value="Submit">
</div>
</form>
</body>
</html>
