<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	if(!(new UserPerm().canManageUser(userinfo_session)))
	{response.sendRedirect("../noperm.jsp");return;}

	String phone = getParameter(request,"phone");
	int userId = getIntParameter(request,"userId");
	int type = getIntParameter(request,"type");
		
	String result = "" ;
	TableUtil tu = new TableUtil("user");
	String sql = "select Name from userinfo where Tel='"+phone+"' and id!="+userId;
	if(type==1){//新建
		sql = "select Name from userinfo where Tel='"+phone+"'";
	}
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next()){
		String Name = convertNull(rs.getString("Name"));
		result = "此手机号已被"+Name+"绑定" ;
	}
	tu.closeRs(rs);
	out.println(result);
%>