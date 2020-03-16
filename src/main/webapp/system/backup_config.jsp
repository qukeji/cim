<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");

BackupConfig backupConfig=new BackupConfig();
backupConfig=backupConfig.getBackupConfig();

if(!Submit.equals(""))
{
    String Action = Util.getParameter(request,"Action");
    int id = Util.getIntParameter(request,"id");
    String includeFolders = Util.getParameter(request,"includeFolders");
    String excludeFolders = Util.getParameter(request,"excludeFolders");
    String includeFileTypes = Util.getParameter(request,"includeFileTypes");
    String excludeFileTypes = Util.getParameter(request,"excludeFileTypes");
    backupConfig.setId(id);
	backupConfig.setIncludeFolders(includeFolders);
	backupConfig.setExcludeFolders(excludeFolders);
	backupConfig.setIncludeFileTypes(includeFileTypes);
	backupConfig.setExcludeFileTypes(excludeFileTypes);
	if(Action.equals("Add")){
	  backupConfig.Add();
	}else{
	  backupConfig.Update();
	}
	response.sendRedirect("../close_pop.jsp");return;

}
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
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
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
<form name="form" action="backup_config.jsp" method="post" onSubmit="return check();">
        <tr> 
          <td align="right">备份目录：</td>
          <td class="lin28"><textarea name="includeFolders" rows="4" cols="25"><%=backupConfig.getIncludeFolders()!=null?backupConfig.getIncludeFolders().replaceAll(",","\r\n"):""%></textarea></td>
        </tr>
         <tr> 
          <td align="right">备份文件类型：</td>
          <td class="lin28"><textarea name="includeFileTypes" rows="4" cols="25"><%=backupConfig.getIncludeFileTypes()!=null?backupConfig.getIncludeFileTypes().replaceAll(",","\r\n"):""%></textarea></td>
         </tr>
         <tr> 
          <td align="right">不备份目录：</td>
          <td class="lin28"><textarea name="excludeFolders" rows="4" cols="25"><%=backupConfig.getExcludeFolders()!=null?backupConfig.getExcludeFolders().replaceAll(",","\r\n"):""%></textarea></td>
         </tr>
            <tr> 
          <td align="right">不备份文件类型：</td>
          <td class="lin28"><textarea name="excludeFileTypes" rows="4" cols="25"><%=backupConfig.getExcludeFileTypes()!=null?backupConfig.getExcludeFileTypes().replaceAll(",","\r\n"):""%></textarea></td>
         </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray">
	<input name="Button2" type="submit" class="tidecms_btn2" value="  确  定  " />
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn2" value="  取  消  " onclick="self.close();"/>


<input type="hidden" name="Submit" value="Submit">
<input type="hidden" name="id" value="<%=backupConfig.getId()!=0?backupConfig.getId():""%>">
<%if(backupConfig.getId()!=0){%>
<input type="hidden" name="Action" value="Update">
<%}else{%>
<input type="hidden" name="Action" value="Add">
<%}%>
	</td>
  </tr>
</form>

</table>
</body>
</html>
