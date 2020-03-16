<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
//执行删除操作的程序
	String Action = getParameter(request,"Action");
	if(Action.equals("Del"))
	{
		int id = getIntParameter(request,"id");
		WebUser webuser = new WebUser();
		String table = "channel_webuser";
		webuser.Delete(id,table);

	response.sendRedirect("webuser.jsp");return;
}
%>

<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">

<script language=javascript>
	var myObject = new Object();
	myObject.title = "";
function editUserInfo(id)
{
    myObject.title = "修改用户";
	var Feature = "dialogWidth:32em; dialogHeight:28em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=userinfo/userinfo_edit.jsp&id=" + id,myObject,Feature);
	if(retu!=null)
		window.location.reload();
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
            <table width="99%" border="0" cellspacing="0" cellpadding="5" id="oTable">
              <tr align="center"> 
              	<td width="55" class="box-blue"><span class="font-white">编号</span></td>
                <td width="75" class="box-blue"><span class="font-white">用户名</span></td>
                <td width="131" class="box-blue"><span class="font-white">电子邮件</span></td>
                <td width="130" class="box-blue"><span class="font-white">操&nbsp;作</td>
              </tr>
      <%
      	WebUser webuser = new WebUser();
      	String Table = "channel_webuser";
      	String ListSql = "select * from "+Table;
      	String CountSql = "select count(*) from "+Table;
      	
      	ResultSet rs = webuser.List(ListSql,CountSql,1,20);
      	
      	int j=0;

		while(rs.next())
		{
			String Name = convertNull(rs.getString("Username"));
			String Email = convertNull(rs.getString("Email"));
			int id = rs.getInt("id");

			j++;
	%>
	    <tr class="<%=(j%2==0)?"rows2":"rows1"%>"> 
                <td width="55" align="center"><%=j%></td>
                <td width="75" align="center"><%=Name%></td>
                <td width="131" align="center"><%=Email%></td>
                <td width="130" align="center">
                  		编辑&nbsp;&nbsp;
                  	<a href="webuser.jsp?Action=Del&id=<%=id%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">
                  		删除
                  	</a>
                </td>
         </tr>
        <%
			}			
		%>
            </table>

		<%
			webuser.closeRs(rs);
		%>

</table>
			</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
            
              


