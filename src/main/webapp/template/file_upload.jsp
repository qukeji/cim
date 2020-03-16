<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int ChannelID = getIntParameter(request,"ChannelID");
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
	}
	//document.form.File.focus();
}

function check()
{
	if(isEmpty(document.form.File,"请输入文件名."))
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

function multiFiles(){
	if (document.form.MoreUpload.checked){
		MoreFile.style.display="block";
	}
	else{
		MoreFile.style.display="none";
	}
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
<form action="file_upload_submit.jsp" enctype="multipart/form-data" method="post"  name="form">
        <tr> 
          <td width="60" align="center" valign="top"><img src="../images/icon46_confirm.gif" width="46" height="46"></td>
          <td class="lin28">上级目录：<label id="FolderNameLabel"></label>
          </td>
        </tr>
        <tr> 
          <td width="60" align="center" valign="top"></td>
          <td class="lin28">请选择文件：<br>
          <input type="file" name="File1" size="30" class="textfield">
<div id="MoreFile" style="display:none">
          <input type="file" name="File2" size="30" class="textfield">
          <input type="file" name="File3" size="30" class="textfield">
          <input type="file" name="File4" size="30" class="textfield">
          <input type="file" name="File5" size="30" class="textfield">
          <input type="file" name="File6" size="30" class="textfield">
          <input type="file" name="File7" size="30" class="textfield">
          <input type="file" name="File8" size="30" class="textfield">
</div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray"><input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">
      &nbsp; 
	  <input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();"> 
	  <input id="s1" type=checkbox name="MoreUpload" onclick="multiFiles();" value="Yes"><label for="s1">多文件上传</label>
	  <input id="s2" type=checkbox name="ReWrite" value="Yes"><label for="s2">重名覆盖</label>
<input type="hidden" name="FolderName" value="">
<input type="hidden" name="Submit" value="Submit">
	</td>
  </tr>
</form>
</table>
</body>
</html>
