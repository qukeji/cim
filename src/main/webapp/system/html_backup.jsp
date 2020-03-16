<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	FolderName	= defaultSite.getSiteFolder();
	String BackupFolder = defaultSite.getBackupFolder();

	FileUtil fileutil = new FileUtil();

	if(!FolderName.equals(""))
	{
		File file = new File(FolderName);
		File ZipFile;

		ZipFile = new File(BackupFolder+"/html_"+Util.getCurrentDate("yyyyMMdd_HHmmss")+".zip");
		BackupConfig backupConfig=new BackupConfig();
		backupConfig=backupConfig.getBackupConfig();
		String []excludeFolders=Util.StringToArray(backupConfig.getExcludeFolders(),",");
		String []excludeFileTypes=Util.StringToArray(backupConfig.getExcludeFileTypes(),",");
		
		if(excludeFolders!=null && excludeFolders.length>0){
		  for(String excludeFolder :excludeFolders){
			excludeFolder=excludeFolder.trim();
		       if(!excludeFolder.equals("")){
		          fileutil.addExclude("folder",FolderName+excludeFolder);
		       }
		  }
		}
		
		if(excludeFileTypes!=null && excludeFolders.length>0){
		  for(String excludeFileType :excludeFileTypes){
			excludeFileType=excludeFileType.trim();
		       if(!excludeFileType.equals("")){
		          fileutil.addExclude("ext",excludeFileType);
		       }
		  }
		}
		
		fileutil.zipFiles(file,ZipFile);
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
	document.form.Button2.disabled  = true;

	return true;
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
<form name="form" action="html_backup.jsp" method="post" onSubmit="return check();">
        <tr> 
          <td align="right"></td>
          <td class="lin28">
          </td>
        </tr>
        <tr> 
          <td align="right"></td>
          <td class="lin28">
         网站备份方式：
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray">
	  <input name="Button2" type="submit" class="tidecms_btn2" value="  确  定  " />
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn2" value="  取  消  " onclick="self.close();"/>

<input type="hidden" name="Submit" value="Submit">
	</td>
  </tr>
</form>
<script language=javascript>init();</script>
</table>
</body>
</html>
