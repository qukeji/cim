<%@ page import="java.sql.*,
				tidemedia.cms.user.UserInfo"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int id = getIntParameter(request,"id");

UserInfo userinfo = new UserInfo(id);


String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{
//	String			=	getParameter(request,"");
	String	Name		=	getParameter(request,"Name");
	String	Password	=	getParameter(request,"Password");
	String	Email		=	getParameter(request,"Email");
	String	Tel			=	getParameter(request,"Tel");
	String	Comment		=	getParameter(request,"Comment");
	int		Role		=	getIntParameter(request,"Role");

//	u.set();
	userinfo.setName(Name);
	userinfo.setPassword(Password);
	userinfo.setEmail(Email);
	userinfo.setTel(Tel);
	userinfo.setComment(Comment);
	userinfo.setRole(Role);

	userinfo.setMessageType(2);
	userinfo.Update();

	response.sendRedirect("../close_pop.jsp");return;
}

%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script language="javascript">
function check()
{
//	if(isEmpty(document.form.Username,"请输入登录名."))
//		return false;
//	if(isEmpty(document.form.Password,"请输入密码."))
//		return false;

	if(document.form.Password.value == "******")
		document.form.Password.value = "";

	var Role_Checked = "0";
	for(var i = 0;i<document.form.Role.length;i++)
	{
		if(document.form.Role[i].checked=="1")
			Role_Checked = "1";
	}
	if(Role_Checked=="0")
	{
		alert("请选择角色.");
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

<body leftmargin="1" topmargin="1" marginwidth="1" marginheight="1" scroll="no">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
<form name="form" method="post" action="user_edit.jsp" onSubmit="return check();">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
        <tr> 
          <td width="150" align="right">登录名：</td>
          <td class="lin28">
              <%=userinfo.getUsername()%>
            </td>
        </tr>
        <tr> 
          <td align="right">密码：</td>
          <td class="lin28">
              <input name="Password" type="Password" class="textfield" value="******">
            </td>
        </tr>
        <tr> 
          <td align="right">姓名：</td>
          <td class="lin28">
              <input name="Name" type="text" class="textfield" value="<%=userinfo.getName()%>">
            </td>
        </tr>
        <tr> 
          <td align="right">电子邮件：</td>
          <td class="lin28">
              <input name="Email" type="text" class="textfield" value="<%=userinfo.getEmail()%>">
            </td>
        </tr>
        <tr> 
          <td align="right">电话：</td>
          <td class="lin28">
              <input name="Tel" type="text" class="textfield" value="<%=userinfo.getTel()%>">
            </td>
        </tr>
        <tr> 
          <td align="right">备注：</td>
          <td class="lin28">
              <input name="Comment" type="text" class="textfield" value="<%=userinfo.getComment()%>">
            </td>
        </tr>
        <tr> 
          <td align="right">角色：</td>
          <td class="lin28">
             <input name="Role" type="radio" id="Role1" value="1" <%=userinfo.getRole()==1?"checked":""%>>
      <label for="Role1">系统管理员</label>
      <input name="Role" type="radio" id="Role2" value="2" <%=userinfo.getRole()==2?"checked":""%>>
      <label for="Role2">高级编辑</label>
      <input name="Role" type="radio" id="Role3" value="3" <%=userinfo.getRole()==3?"checked":""%>>
      <label for="Role3">编辑</label>
            </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray"><input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onClick="self.close();">
<input type="hidden" name="Submit" value="Submit">
	<input type="hidden" name="id" value="<%=id%>">
	</td>
  </tr>
</form>
</table>
</body>
</html>
