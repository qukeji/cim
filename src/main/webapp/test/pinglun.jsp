<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}
%>


<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int ngid = 0;
int gid = getIntParameter(request,"gid");

if(gid>0)
{
	String Sql = "";
	ResultSet Rs;
	TableUtil tu = new TableUtil();

	
	System.out.println("");
	//Sql = "SELECT * FROM item_snap where CreateDate>=UNIX_TIMESTAMP('2009-8-19 23:20:22')";
	Sql = "SELECT GlobalID,ChannelID FROM item_snap where GlobalID>="+gid+" limit 1000";
	ResultSet rs = tu.executeQuery(Sql);
	while(rs.next())
	{
		ngid = rs.getInt("GlobalID");
		int channelid = rs.getInt("ChannelID");
		Channel channel = CmsCache.getChannel(channelid);
		String code = channel.getChannelCode();
		if(code.startsWith("9866_9893"))
		{
			Document doc = new Document(ngid);
			if(doc.getStatus()==1)
			{
				//System.out.println(doc.getTitle()+" "+doc.getFullHref());
				System.out.print(","+ngid);
				//out.println(","+ngid);out.flush();response.flushBuffer();
				new CallServices().call(doc,"");
			}
		}	
	}

	tu.closeRs(rs);
}
else
{
	out.println("参数有问题");
}

if(ngid>0)
{
%><meta http-equiv="refresh" content="2; url=pinglun.jsp?gid=<%=(ngid+1)%>" /><%
	//response.sendRedirect("pinglun.jsp?gid="+(ngid+1));
}
%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!