<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
int		pageID		= getIntParameter(request,"pageID");
int		ModuleID	= getIntParameter(request,"ModuleID");
int		Index		= getIntParameter(request,"Index");

PageModule pm = new PageModule();
Channel ch = new Channel();
if(ModuleID>0)
{
	pm = new PageModule(ModuleID);
	pageID = pm.getPage();
}

Page p = new Page(pageID);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Template		= getParameter(request,"Template");

	if(ModuleID==0)
	{
		pm = new PageModule();
		pm.setPage(pageID);
		pm.setTemplateFile(Template);
		pm.setType(3);
		pm.Add();
	}
	else
	{
		pm = new PageModule(ModuleID);
		pm.setTemplateFile(Template);
		pm.Update();
	}

	if(ModuleID==0)
		p.AddModuleCode(pm,Index);
	else
		p.EditModuleCode(pm);

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
	if(isEmpty(document.form.Template,"请选择模板."))
		return false;

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

function selectTemplate(){
  	 	var Feature = "dialogWidth:34em; dialogHeight:27em;center:yes;status:no;help:no";
		var FileName = window.showModalDialog("../modal_dialog.jsp?target=channel/selecttemplate.jsp",null,Feature);
		if (FileName!=null) {
		  document.form.Template.value=FileName;
		  //var filename;// = FileName.substring(0,FileName.lastIndexOf("."))+".html";
		  //document.form.TargetName.value = FileName.substring(FileName.lastIndexOf("/")+1);
		  }
}

function Delete()
{
	if(confirm('你确认要删除吗?')) 
	{
		this.location = "pagemodule_delete.jsp?PageID=<%=pageID%>&ModuleID=<%=ModuleID%>&Action=Delete";
	}
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
<form name="form" action="pagemodule_add_3.jsp" method="post" onSubmit="return check();">
        <tr> 
          <td align="right">模板：</td>
          <td class="lin28">
          <input type=text name="Template" size="32" class="textfield" value="<%=pm.getTemplateFile()%>"> <input type="button" value="..." onclick="selectTemplate();" class="tidecms_btn3">
          </td>
        </tr>
        <tr>
          <td align="right">&nbsp;</td>
          <td class="lin28">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray"><input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();">
	  <%if(userinfo_session.getRole()==1){%><input name="Button3" type="button" class="tidecms_btn3" value="清除数据来源" onClick="Delete();"><%}%>
	  <input type="hidden" name="ChannelID" value="<%=ch.getId()%>">
	  <input type="hidden" name="pageID" value="<%=pageID%>">
	  <input type="hidden" name="ModuleID" value="<%=ModuleID%>">
	  <input type="hidden" name="Index" value="<%=Index%>">
	  <input type="hidden" name="Submit" value="Submit">
	</td>
  </tr>
</form>
</table>
</body>
</html>
