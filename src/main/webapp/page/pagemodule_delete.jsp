<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int		ModuleID		= getIntParameter(request,"ModuleID");

PageModule pm = new PageModule(ModuleID);

String	Action	= getParameter(request,"Action");
if(Action.equals("Delete")&&ModuleID!=0)
{
	int IsDeleteTag		= getIntParameter(request,"IsDeleteTag");
	int	IsDeleteTemplate	= getIntParameter(request,"IsDeleteTemplate");

	pm.Delete();

	Page p = new Page(pm.getPage());

	if(IsDeleteTag==1)
		p.ClearModuleCode(ModuleID);
	else
		p.ClearModuleContent(ModuleID);
	
	if(IsDeleteTemplate==1 && pm.getType()==1)
		new ChannelTemplate().Delete(pm.getTemplate());

	response.sendRedirect("../close_pop.jsp");
	return;
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
}

function check()
{
//	if(isEmpty(document.form.SerialNo,"请输入唯一标识编码."))
//		return false;
	document.form.Button2.disabled  = true;

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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<form name="form" action="pagemodule_delete.jsp" method="post" onSubmit="return check();">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
        <tr> 
          <td width="28%" align="right">&nbsp;</td>
          <td width="72%" class="lin28">确实要删除模块此模块吗？</td>
        </tr>
<%if(pm.getType()==1){%>
		<tr> 
          <td align="right">&nbsp;</td>
          <td width="72%" class="lin28">
          <input name="IsDeleteTemplate" type=checkbox class="textfield" id="IsDeleteTemplate" value="1" checked>
          同时删除对应的附加模板设置</td>
        </tr>
<%}%>
		<tr>
          <td align="right">&nbsp;</td>
          <td class="lin28"><input name="IsDeleteTag" type=checkbox class="textfield" id="IsDeleteTag" value="1">
    同时删除模块标记</td>
		  </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray"><input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();">
	  <input type="hidden" name="ModuleID" value="<%=ModuleID%>">
	  <input type="hidden" name="Action" value="Delete">
	</td>
  </tr>
</form>
</table>
</body>
</html>
