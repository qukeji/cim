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

	String username = getParameter(request,"username");
	TableUtil tu = new TableUtil("user");
	String sql = "select * from userinfo where username='"+username+"'";
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next()){
		out.print("1");
	}
	tu.closeRs(rs);
%>