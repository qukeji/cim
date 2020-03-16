<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" pageEncoding= "utf-8"%>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

	request.setCharacterEncoding("utf-8");

	int ChannelID = getIntParameter(request,"ChannelID");
	int Type = getIntParameter(request,"Type");

	App p = new App(ChannelID);

	String Name = getParameter(request,"Name");

	if(!Name.equals(""))
	{
		String	Template = getParameter(request,"Template");
		String	TargetName = getParameter(request,"TargetName");
		String	Charset = getParameter(request,"Charset");

		p.setName(Name);
		p.setTemplate(Template);
		p.setTargetName(TargetName);
		p.setCharset(Charset);

		p.Update();

		session.removeAttribute("channel_tree_string");

		response.sendRedirect("../close_pop.jsp?Type=1");return;
	}
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../common/common.js"></script>
<script language=javascript>
function init()
{
	var Obj = getObj();
	if(Obj)
	{
		setInnerText(document.getElementById("SuperChannelName"),Obj.ChannelName);
		document.form.SuperChannel.value = Obj.ChannelID;
		document.form.Name.focus();
	}
}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
	if(isEmpty(document.form.Template,"请输入页面框架模板."))
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

function selectTemplate(){
  	 	var Feature = "dialogWidth:34em; dialogHeight:27em;center:yes;status:no;help:no";
		var FileName = window.showModalDialog("../modal_dialog.jsp?target=channel/selecttemplate.jsp",null,Feature);
		if (FileName!=null) 
		{
		  document.form.Template.value=FileName;
		  document.form.TargetName.value = FileName.substring(FileName.lastIndexOf("/")+1);
		}
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
<form name="form" action="app_edit.jsp" method="post" onSubmit="return check();">
        <tr> 
          <td align="right">上级频道：</td>
          <td class="lin28"><label id="SuperChannelName"></label>
          </td>
        </tr>
        <tr> 
          <td align="right">名称：</td>
          <td class="lin28">
          <input type=text name="Name" size="32" class="textfield" value="<%=p.getName()%>">
          </td>
        </tr>
        <tr> 
          <td align="right">页面框架模板：</td>
          <td class="lin28">
          <input type=text name="Template" size="32" class="textfield" value="<%=p.getTemplate()%>"><input type="button" value="..." onclick="selectTemplate();" class="tidecms_btn3">
          </td>
        </tr>
        <tr> 
          <td align="right">对应页面文件名：</td>
          <td class="lin28">
          <input type=text name="TargetName" size="32" class="textfield" value="<%=p.getTargetName()%>">
          </td>
        </tr>
        <tr> 
          <td align="right">文件编码：</td>
          <td class="lin28">
				<select name="Charset">
					<option value="">系统默认编码</option>
					<option value="gb2312">简体中文(GB2312)</option>
					<option value="utf-8">Unicode(UTF-8)</option>
				</select>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray">
    	<input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">&nbsp;
    	<input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();">
		<input type="hidden" name="SuperChannel" value="0">
		<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
		<input type="hidden" name="Type" value="<%=Type%>">
	</td>
  </tr>
</form>
</table>
</body>
</html>
<script language=javascript>
<%if(!p.getCharset().equals("")){%>
document.form.Charset.value = "<%=p.getCharset()%>";
<%}%>
</script>
