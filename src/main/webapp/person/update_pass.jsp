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
	String referer= request.getHeader("Referer");
	referer = convertNull(referer);
//	String			=	getParameter(request,"");
	String	Password		=	getParameter(request,"Password");
	//String	Password	=	getParameter(request,"Password");
	String	Repassword		=	getParameter(request,"RePassword");
//	String	Tel			=	getParameter(request,"Tel");
//	String	Comment		=	getParameter(request,"Comment");

//	u.set();
	//userinfo.setName(Name);
//	if(Password.equals("")||Password == null){
//		Message="请输入密码";
//	}else if(Repassword.equals("")||Repassword == null){
//		Message="请再次输入密码";
//	}else if(Password.length()<6){
//		Message ="密码长度不能小于6位";
//	}else if(!Password.equals(Repassword)){
//		Message = "两次输入密码不一致";
//	
//	}else if(Password.equals(userinfo.getUsername())){
//		Message="密码不能与用户名一致";
		
//	}else{
		//if(referer.contains("/person/tree.jsp"))
		//{
			userinfo.setPassword(Password);
			//userinfo.setEmail(Email);
			//userinfo.setTel(Tel);
			//userinfo.setComment(Comment);
	
			userinfo.setMessageType(2);
			userinfo.setActionUser(userinfo_session.getId());
			userinfo.Update();
			Message = "信息更新成功！";
		//}
		//else
		//{
		//	Message = "不合法的请求！";
		//}
//	}
	

}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script src="../common/jquery.js" type="text/javascript"></script>
<script language="javascript">
function check()
{

	

		var pwd = $("#Password").val();
		var repwd=$("#RePassword").val();
		//alert(pwd);
		if(pwd==""){
			alert("密码不能为空");
			$("#RePassword").val("");
			return false;
		}
		if(repwd==""){
			alert("请再次输入密码");
			$("#Password").val("");
			return false;
		}
		if(pwd!=repwd){
			alert("两次输入不一致");
			$("#Password").val("");
			$("#RePassword").val("");
			return false;
		}
		var uname = "<%=userinfo.getUsername()%>";
		var role = "<%=userinfo.getRoleName()%>";
		if(uname==pwd){
			alert("用户名密码不能相同");
			$("#Password").val("");
			$("#RePassword").val("");
			return false;
		}else{
			if(role=="系统管理员" && pwd.length<8){
				alert("系统管理员的密码长度不能小于8位");
				return false;
			}else if((role=="频道管理员" || role=="编辑" )&& pwd.length<6){
				alert("频道管理员或编辑的密码长度不能少于6位");
				return false;
			}else{
				return true;
			}
		}

	return false;
	
	
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
<form name="form" method="post" action="update_pass.jsp" onSubmit="return check();">
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
          <td align="right">新密码：</td>
          <td class="lin28">
               <input name="Password" type="Password" class="textfield" id="Password" value="">
            </td>
        </tr>
        <tr> 
          <td align="right">再次输入新密码：</td>
          <td class="lin28">
              <input name="RePassword" type="Password" class="textfield" id="RePassword" value="">
            </td>
        </tr>
        <tr> <td></td>
          <td class="lin28">
 
		<input name="submitButton" type="submit" class="tidecms_btn3" value="  确定  " id="submitButton"/>
	  &nbsp; 
		<input name="Submit2" type="button" class="tidecms_btn3" value="  取消  "  onclick="self.close();" style="display:none"/>

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
