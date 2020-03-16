<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.MessageException,
				tidemedia.cms.base.TableUtil,
				java.io.File,
				java.io.FileInputStream,
				java.io.IOException,
				java.sql.ResultSet,
				java.sql.SQLException,
				java.util.ArrayList,
				java.util.HashMap,
				java.util.List,
				tidemedia.cms.system.Parameter,
				org.json.JSONException,
				org.json.JSONObject,
				java.sql.SQLException,
				java.util.ArrayList,
				tidemedia.cms.base.MessageException,
				tidemedia.cms.system.Channel,
				tidemedia.cms.system.CmsCache,
				tidemedia.cms.system.Field,
				tidemedia.cms.system.FieldGroup,
				java.util.Map"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%! 
//更新系统管理员权限
public void UpdateUserPerm() throws SQLException,MessageException
{
	TableUtil tu = new TableUtil("user");
	String Sql = "select * from userinfo where Role=1";
	ResultSet Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		int id_ = Rs.getInt("id");
		tidemedia.cms.user.UserInfo ui = new tidemedia.cms.user.UserInfo(id_);
		if(!ui.hasPermission("ManageSystem")){			
			TableUtil tu1 = new TableUtil();
			tu1.executeUpdate("insert into user_perm(PermName,PermValue,User) values ('ManageChannel',1,"+id_+"),('ManageFile',1,"+id_+"),('ManageSystem',1,"+id_+")");
		}
	}
	tu.closeRs(Rs);
}
	
%>
<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();
TableUtil tu2 = new TableUtil();
TableUtil tu_user = new TableUtil("user");


//2018-10-24
//网站管理员权限
UpdateUserPerm();

%> 

<br>Over!网站管理员权限已更新