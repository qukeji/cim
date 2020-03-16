<%@ page import="java.io.*,
				java.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				java.sql.ResultSet"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

//ErrorLog errorlog = new ErrorLog(id);
TableUtil tu=new TableUtil();
String sql="select * from publish_task where id="+id;
ResultSet rs=tu.executeQuery(sql);
String message="";
while(rs.next()){
	message = tu.convertNull(rs.getString("Message"));
}
tu.closeRs(rs);
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="auto">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="8" cellpadding="0">
        <tr>
          <td>
            <table width="80%" border="0" align="center" cellpadding="5" cellspacing="0" id="oTable">
              <tr align="center"> 
                <td width="452" class="box-blue"><span class="font-white"></span></td>
              </tr>
              <tr valign="top" class="rows1"> 
                <td width="452"><%=message%></td>
            

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
