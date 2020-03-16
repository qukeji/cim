<%@ page import="java.io.File,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String	FileName		= getParameter(request,"FileName");

String FolderName		= "";
int index = FileName.lastIndexOf("/");
if(index!=-1)
{
	FolderName = FileName.substring(0,index);
	FileName = FileName.substring(index+1);
}

String NewFileName = getParameter(request,"NewFileName");
if(!NewFileName.equals(""))
{

	String TemplateFolder =CmsCache.getDefaultSite().getTemplateFolder();

	FolderName				= getParameter(request,"FolderName");
	FileName				= getParameter(request,"FileName");
	String  Path			= TemplateFolder + "/" + FolderName + "/" + FileName;
	String  NewPath			= TemplateFolder + "/" + FolderName + "/" + NewFileName;
///System.out.println(FolderName + ":"+ FileName + ":"+Path);

	String RealPath = (Path);
	File file = new File(RealPath);
	
//System.out.println("NewPath="+NewPath);
//System.out.println("RealPath="+RealPath);

	//String NewRealPath = application.getRealPath(NewPath);
	//File newfile = new File(NewRealPath);
   File newfile = new File(NewPath);
	file.renameTo(newfile);

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
		//document.all("FolderNameLabel").innerText = Obj.FolderName;
		//document.form.FolderName.value = Obj.FolderName;
	}
	document.form.NewFileName.select();
}

function check()
{
	if(isEmpty(document.form.NewFileName,"请输入目录名."))
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
<form name="form" action="renamefolder.jsp" method="post" onSubmit="return check();">
        <tr> 
          <td width="60" align="center" valign="top"></td>
          <td class="lin28">原目录名：
          <%=FileName%>
          </td>
        </tr>
        <tr> 
          <td width="60" align="center" valign="top"></td>
          <td class="lin28">新目录名：
          <input type=text name="NewFileName" size="32" class="textfield" value="<%=FileName%>">
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray"><input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();">
<input type="hidden" name="FolderName" value="<%=FolderName%>">
<input type="hidden" name="FileName" value="<%=FileName%>">
	</td>
  </tr>
</form>
</table>
</body>
</html>
