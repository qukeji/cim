<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
SpiderField  s = new SpiderField(id);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Name		= getParameter(request,"Name");
	String	CodeStart	= getParameter(request,"CodeStart");
	String	CodeEnd		= getParameter(request,"CodeEnd");
	String	CodeReg		= getParameter(request,"CodeReg");
	String	Field		= getParameter(request,"Field");
	
	String rule = getParameter(request,"rule");
	
	s.setName(Name);
	s.setCodeStart(CodeStart);
	s.setCodeEnd(CodeEnd);
	s.setCodeReg(CodeReg);
	s.setField(Field);
	
	s.setRule(rule);

	s.Update();

	out.println("<script>top.TideDialogClose({refresh:'var w =window.frames[\"popiframe\"];w.location=w.location;',suffix:'_2'});</script>");
	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/dialog.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script language=javascript>
function init()
{
	document.form.Code.focus();
}

function check()
{
	if(isEmpty(document.form.Code,"请输入代码."))
		return false;

	//document.form.Button2.disabled  = true;

	return true;
}
</script>
</head>
<body>
<form name="form" action="spider_field_edit.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
  <tr>
    <td align="right" valign="middle" width="100">编号：</td>
    <td valign="middle"><%=s.getId()%></td>
  </tr>
  <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type=text name="Name" size="32" class="textfield" value="<%=s.getName()%>"></td>
  </tr>
  <tr>
    <td align="right" valign="middle">对应字段：</td>
    <td valign="middle"><input type="text" name="Field" id="Field" class="textfield" value="<%=s.getField()%>"/></td>
  </tr>

  <tr>
    <td align="right" valign="top">内容对象：</td>
    <td valign="middle"><input type="text" name="rule" id="rule" class="textfield" value="<%=s.getRule()%>"/>
	<br><br>
	使用jquery语法，比如#content，即为提前此节点的内容，填写内容对象后，不需要填写开始和结束代码
	</td>
  </tr>

  <tr>
    <td align="right" valign="middle">开始代码：</td>
    <td valign="middle"><textarea name="CodeStart" cols=32 rows=4 class="textfield"><%=s.getCodeStart()%></textarea></td>
  </tr>
  <tr>
    <td align="right" valign="middle">结束代码：</td>
    <td valign="middle"><textarea name="CodeEnd" cols=32 rows=4 class="textfield"><%=s.getCodeEnd()%></textarea></td>
  </tr>
  <tr>
    <td align="right" valign="middle">正则表达式：</td>
    <td valign="middle"><textarea name="CodeReg" cols=32 rows=4 class="textfield"><%=s.getCodeReg()%></textarea></td>
  </tr>
  

</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>

<div class="form_button">
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
<input type="hidden" name="Submit" value="Submit">
<input type="hidden" name="id" value="<%=id%>">
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>