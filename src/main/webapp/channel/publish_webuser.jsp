<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<script type="text/javascript" src="../common/common.js"></script>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");
//int ChannelID = getIntParameter(request,"");
if(!Submit.equals(""))
{
	int		ChannelID			= getIntParameter(request,"ChannelID");
	WebUser w = new WebUser(ChannelID);
	w.GenerateFormFile(userinfo_session);
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
	var Obj = getObj();
	if(Obj)
	{
		setInnerText(document.getElementById("ChannelName"),Obj.ChannelName);
		document.form.ChannelID.value = Obj.ChannelID;
	}
}

function check()
{
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
		  var filename = FileName.substring(0,FileName.lastIndexOf("."))+".jsp";
		  document.form.TargetName.value = filename.substring(filename.lastIndexOf("/")+1);
		  }
}

function change()
{
	if(document.form.TemplateType.value=="1")
	{
		tr01.style.display = "";
	}
	else
		tr01.style.display = "none";
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
<%if(Submit.equals("")){%>
<form name="form" action="publish_webuser.jsp" method="post" onSubmit="return check();">
        <tr> 
          <td align="right">频道：</td>
          <td class="lin28"><label id="ChannelName"></label>
          </td>
        </tr>
        <tr> 
          <td align="right"></td>
          <td class="lin28">
         你要发布本应用吗？
          </td>
        </tr>
        <tr> 
          <td align="right"></td>
          <td class="lin28"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray">
    	<input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">&nbsp; 
    	<input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();">
		<input type="hidden" name="ChannelID" value="0">
		<input type="hidden" name="Submit" value="Submit">
	</td>
  </tr>
</form>
<script language=javascript>init();</script>
<%}else{%>
<tr> 
    <td align="center">
	系统开始在后台处理发布任务.<br>
	估计会需要一段时间.<br>
	你可以先关闭此窗口.
	</td>
</tr>
<tr> 
    <td align="center">
	<input name="Submit2" type="button" class="tidecms_btn3" value="  关  闭  " onclick="self.close();">
	</td>
</tr>
<%}%>
</table>
</body>
</html>
