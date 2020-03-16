<%@ page import="java.sql.*,
				tidemedia.cms.user.UserInfo"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int id = getIntParameter(request,"id");

UserInfo userinfo = userinfo_session;

String Message = "";
String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{
//	String			=	getParameter(request,"");
	String	Name		=	getParameter(request,"Name");
	//String	Password	=	getParameter(request,"Password");
	String	Email		=	getParameter(request,"Email");
	String	Tel			=	getParameter(request,"Tel");
	String	Comment		=	getParameter(request,"Comment");

//	u.set();
	userinfo.setName(Name);
	//userinfo.setPassword(Password);
	userinfo.setEmail(Email);
	userinfo.setTel(Tel);
	userinfo.setComment(Comment);

	userinfo.setMessageType(2);
	userinfo.setActionUser(userinfo_session.getId());
	userinfo.Update();

	Message = "信息更新成功！";
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script language="javascript">
function check()
{
//	if(isEmpty(document.form.Username,"请输入登录名."))
//		return false;
//	if(isEmpty(document.form.Password,"请输入密码."))
//		return false;

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
<%=Message%>
<div class="content_t1">
	<div class="content_t1_nav">你的姓名：<%=userinfo.getName()%></div>
	<div class="content_new_post">


    </div>
</div>

 
<div class="content_2012">
  	<div class="viewpane">
        <div class="viewpane_tbdoy">
<table width="100%" border="0" cellspacing="0" cellpadding="10" class="view_table">
<form name="form" method="post" action="my_info.jsp" onSubmit="return check();">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle"></th>
    				<th class="v3" style="padding-left:10px;text-align:left;"></th>
  				</tr>
</thead>
        <tr> 
          <td width="150" align="right">登录名：</td>
          <td class="lin28">
              <%=userinfo.getUsername()%>
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
			<%=userinfo.getRoleName()%>
            </td>
        </tr>
        <tr> <td></td>
          <td class="lin28">
 
		<input name="Button2" type="submit" class="tidecms_btn2" value="  确  定  "/>
	  &nbsp; 
		<input name="Submit2" type="button" class="tidecms_btn2" value="  取  消  "  onclick="self.close();"/>

        <input type="hidden" name="Submit" value="Submit">
	    <input type="hidden" name="id" value="<%=id%>">
            </td>
        </tr>
		</form>
      </table>

</div>
</div>

</div>
 </body>
</html>