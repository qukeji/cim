<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String sql = "select * from item_snap where GlobalID>745962";//
TableUtil tu = new TableUtil();
ResultSet rs = tu.executeQuery(sql);
while(rs.next())
{
	int gid = rs.getInt("GlobalID");
	Document doc = new Document(gid);
	doc.setUser(userinfo_session.getId());
	if(doc.getStatus()==1)
	{
		String code = doc.getChannel().getChannelCode();
		if(code.startsWith("4144_4152")||code.startsWith("6022_6023")||code.startsWith("10538_10540")||code.startsWith("10950_10951"))
		{
			doc.Approve(doc.getId()+"",doc.getChannelID());
			System.out.println(doc.getTitle());
		}
	}
}
tu.closeRs(rs);

%>