<%@ page
	import="java.sql.*,
			java.io.*,
			tidemedia.cms.base.MessageException"
	isErrorPage="true"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%	// Get parameter values
	String 	message	= request.getParameter("message");
	if(message==null)
		message = "";
%>
<%
//check user validate

/////////////////
// Init parameters
String ClassName="";
String Message = "";


ClassName = exception.getClass().getName();
if(ClassName.equals("tidemedia.cms.base.MessageException"))
{
	MessageException messageexception = (MessageException)exception;

	if(messageexception.getMessageType()==1)
	{
		response.addHeader("Expires","0");
		response.addHeader("Pragma","no-cache");
		response.addHeader("Cache-Control","no-cache");
		out.println("<script language=javascript>");
		out.println("alert(\""+tidemedia.cms.util.Util.JSQuote(exception.getMessage())+"\");");
		out.println("history.back();");
		out.println("</script>");
		out.flush();
		out.close();
	}
	else if(messageexception.getMessageType()==0)
	{
		Message = exception.getMessage();
	}
	else if(messageexception.getMessageType()==2)
	{
		response.addHeader("Expires","0");
		response.addHeader("Pragma","no-cache");
		response.addHeader("Cache-Control","no-cache");
		out.println("<script language=javascript>");
		out.println("alert(\""+tidemedia.cms.util.Util.JSQuote(exception.getMessage())+"\");");
		out.println("self.close();");
		out.println("</script>");
		//out.close();
	}
	else if(messageexception.getMessageType()==3)
	{
		response.addHeader("Expires","0");
		response.addHeader("Pragma","no-cache");
		response.addHeader("Cache-Control","no-cache");
		out.println("<script language=javascript>");
		out.println("alert(\""+tidemedia.cms.util.Util.JSQuote(exception.getMessage())+"\");");
		out.println("window.location = document.referrer;");
		out.println("</script>");
		//out.close();
	}
}
else if(ClassName.equals("java.lang.ClassCastException"))
{
	Message = "Not found one class's Instance";
}
else if(ClassName.equals("java.sql.SQLException"))
{
	exception.printStackTrace();
	Message = "数据库操作错误，请联系管理员.";
}
else
{
	exception.printStackTrace();
	Message = "出现未知错误，请联系管理员.";
}
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" >
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="color01">
  <tr> 
    <td height="1" colspan="2" bgcolor="#9BB128"></td>
  </tr>
  <tr> 
    <td height="1" colspan="2" bgcolor="#FFFFFF"></td>
  </tr>
  <tr bgcolor="#F5F5F5"> 
    <td height="18">&nbsp;</td>
    <td class="font10"></td>
  </tr>
  <tr> 
    <td height="1" colspan="2" bgcolor="#FFFFFF"></td>
  </tr>
  <tr> 
    <td height="1" colspan="2" bgcolor="#CCCCCC"></td>
  </tr>
</table>
<table width="80%" border="0" cellspacing="4" cellpadding="0">
  <tr valign="top"> 
    <td width="140"> 
    </td>
    <td align="center"> 
    
    </td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="50">
  <tr>
    <td><p>&nbsp;</p>
<table cellspacing="0" cellpadding="0" border="0" width="80%" align="center">
        <tr>
          <td bgcolor="#98B2CC"> 
            <table border="0" cellspacing="1" cellpadding="4" width="100%">
              <tr class="header">
                <td bgcolor="#AFC733">系统提示:</td>
              </tr>
              <tr>
                <td bgcolor="#FfffFF" align="center"> 
                  <table border="0" width="90%" cellspacing="0" cellpadding="0">
                    <tr>
                      <td align="center" class="smalltxt"> <br>
                        <%=Message%><br>
                        <br>
                        <a href="#" onClick="history.go(-1)">[返回]</a> <br>
                        <br>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    <p>&nbsp;</p></td>
  </tr>
</table>
</body>
</html>
