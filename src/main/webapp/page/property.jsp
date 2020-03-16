<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
				tidemedia.cms.util.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

Page p = new Page(id);

if(!new ChannelPrivilege().hasRight(userinfo_session,id,ChannelPrivilege.PageSourceEdit))
{
	out.println("没有权限.");return;
}

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
		String	Title = getParameter(request,"Title");
		String	Style = getParameter(request,"Style");

		p.setActionUser(userinfo_session.getId());
		p.updatePageTitle(Title);
		p.updatePageStyle(Style);

		out.println("<script>top.TideDialogClose({refresh:'main'});</script>");
		return;
		//response.sendRedirect("../close_pop.jsp");	return;
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
}

function select_style(id){
	var	dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(400);
	dialog.setLayer(2);
	dialog.setSuffix('_2');
	dialog.setUrl("page_style_select.jsp");
	dialog.setTitle("选择样式");
	dialog.show();
}

function setReturnValue(o){
	if(o.TemplateID!=null){
		//alert(o.FileName);
		var str = document.form.Style.value;
		var i = str.lastIndexOf("/");
		if(i!=-1)
			document.form.Style.value = str.substring(0,i) + "/" + o.FileName;
		else
			document.form.Style.value = o.FileName;
		//var fileName = o.FileName;
		//top.TideDialogClose({suffix:'_2',recall:true,returnValue:{FileName:fileName}});
		//document.form.frameTemplateID.value =o.TemplateID;
		//document.form.submit();
	}
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">
<form name="form" action="property.jsp" method="post">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
        <tr> 
          <td align="right">标题：</td>
          <td class="lin28"><input type=text name="Title"  class="textfield" value="<%=p.getPageTitle()%>" size="32">
          </td>
        </tr>
        <tr> 
          <td align="right">样式表：</td>
          <td class="lin28"><input type=text name="Style"  class="textfield" value="<%=p.getPageStyle()%>" size="32"> 
		  <input name="" type="button" class="tidecms_btn3" value="选择" onClick="select_style()"/>
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

	<input type="hidden" name="id" value="<%=id%>">
	<input type="hidden" name="Submit" value="Submit">
</div>
</form>
</body>
</html>
