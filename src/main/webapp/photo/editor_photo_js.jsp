<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.util.*,tidemedia.cms.user.*,tidemedia.cms.publish.*,org.json.*,magick.*,java.util.*,java.sql.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config1.jsp"%><%
tidemedia.cms.system.Site defaultSite = tidemedia.cms.system.CmsCache.getDefaultSite();
	int gid = getIntParameter(request,"gid");
	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
	int id = photo_config.getInt("channelid");

	if(id==0)
	{
		out.println("图片集频道没有配置.");
		return;
	}
	Channel channel = CmsCache.getChannel(id);
	String Sql = "select * from "+channel.getTableName()+" where Parent="+gid+" and Status=1";
	TableUtil tu = channel.getTableUtil();
	ResultSet Rs = tu.executeQuery(Sql);
	String json = "var tide_photos ={'items':[";
	int it = 0;
	while(Rs.next())
	{
		String Photo = "";
		String Photo_s = "";
		String jianxu = "";
		String title = "";
		String Photo_m = "";

	
		Photo_s = tu.convertNull(Rs.getString("Photo_s"));//小图
		jianxu = tu.convertNull(Rs.getString("Summary"));
		title = tu.convertNull(Rs.getString("Title"));
		Photo = tu.convertNull(Rs.getString("Photo"));//大图

		json+="{'title':'"+title+"',"+"'summary':"+"'"+jianxu+"',"+"'photo':"+"'"+Photo+"',"+"'photo_s':"+"'"+Photo_s+"'}";
		json = json.substring(0,json.length()-1);
		json+="},";

	}
	json = json.substring(0,json.length()-1);
	json+="]};";
	out.print(json);
	tu.closeRs(Rs);
%>
