<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

String	Submit	= getParameter(request,"Submit");
if(!Submit.equals(""))
{
	int		ChannelID	= getIntParameter(request,"ChannelID");

	Channel channel = CmsCache.getChannel(ChannelID);

	channel.CopyFormToSubChannel();

	response.sendRedirect("../close_pop.jsp");
	return;
}
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>将表单应用到所有子频道</title>
<script language="javascript">
function checkit(){
   return true;
}

function init()
{
	var Obj = top.Obj;
	if(Obj)
	{
		document.form.ChannelID.value = Obj.ChannelID;
	}
}
</script>
</head>

<body onload="init();">
<form name="form" method="POST" action="form_copy.jsp" onsubmit="return checkit();">
    <table border="0" cellpadding="0" cellspacing="0" align="center">
      <tr>
        <td>确认将此表单应用到所有子频道吗？</td>
      </tr>
    </table>
<br>
    <table border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
        <td colspan="2" align="center"><br><input type="submit" value=" 确 认 " name="B1">
        <input type="button" value=" 取 消 " name="B2" onclick="self.close();">
		<input type="hidden" name="ChannelID" value="0">
		<input type="hidden" name="Submit" value="Submit">
		</td>
      </tr>
    </table>
</form>
</body>

</html>
