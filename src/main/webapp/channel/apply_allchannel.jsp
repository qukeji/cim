<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int ChannelID = getIntParameter(request,"ChannelID");

String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{
	ChannelPrivilege cp = new ChannelPrivilege();

//	u.set();
	cp.applyAllChannel(ChannelID);

	response.sendRedirect("../close_pop.jsp");return;
}
%>
<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE></TITLE></HEAD>
<BODY oncontextmenu="return false">
<script language="javascript">
var isbusy=false;
function disable(){
  if (!isbusy) {isbusy=true;return true;}
  alert("正在处理中，请梢候......");
}
</script>
<br>
<CENTER></CENTER>
<FORM ACTION="apply_allchannel.jsp" METHOD="POST" >
<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
<input type="hidden" name="Submit" value="Submit">
<table align="center">
<tr><td  align="center"><img border="0" src="../images/confirm.gif"></td><td >
  真的要应用于所有子频道吗？</td></tr>
<tr><td colspan="2">
  注意：将频道的权限设置应用于所有子频道，将删除所有子频道<br>
  原有的权限设置属性．
</td></tr>
</table>
<br>
<CENTER><INPUT TYPE="SUBMIT" name="upload" VALUE = "  确认  " onclick="return disable();">
<INPUT TYPE="BUTTON" VALUE = "  取消  " onclick="self.close();"></CENTER></FORM>
</BODY></HTML>
