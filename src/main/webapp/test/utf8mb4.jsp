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

<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();
TableUtil tu2 = new TableUtil();
TableUtil tu_user = new TableUtil("user");


Sql = "select * from channel where Type=0 ";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	Channel ch = CmsCache.getChannel(Rs.getInt("id"));
	try{
	String updatesql="ALTER TABLE channel_" + Rs.getString("SerialNo")+" CHANGE Content Content MEDIUMTEXT character set utf8mb4 COLLATE utf8mb4_unicode_ci;";
	ch.getTableUtil().executeUpdate(updatesql);
	out.println("操作成功"+updatesql+"</br>");
	}catch(Exception e){out.println("操作失败   错误信息："+e.getMessage()+updatesql+"</br>");}
	
}
tu.closeRs(Rs);

try{
	String update_page_content="ALTER TABLE page_content CHANGE Content Content MEDIUMTEXT  character set utf8mb4 COLLATE utf8mb4_unicode_ci;";
	new TableUtil().executeUpdate(update_page_content);
	out.println("+操作成功+"+update_page_content+"</br>");
}catch(Exception e){
	out.println("操作失败   错误信息："+e.getMessage()+update_page_content+"</br>");
}


%>

<br>Over!
