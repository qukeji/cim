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
	//document.form.File.focus();
}

function check()
{
	//if(isEmpty(document.form.File,"请输入文件名."))
	//	return false;
	document.form.Button2.disabled = true;
	Message.style.display = "";

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
<form action="email_import_submit.jsp" enctype="multipart/form-data" method="post"  name="form" onSubmit="return check()">
        <tr> 
          <td width="60" align="center" valign="top"><img src="../images/icon46_confirm.gif" width="46" height="46"></td>
          <td class="lin28">
          </td>
        </tr>
        <tr> 
          <td width="60" align="center" valign="top"></td>
          <td class="lin28">
		  请选择文件：<br>
          <input type="file" name="File1" size="30" class="textfield">
		  <br>
			<input id="publish1" type="radio" name="Type" value="1" ><label for="publish1">包括姓名</label>
			<input id="publish2" type="radio" name="Type" value="2" ><label for="publish2">不包括姓名</label>		  
		  <div id="Message" style="display:none"><font color=red>正在上传....</font></div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray"><input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">
      &nbsp; 
	  <input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();"> 
<input type="hidden" name="Submit" value="Submit">
	</td>
  </tr>
</form>
</table>
</body>
</html>
