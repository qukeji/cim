<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");

int ChannelID = getIntParameter(request,"ChannelID");

Page p = new Page(ChannelID);

String Name = getParameter(request,"Name");

if(!Name.equals(""))
{
	String	Template		= getParameter(request,"Template");
	String	TargetName		= getParameter(request,"TargetName");
	String	Charset			= getParameter(request,"Charset");

	p.setName(Name);
	p.setTemplate(Template);
	p.setTargetName(TargetName);
	p.setCharset(Charset);
	p.setActionUser(userinfo_session.getId());

	p.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script language=javascript>
function init()
{
		document.form.Name.focus();
}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
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
  	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(450);
	dialog.setSuffix('_2');
	dialog.setUrl("channel/selecttemplate.jsp");
	dialog.setTitle("页面框架模板");
	dialog.setScroll('auto');
	dialog.show();
}


function setReturnValue(o){
	if(o.TemplateID!=null){
		document.form.TemplateID.value =o.TemplateID;
		var scr = document.createElement('script')
		scr.src = '../channel/template_add_js.jsp?id=' + o.TemplateID;
		document.getElementById('ajax_script').appendChild(scr);
	}
}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();" scroll="no">
<form name="form" action="page_edit2.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
        <tr> 
          <td align="right">上级频道：</td>
          <td class="lin28"><label id="SuperChannelName"><%=CmsCache.getChannel(ChannelID).getName()%></label>
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
          <%=p.getTemplate()%>
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
</table>

</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>

<div class="form_button">
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>

<input type="hidden" name="SuperChannel" value="<%=ChannelID%>">
<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	  <input type="hidden" name="Submit" value="Submit">
</div>
</form>
<script language=javascript>
<%if(!p.getCharset().equals("")){%>
document.form.Charset.value = "<%=p.getCharset()%>";
<%}%>
</script>
</body>
</html>