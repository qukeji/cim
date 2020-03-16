<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
public String getParameter(HttpServletRequest request,String str)
	{
	if(request.getParameter(str)==null)
		return "";
	else
		return request.getParameter(str);
	}
%><%
String Username = "";
String Username2 = "";

Cookie[] cookies = request.getCookies();
if(cookies!=null)
{
	for(int i=0;i<cookies.length;i++)
	{
		if(cookies[i].getName().equals("Username"))
			Username = cookies[i].getValue();	
		if(cookies[i].getName().equals("Username2"))
			Username2 = cookies[i].getValue();	
	}
}

String Url = getParameter(request,"Url");
if(!Username2.equals(""))
{
		UserInfo userinfo = new UserInfo();

		if(userinfo.Authorization(request,response,Username,Username2,true)==1)
		{
			if(Url.equals(""))
				response.sendRedirect("main.jsp");
			else
				response.sendRedirect(Url);
			return;
		}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideVMS - <%=CmsCache.getCompany()%></title>
<meta name="robots" content="noindex, nofollow"/>
<link rel="Shortcut Icon" href="favicon.ico"/>
<script type="text/javascript" src="common/jquery.js"></script>
<script type="text/javascript" src="common/jquery.anystretch.min.js"></script>
<link href="style/9/style.css" type="text/css" rel="stylesheet" />
<script language=javascript>
function init()
{
	if (top.location != self.location)top.location=self.location;
	document.form.Username.focus();
	document.form.Username.value = "<%=Username%>";
	
	if(document.form.Username.value=="")
		document.form.Username.focus();
	else
		document.form.Password.focus();
	$.anystretch("./images/login_bg/default.jpg",{speed: 150});
}

function check()
{
	if(document.form.Username.value=="")
	{
		alert("请输入用户名!");
		document.form.Username.focus();
		return false;
	}
	if(document.form.Password.value=="")
	{
		alert("请输入密码!");
		document.form.Password.focus();
		return false;
	}

	return true;
}
</script>
</head>

<body onLoad="init();">
<div class="login_2012">
	<div class="ver"></div>
    <form name="form" method="post" action="login.jsp" onSubmit="return check();">
    	<div class="login_l">
            <div class="login_c_2012">
                <label>用户名：</label>
                <input name="Username" type="text" class="text" tabindex="1"/>
            </div>
            <div class="login_c_2012">
                <label>密  码：</label>
                <input name="Password" type="password" class="text" tabindex="2"/>
            </div>
            <div class="login_c_2012" style="padding-left:54px;">
                <input name="" type="submit" value="登录" class="button" tabindex="4"/>
            </div>
        </div>
        <div class="login_r">
        	<%if(CmsCache.getConfig().getCookieLogin().equals("true")){%>
			<div class="login_remember"><input type="checkbox" name="CookieLogin" value="1" id="login_remember" tabindex="3"><label for="login_remember">保持登录状态</label></div>
			<%}%>
        </div>
		<%if(!Url.equals("")){%><input name="Url" type="hidden" value="<%=Url%>"><%}%>
    </form>
</div>
</body>
</html>
