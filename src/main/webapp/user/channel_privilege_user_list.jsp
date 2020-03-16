<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!(new UserPerm().canManageUser(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");
int GroupID = getIntParameter(request,"GroupID");

if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");
	UserInfo userinfo = new UserInfo(id);

	if(userinfo.getRole()==1)
	{
		if(!(new UserPerm().canManageAdminUser(userinfo_session)))
		{response.sendRedirect("../noperm.jsp");return;}
	}
	//userinfo.setMessageType();
	userinfo.Delete(id);

	response.sendRedirect("user_list.jsp?GroupID="+GroupID);return;
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
    myObject.GroupID = "<%=GroupID%>";

function showUser(id,name,role)
{
	var myObject = new Object();
	myObject.Name = name;
	myObject.UserID = id;
	myObject.Role = role;
	window.returnValue=myObject;
	window.close();
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="8" cellpadding="0">
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="5" id="oTable">
              <tr align="center"> 
                <td width="38" class="box-blue"><span class="font-white">编号</span></td>
                <td width="96" class="box-blue"><span class="font-white">角色</span></td>
                <td width="134" class="box-blue"><span class="font-white">姓名</span></td>
              </tr>
<%
UserInfo userinfo = new UserInfo();
String ListSql = "select * from userinfo";
String CountSql = "select count(*) from userinfo";

if(GroupID==0)
{
	ListSql += " where Role!=1 and (GroupID=0 or GroupID is null) order by Role,id";
	CountSql += " where Role!=1 and (GroupID=0 or GroupID is null)";
}
else
{
	ListSql += " where Role!=1 and GroupID=" + GroupID + " order by Role,id";
	CountSql += " where Role!=1 and GroupID=" + GroupID;
}

	
ResultSet Rs = userinfo.List(ListSql,CountSql,1,20);
if(userinfo.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				String Name = convertNull(Rs.getString("Name"));
				String Password = convertNull(Rs.getString("Password"));
				String Email = convertNull(Rs.getString("Email"));
				int Status = Rs.getInt("Status");
				int Role = Rs.getInt("Role");
				int id = Rs.getInt("id");

				String RoleName = "";

				if(Role==1)
					RoleName = "系统管理员";
				else if(Role==2)
					RoleName = "频道管理员";
				else if(Role==3)
					RoleName = "编辑";
				else if(Role==4)
					RoleName = "记者";

				j++;
%>
              <tr class="<%=(j%2==0)?"rows2":"rows1"%>"> 
                <td width="38" ><%=j%></td>
                <td width="96" ><%=RoleName%></td>
                <td width="134" ><a href="javascript:showUser(<%=id%>,'<%=Name%>',<%=Role%>);" class="operate"><%=Name%></a></td>
              </tr>
<%
			}			
%>
            </table>
<%
}
else
{
%>
<%
}
userinfo.closeRs(Rs);
%>
            </table>
			</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
