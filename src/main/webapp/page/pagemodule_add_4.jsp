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
int		templateID	= getIntParameter(request,"templateID");


Page p = new Page(pageID);
PageModule pm = new PageModule();

if(moduleID>0)
	pm = new PageModule(moduleID);


String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	TemplateFile tf = CmsCache.getTemplate(templateID);

	p.updateModule(moduleID,tf.getContent());


	out.println("<script>top.TideDialogClose({refresh:'main'});</script>");return;
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<script language=javascript>

function setReturnValue(o){
	if(o.TemplateID!=null){
		alert(o.TemplateID);
		document.form.templateID.value =o.TemplateID;
		document.form.submit();
	}
}

function init()
{
	top.TideDialogSetTitle("选择子系统模板");
	top.TideDialogResize(600,400);
}
</script>
</head>

<body onLoad="init();">
<table width="100%" border="0" height="100%">
  <tr height="100%">
    <td width="194" valign="top" id="leftTd"><iframe frameborder="0" src="../template/select_template_tree_3.jsp?SerialNo=page_sub_system" style="width:100%;height:100%;" name="ifm_left" id="ifm_left"></iframe></td>
    <td width="14" align="center" valign="middle"><a onmousedown="did('split')" id="split" style="cursor:e-resize"><img src="../images/menu_right.png" /></a></td>
    <td valign="top" id="rightTd"><iframe frameborder="0" src="../template/select_template_list_3.jsp?SerialNo=page_sub_system" style="width:100%;height:100%;" name="ifm_right" id="ifm_right"></iframe></td>
  </tr>
</table>
<form name="form" action="pagemodule_add_4.jsp" method="post">
<input type="hidden" name="pageID" value="<%=pageID%>">
<input type="hidden" name="moduleID" value="<%=moduleID%>">
<input type="hidden" name="templateID" value="0">
<input type="hidden" name="Submit" value="Submit">
</form>
</body>
</html>
