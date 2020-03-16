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


//获取机器码
String serverCode = CmsCache.getServerCode();

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
var product_url = "<%=product.getUrl()%>";

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

function update()
{
	var code = $("#code").val();
	var license = $("#license").val();
	var notify = $("#notify");
	var productid = $("#productid").val();
	notify.html("");
	if(code=="" && license==""){alert("请输入许可代码或代码编号");return false;}

	$("#submit_btn").attr("disabled","true").val("正在提交");
	var url= product_url + "/system/license_update.jsp?code=" + code + "&license="+license+"&productid="+productid;
	$.ajax({
		type: "post",dataType:"json",url: url,
		success: function(msg){
			if(msg.status>0)
			{
				//window.console.info("a");
				//window.location = "license.jsp";
				top.TideDialogClose({refresh:'right'});
				return;				
			}
			else
			{
				alert(msg.message);
				//notify.html("<font color=red>"+msg.message+"</font>");
				//$("#submit_btn").attr("disabled","false").val("提交");
				return;	
			}
			//this.location = "license.jsp";
		},
		error: function() {
			alert("许可证提交失败");
		}
	});
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
        <td valign="top">产品：</td><td><%=product.getName()%></td>
      </tr>
      <tr>
        <td valign="top">代码证编号：</td><td><input type="text" name="code" id="code" value="" size="60">
		</td>
      </tr>
      <tr>
        <td>许可证代码：</td><td><textarea name="license" id="license" cols=62 rows=6 class="textfield"></textarea></td>
      </tr>
	  <tr>
        <td>机器码：</td><td><b><%=serverCode%></b></td>
      </tr>
	  <tr>
		<td>注意事项：</td><td><font color=red><b>使用许可证编号更新要求后台服务器必须能够访问外网</b></font></td>
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
	<input type="hidden" name="id" id="productid" value="<%=id%>">
	<input name="submitButton" type="button" class="tidecms_btn3" value="确定" id="submitButton" onClick="update()"/>
	<input name="btnCancel1" type="button" class="tidecms_btn3" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>