<%@ page import="java.io.*,
				java.util.*,
				tidemedia.cms.email.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!(new UserPerm().canEditConfig(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

EmailConfig ec = new EmailConfig();

String Submit = getParameter(request,"Submit");
if(!Submit.equals("") )
{
//	String			=	getParameter(request,"");
	String	Server		=	getParameter(request,"Server");
	String	Username	=	getParameter(request,"Username");
	String	Password	=	getParameter(request,"Password");
	String	Email		=	getParameter(request,"Email");
	String	Personal	=	getParameter(request,"Personal");

	ec.setServer(Server);
	ec.setUsername(Username);
	ec.setPassword(Password);
	ec.setEmail(Email);
	ec.setPersonal(Personal);

	ec.Add();

	response.sendRedirect("config.jsp");return;
}
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script language=javascript>
function edit()
{
	this.location='edit.jsp';
}

function check()
{
//	if(isEmpty(document.form.Username,"请输入登录名."))
//		return false;

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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr> 
    <td width="70" align="right">参数设置： </td>
    <td align="right"></td>
  <td width="20" align="right"></td>
  </tr>
</table>
            <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" id="oTable">
			<form name="form" method="post" action="edit.jsp" onSubmit="return check();">
              <tr align="center"> 
                <td width="82" class="box-blue"><span class="font-white"></span></td>
                <td width="145" class="box-blue"><span class="font-white"></span></td>
                <td width="544" class="box-blue"><span class="font-white"></span></td>
              </tr>
              <tr class="rows1"> 
                <td width="82" ></td>
                <td width="145" ><div align="right">邮件发送服务器：</div></td>
                <td width="544" ><input class="textfield" type="text" size=40 name="Server" value="<%=ec.getServer()%>"></td>
              </tr>
              <tr class="rows1"> 
                <td width="82" ></td>
                <td width="145" ><div align="right">用户名：</div></td>
                <td width="544" ><input class="textfield" type="text" size=40 name="Username" value="<%=ec.getUsername()%>"></td>
              </tr>
              <tr class="rows1"> 
                <td width="82" ></td>
                <td width="145" ><div align="right">密码：</div></td>
                <td width="544" ><input class="textfield" type="text" size=40 name="Password" value="<%=ec.getPassword()%>"></td>
              </tr>
              <tr class="rows1"> 
                <td width="82" ></td>
                <td width="145" ><div align="right">发件人邮件地址：</div></td>
                <td width="544" ><input class="textfield" type="text" size=40 name="Email" value="<%=ec.getEmail()%>"></td>
              </tr>
              <tr class="rows1"> 
                <td width="82" ></td>
                <td width="145" ><div align="right">发件人名称：</div></td>
                <td width="544" ><input class="textfield" type="text" size=40 name="Personal" value="<%=ec.getPersonal()%>"></td>
              </tr>

              <tr class="rows1"> 
                <td width="82" ></td>
                <td width="145" ></td>
                <td width="544" ><input type="submit" name="Submit" value="提交" class="tidecms_btn3"> &nbsp;<input type="reset" name="Reset" value="取消" class="tidecms_btn3"></td>
              </tr>
			  </form>
            </table>
</body>
</html>
