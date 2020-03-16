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
<%/*! public void removeItems(int channelid,TableUtil tu) throws SQLException,MessageException
{
	String Sql = "select * from channel where Parent=" + channelid;
	ResultSet Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		removeItems(Rs.getInt("id"),tu);

		if(Rs.getInt("Type")==0 && Rs.getInt("Parent")!=-1)
		{
			tu.executeUpdate("TRUNCATE  channel_"+Rs.getString("SerialNo"));
		}
		System.out.println("<br>"+Rs.getString("SerialNo")+".....clear");
	}
}*/
%>
<%! public void UpdateChannelCode(int channelid) throws SQLException,MessageException
{
	TableUtil tu = new TableUtil();
	String Sql = "select * from channel where Parent=" + channelid;
	ResultSet Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		String channelcode = Util.convertNull(Rs.getString("ChannelCode"));
		int id_ = Rs.getInt("id");
		channelcode = channelcode + "_" + id_;
		UpdateChannelCode(id_);

		TableUtil tu1 = new TableUtil();
		tu1.executeUpdate("update channel set ChannelCode='" + channelcode + "' where id=" + id_);
		tu1 = null;
	}
}
%>
<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();
TableUtil tu2 = new TableUtil();

/*修正ordernumber，使其从1开始按顺序排序*/

/*
UPDATE channel_s30_b,item_snap SET item_snap.OrderNumber=channel_s30_b.OrderNumber WHERE channel_s30_b.GlobalID=item_snap.GlobalID
*/

int i = 1;
Sql = "select id from channel_s30_b order by OrderNumber asc,id asc";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int id = Rs.getInt("id");
	tu2.executeUpdate("update channel_s30_b set OrderNumber2="+i+" where id="+id);
	i++;

	if(i%100==0) System.out.println(i);
}
tu.closeRs(Rs);

%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!

update channel_s30_d_f set OrderNumber=id*100
UPDATE channel_s30_d_f,item_snap SET item_snap.OrderNumber=channel_s30_d_f.OrderNumber WHERE channel_s30_d_f.GlobalID=item_snap.GlobalID
