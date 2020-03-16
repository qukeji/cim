<%@ page import="java.io.*,
				java.util.*,
				tidemedia.cms.email.*,
				tidemedia.cms.base.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

EmailConfig ec = new EmailConfig();
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
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top"><table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
        <tr> 
          <td align="right"> 
		 
		  </td>
          <td width="20" align="right"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="8" cellpadding="0">
        <tr>
          <td>
            <table width="80%" border="0" align="center" cellpadding="5" cellspacing="0" id="oTable">
              <tr align="center"> 
                <td width="5" class="box-blue"><span class="font-white"></span></td>
                <td width="153" class="box-blue"><span class="font-white"></span></td>
                <td width="422" class="box-blue"><span class="font-white"></span></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">邮件发送服务器：</div></td>
                <td width="422"><%=ec.getServer()%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">用户名：</div></td>
                <td width="422"><%=ec.getUsername()%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">信箱：</div></td>
                <td width="422"><%=ec.getEmail()%></td>
              </tr>

              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" ></td>
                <td width="422">
                  <%if(!userinfo_session.hasPermission("DisableChangeConfig")){%>
                  <input type="button" name="button1" class="tidecms_btn3" value="修改配置信息" onClick="edit();"><%}%></td>
              </tr>
            </table>

            <div align="center"></div>
          </table>
			</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
