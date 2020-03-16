<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
String Name = getParameter(request,"Name");
int ContinueAdd = getIntParameter(request,"ContinueAdd");

if(!Name.equals(""))
{
	int		SuperChannel	= getIntParameter(request,"SuperChannel");
	int		IsDisplay		= getIntParameter(request,"IsDisplay");
	String	SerialNo		= getParameter(request,"SerialNo");
	String	Href			= getParameter(request,"Href");


	Channel channel = new Channel();
	
	channel.setName(Name);
	channel.setSerialNo(SerialNo);
	channel.setParent(SuperChannel);
	channel.setIsDisplay(IsDisplay);
	channel.setHref(Href);
//	channel.setRootPath(application.getRealPath(RootPath));
	channel.setType(1);

	channel.Add();

	session.removeAttribute("channel_tree_string");

	if(ContinueAdd==0)
		{response.sendRedirect("../close_pop.jsp");return;}
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
		document.all("SuperChannelName").innerText = Obj.ChannelName;
		document.form.SuperChannel.value = Obj.ChannelID;
		document.form.Name.focus();
	}
}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
//	if(isEmpty(document.form.FolderName,"请输入目录名."))
//		return false;
//	if(isEmpty(document.form.SerialNo,"请输入唯一标识编码."))
//		return false;
	var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"; 

	for(var i=0;i<document.form.SerialNo.value.length;i++)
	{
		var exist = false;
		for(var j=0;j<smallch.length;j++)
		{
			if(document.form.SerialNo.value.charAt(i)==smallch.charAt(j))
			{
				exist = true;
			}
		}

		if(!exist)
		{
			alert("标识名必须由英文字母或下划线组成.");
			document.form.SerialNo.focus();
			return false;
		}

	}

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

function initOther()
{
	if(document.form.FolderName.value!="" && document.form.SerialNo.value=="")
		document.form.SerialNo.value = document.form.FolderName.value;
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
<form name="form" action="category_add.jsp" method="post" onSubmit="return check();">
        <tr> 
          <td align="right">上级频道：</td>
          <td class="lin28"><label id="SuperChannelName"></label>
          </td>
        </tr>
        <tr> 
          <td align="right">名称：</td>
          <td class="lin28">
          <input type=text name="Name" size="32" class="textfield">
          </td>
        </tr>
        <tr> 
          <td align="right">标识名：</td>
          <td class="lin28">
          <input type=text name="SerialNo" size="32" class="textfield">
          </td>
        </tr>
        <tr> 
          <td align="right">链接：</td>
          <td class="lin28">
          <input type=text name="Href" size="32" class="textfield">
          </td>
        </tr>
        <tr> 
          <td align="right">是否在导航中出现：</td>
          <td class="lin28">
          <input type=checkbox name="IsDisplay" value="1" class="textfield" checked>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray"><input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();">
	  <input type=checkbox name="ContinueAdd" value="1" class="textfield" <%=ContinueAdd==1?"checked":""%>>继续新建
<input type="hidden" name="SuperChannel" value="0">
	</td>
  </tr>
</form>
</table>
</body>
</html>
