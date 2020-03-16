<%@ page import="java.sql.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%//禁止编辑发布方案
/*
*	最后修改人		修改时间		备注
*	郭庆光			20130702		url 修改为 转码客户端地址，size 原32 修改为50
*/
if(! userinfo_session.isAdministrator())
{response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

Product product = new Product(id);

String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{	
	String name = getParameter(request,"Name");
	String url = getParameter(request,"Url");
	int status = getIntParameter(request,"Status");

	product.setName(name);
	product.setUrl(url);
	product.setStatus(status);

	product.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript">
function check()
{
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

<body  onload="">
<form name="form" method="post" action="product_edit.jsp" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">

  <tr>
    <td align="right" valign="middle">名称:</td>
    <td valign="middle"><input type=text name="Name" size="50" class="textfield" value="<%=product.getName()%>"></td>
  </tr>
  <tr>
    <td align="right" valign="middle">产品地址:</td>
    <td valign="middle"><input type=text name="Url" size="50" class="textfield" value="<%=product.getUrl()%>"></td>
  </tr>
  <tr>
    <td align="right" valign="middle">使用状态:</td>
    <td valign="middle">
	<input type="radio" name="Status" id="s001" value="0"  <%if(product.getStatus()==0){%>checked="checked"<%}%>/><label for="s001">关闭</label>
	<input type="radio" name="Status" id="s002" value="1"  <%if(product.getStatus()==1){%>checked="checked"<%}%>/><label for="s002">打开</label>
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
	<input type="hidden" name="Submit" value="Submit">
	<input type="hidden" name="id" value="<%=id%>">
	<input name="submitButton" type="submit" class="tidecms_btn3" value="确定" id="submitButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn3" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>