<%@ page import="tidemedia.cms.system.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
Parameter  p = new Parameter(id);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Name					= getParameter(request,"Name");
	String	Content					= getParameter(request,"Content");
	String	Comment					= getParameter(request,"Comment");
	int		IntValue				= getIntParameter(request,"IntValue");
	int		IsJson					= getIntParameter(request,"IsJson");
	int		IsTemplate				= getIntParameter(request,"IsTemplate");
	
	p.setName(Name);
	p.setContent(Content);
	p.setComment(Comment);
	p.setIntValue(IntValue);
	p.setIsTemplate(IsTemplate);
	p.setIsJson(IsJson);

	p.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}

String message = "";
if(p.getContent().startsWith(" ")) message = "<br>提示：输入的内容前面有空格";
if(p.getContent().endsWith(" ")) message = "<br>提示：输入的内容后面有空格";
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
	//if(isEmpty(document.form.Code,"请输入代码."))
	//	return false;

	//document.form.Button2.disabled  = true;

	return true;
}
</script>
</head>
<body>
<form name="form" action="parameter_edit.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
    <tr>
    <td align="right" valign="middle">代码：</td>
    <td valign="middle"><%=p.getCode()%></td>
  </tr>

   <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type=text name="Name" size="32" class="textfield" value="<%=p.getName()%>"></td>
  </tr>
<%if(p.getType2()==0){%>
  <tr>
    <td align="right" valign="middle">内容：</td>
    <td valign="middle"><textarea name="Content" cols=56 rows=4 class="textfield"><%=p.getContent()%></textarea>
	<font color=red><%=message%></font>
	</td>
  </tr>

<%}else if(p.getType2()==1){%>
   <tr>
    <td align="right" valign="middle"></td>
    <td valign="middle"><input name="IntValue" id="s003" type="radio" value="1" <%=p.getIntValue()==1?"checked":""%>><label for="s003">true</label>  <input type="radio" id="s004" name="IntValue" value="0" <%=p.getIntValue()==0?"checked":""%>><label for="s004">false</label></td>
  </tr>
<%}else if(p.getType2()==2){%>
   <tr>
    <td align="right" valign="middle">内容：</td>
    <td valign="middle"><input name="IntValue" id="IntValue" type="text" value="<%=p.getIntValue()%>"></td>
  </tr>
<%}%>
  <tr>
    <td align="right" valign="middle">备注：</td>
    <td valign="middle"><textarea name="Comment" cols=56 rows=4 class="textfield"><%=p.getComment()%></textarea>
	</td>
  </tr>
  <tr>
    <td align="right" valign="middle"></td>
    <td valign="middle">模板：<input type="checkbox" <%=p.getIsTemplate()==1?"checked":""%> name="IsTemplate" id="IsTemplate" value="1" class="textfield">
	&nbsp;JSON：<input type="checkbox" <%=p.getIsJson()==1?"checked":""%> name="IsJson" id="IsJson" value="1" class="textfield">
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
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
<input type="hidden" name="Submit" value="Submit">
<input type="hidden" name="id" value="<%=id%>">
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>