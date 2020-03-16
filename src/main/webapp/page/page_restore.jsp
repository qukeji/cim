<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.page.*,
				tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{
	out.println("没有权限.");
}
else
{
	int id = getIntParameter(request,"id");
	int pid = 0;
	TableUtil tu = new TableUtil();
	String sql = "select * from page_content where id="+id+" order by id desc";
	String Content = "";
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		Content = rs.getString("Content");
		pid = rs.getInt("Page");
	}
	tu.closeRs(rs);
	//out.println(pid);
	
	Page p = new Page(pid);
	p.setActionUser(userinfo_session.getId());
	p.setContent(Content);
	p.savePage();
	out.println("true");
}
%>