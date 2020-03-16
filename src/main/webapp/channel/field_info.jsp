<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		FieldID		= getIntParameter(request,"FieldID");
String	Action		= getParameter(request,"Action");

Field field = new Field(FieldID);

if(Action.equals("Delete"))
{

	//field.setChannelID(ChannelID);
	//field.setName(FieldName);

	field.Delete();
	
//	重新调用页面生产程序,产生新的页面;
	//channel = CmsCache.getChannel(ChannelID);

	//if(channel.getType()==3)
	//{
	//	App p = new App(ChannelID);
	//	p.GenerateFormFile(userinfo_session);
	//}
	//生成成功;

	response.sendRedirect("../close_pop.jsp");
	return;
}

String FieldType = "";
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/dialog.css" type="text/css" rel="stylesheet" />
<title>字段信息</title>
<script language="javascript">
function init()
{
	var Obj = top.Obj;
	if(Obj)
	{
		//document.form.ChannelID.value = Obj.ChannelID;
	}
}

function Delete()
{
	if(confirm('你确认要删除此字段?')) 
	{
		this.location = "field_info.jsp?Action=Delete&FieldID=<%=FieldID%>";
	}
}

function Edit()
{
	this.location = "field_edit.jsp?FieldID=<%=FieldID%>";
}

</script>
</head>

<body oncontextmenu="return false;" onload="init();">
<form name="form" method="POST" action="addfield.jsp" onsubmit="return checkit();">
<fieldset><legend>基本属性</legend>
    <table border="0" cellpadding="0" cellspacing="8" align="center">
      <tr>
        <td align="right">字段类型：</td>
        <td><%=field.getFieldTypeDesc()%></td>
      </tr>
      <tr>
        <td align="right">字段名称：</td>
        <td><%=field.getName()%></td>
      </tr>
      <tr>
        <td align="right">字段描述：</td>
        <td><%=field.getDescription()%></td>
      </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td>&nbsp;</td>
      </tr>

      <tr>
        <td align="right">附加属性：</td>
        <td><%if(field.getIsHide()==1){%>隐藏<%}%>&nbsp;&nbsp;&nbsp;&nbsp;<%if(field.getDisableBlank()==1){%>不允许为空<%}%></td>
      </tr>
      <tr id="Items" style="display:none">
        <td align="right">选项：</td>
        <td>
		<textarea name="Options" cols=40 rows=6></textarea>
		<br>每行一个选项
		</td>
      </tr>
  </table>
</fieldset>
<br>

    <table border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
        <td colspan="2" align="center"><br>
		<input type="button" value=" 修 改 " class="button" name="B1" class="tidecms_btn3" onClick="Edit();"> 
		<%if(field.getFieldLevel()==2){%><input type="button" value=" 删 除 " name="B2" class="button" onClick="Delete();"> <%}%>
		<input type="button" value=" 关 闭 " class="button" name="B3" onclick="top.TideDialogClose({suffix:'_3'});" class="tidecms_btn3">
		</td>
      </tr>
    </table>
</form>
</body>

</html>
