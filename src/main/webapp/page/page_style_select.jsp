<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		pageID			= getIntParameter(request,"pageID");
int		frameID			= getIntParameter(request,"frameID");
int		frameTemplateID	= getIntParameter(request,"frameTemplateID");

if(frameTemplateID>0 && pageID>0)
{
	Page p = new Page(pageID);

	p.addFrame(frameTemplateID,frameID);

	out.println("<script>top.TideDialogClose({refresh:'main'});</script>");
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/index.js"></script>
<script type="text/javascript">
function setReturnValue(o){
	if(o.TemplateID!=null){
		//alert(o.FileName);
		var fileName = o.FileName;
		top.TideDialogClose({suffix:'_2',recall:true,returnValue:{FileName:fileName}});
		//document.form.frameTemplateID.value =o.TemplateID;
		//document.form.submit();
	}
}
</script>
</head>

<body>
<table width="100%" border="0" height="100%">
  <tr height="100%">
    <td width="194" valign="top" id="leftTd"><iframe frameborder="0" src="../template/select_template_tree_3.jsp?SerialNo=page_style" style="width:100%;height:100%;" name="right" id="right"></iframe></td>
    <td width="14" align="center" valign="middle"><a onmousedown="did('split')" id="split" style="cursor:e-resize"><img src="../images/menu_right.png" /></a></td>
    <td valign="top" id="rightTd"><iframe frameborder="0" src="../template/select_template_list_3.jsp?SerialNo=page_style" style="width:100%;height:100%;" name="right" id="right"></iframe></td>
  </tr>
</table>

</body>
</html>