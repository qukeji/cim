<%@ page import="tidemedia.cms.email.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
String	Email		= getParameter(request,"Email");
int ContinueAdd = getIntParameter(request,"ContinueAdd");

if(!Email.equals(""))
{
	String	Name			= getParameter(request,"Name");

	EmailAddress ea = new EmailAddress();

	ea.setEmailAddress(Email);
	ea.setName(Name);

	ea.Add();

	if(ContinueAdd==0)
		{response.sendRedirect("../close_pop.jsp");return;}
}
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script language=javascript>

function check()
{
	if(isEmpty(document.form.Email,"请输入邮件地址."))
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


</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<form name="form" action="email_add.jsp" method="post" onSubmit="return check();">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="8">
        <tr> 
          <td align="right">姓名：</td>
          <td class="lin28">
          <input type=text name="Name" size="32" class="textfield">
          </td>
        </tr>
        <tr> 
          <td align="right">邮件地址：</td>
          <td class="lin28">
          <input type=text name="Email" size="32" class="textfield">
          </td>
        </tr>

	  </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray"><input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();">
	  <input type=checkbox id="s1" name="ContinueAdd" value="1" class="textfield" <%=ContinueAdd==1?"checked":""%>><label for="s1">继续新建</label>
<input type="hidden" name="Parent" value="0">
	</td>
  </tr>
</form>
</table>
</body>
</html>
