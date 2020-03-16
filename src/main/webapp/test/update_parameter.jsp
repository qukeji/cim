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

Parameter p = new Parameter();


p.setName("系统管理员菜单");
p.setCode("sys_admin_menu");
p.setType(1);
p.Add();


p.setName("频道管理员菜单");
p.setCode("sys_channeladmin_menu");
p.setType(1);
p.Add();

p.setName("编辑菜单");
p.setCode("sys_editor_menu");
p.setType(1);
p.Add();


p.setName("相关文章是否双向关联");
p.setCode("sys_related_doc_twoway");
p.setType(1);
p.Add();

/*
p.setName("相关文章程序");
p.setCode("sys_related_doc_url");
p.setType(1);
p.Add();*/


p.setName("水印文件");
p.setCode("sys_watermask_file");
p.setType(1);
p.Add();
%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!