<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.spider.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Name = getParameter(request,"Name");
int		Parent		= getIntParameter(request,"Parent");
int		id2			= getIntParameter(request,"id2");

if(!Name.equals("") || id2>0)
{
	String	CodeStart	= getParameter(request,"CodeStart");
	String	CodeEnd		= getParameter(request,"CodeEnd");
	String	CodeReg		= getParameter(request,"CodeReg");
	String	Field		= getParameter(request,"Field");

	String rule = getParameter(request,"rule");
	
	if(id2>0)
	{
		SpiderField ss = new SpiderField(id2);
		Name = ss.getName();
		CodeStart = ss.getCodeStart();
		CodeEnd = ss.getCodeEnd();
		CodeReg = ss.getCodeReg();
		Field = ss.getField();
	}

	SpiderField s = new SpiderField();
	
	s.setParent(Parent);
	s.setName(Name);
	s.setCodeStart(CodeStart);
	s.setCodeEnd(CodeEnd);
	s.setCodeReg(CodeReg);
	s.setField(Field);
	
	s.setRule(rule);

	s.Add();

	out.println("<script>top.TideDialogClose({refresh:'var w =window.frames[\"popiframe\"];w.location=w.location;',suffix:'_2'});</script>");return;
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
<script type="text/javascript">
function init()
{
	document.form.Name.focus();
}

function check()
{
	if(document.id2.value=="")
	{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
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
</script>
</head>
<body  onload="init();">
<form name="form" action="spider_field_add.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
  <tr>
    <td align="right" valign="middle" width="100">名称：</td>
    <td valign="middle"><input type="text" name="Name" id="Name" class="textfield"/></td>
  </tr>
  <tr>
    <td align="right" valign="middle">对应字段：</td>
    <td valign="middle"><input type="text" name="Field" id="Field" class="textfield"/></td>
  </tr>
  <tr>
    <td align="right" valign="top">内容对象：</td>
    <td valign="middle"><input type="text" name="rule" id="rule" class="textfield"/>
	<br><br>
	使用jquery语法，比如#content，即为提前此节点的内容，填写内容对象后，不需要填写开始和结束代码
	</td>
  </tr>
  <tr>
    <td align="right" valign="middle">开始代码：</td>
    <td valign="middle"><textarea name="CodeStart" cols=32 rows=4 class="textfield"></textarea></td>
  </tr>
  <tr>
    <td align="right" valign="middle">结束代码：</td>
    <td valign="middle"><textarea name="CodeEnd" cols=32 rows=4 class="textfield"></textarea></td>
  </tr>
  <tr>
    <td align="right" valign="middle">正则表达式：</td>
    <td valign="middle"><textarea name="CodeReg" cols=32 rows=4 class="textfield"></textarea></td>
  </tr>
  <tr>
    <td align="right" valign="middle">复制配置：</td>
    <td valign="middle"><input type="text" name="id2" id="id2" class="textfield"/></td>
  </tr>
  

</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input name="Parent" type="hidden" value="<%=Parent%>"/>
	<input name="submitButton" type="submit" class="tidecms_btn2" value="确定" id="submitButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>