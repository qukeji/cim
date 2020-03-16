<%@ page import="java.sql.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String	Submit	= getParameter(request,"Submit");
int flag = 0;
if(!Submit.equals(""))
{
}
else
{
	flag = getIntParameter(request,"flag");
}

//获取机器码
String serverCode = CmsCache.getServerCode();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script>
function update()
{
	var code = $("#code").val();
	var license = $("#license").val();
	var notify = $("#notify");
	notify.html("");
	if(code=="" && license==""){alert("请输入许可代码或代码编号");return false;}

	$("#submit_btn").attr("disabled","true").val("正在提交");
	var url="license_update.jsp?code=" + code + "&license="+license;
	$.ajax({
		type: "post",dataType:"json",url: url,
		success: function(msg){
			
			if(msg.status>0)
			{
				//window.console.info("a");
				window.location = "license.jsp";
				return;				
			}
			else
			{
				//alert(msg.message);
				notify.html("<font color=red>"+msg.message+"</font>");
				$("#submit_btn").attr("disabled","false").val("提交");
				return;	
			}

			//this.location = "license.jsp";
		}
	});
}
</script>
</head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div class="content_t1">
	<div class="content_t1_nav"> 许可证设置</div>
</div>

 
<div class="content_2012">
  	<div class="viewpane">
        <div class="viewpane_tbdoy">

<table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" id="oTable" class="view_table">
<form name="form" action="license_edit.jsp" method="post" onSubmit="return check();">
			<thead>
				<tr>
    				<th class="v1" width="25" align="center" valign="middle">&nbsp;</th>
    				<th class="v3" style="padding-left:10px;text-align:left;">&nbsp;</th>
  				</tr>
			</thead>
	  <%if(flag==0 || flag==1){%>
      <tr>
        <td></td><td><font color=red><%if(flag==1){%>该系统的许可证无效或已经过期，请设置新的许可证代码。<%}else{%>系统需要设置正确的许可代码，请联系管理员进行设置。<%}%></font></td>
      </tr>
      <tr>
        <td>许可代码：</td><td><textarea name="license" id="license" cols=62 rows=6 class="textfield"></textarea></td>
      </tr>
      <tr>
        <td>代码编号：</td><td><input type="text" name="code" id="code" value="" size="60"></td>
      </tr>
	  <tr>
        <td>机器码：</td><td><b><%=serverCode%></b></td>
      </tr>
	  <%}else if(flag==2){%>
      <tr>
        <td></td><td>许可设置成功，请重新启动系统，然后重新登录使用。</td>
      </tr>
	  <%}%>
<%if(flag!=2){%>
              <tr class="rows1"> 
                <td width="145" ></td>
                <td width="544" >
				<input name="Submit" id="submit_btn" type="button" class="tidecms_btn2" value="提交" onClick="update()" />&nbsp;<input name="Reset" type="reset" class="tidecms_btn2" value="取消" />&nbsp;<span id="notify"></span></td>
              </tr>
<%}%>
</form>
</table>


</div>
</div>
</div>
 
</body>
</html>