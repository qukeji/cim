<%@ page import="tidemedia.cms.system.*,
				 tidemedia.cms.util.*,
				 java.util.*,
				 java.sql.*,
				 java.io.*,
				 tidemedia.cms.base.*"%>
<%@ page import="tidemedia.cms.page.Page" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
public void import_channel(String file,int channelid,int userid) throws MessageException, SQLException, IOException{

	ChannelImport channel_import = new ChannelImport();
	channel_import.setChannelid(channelid);
	channel_import.setFilename(file);
	channel_import.setUserid(userid);

	channel_import.setImport_document(true);
	channel_import.setImport_template(true);
	channel_import.setImport_channel(true);

	String result = channel_import.start();
}
%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

int parent = getIntParameter(request,"parent");//站点频道编号

if(parent!=0){//导入频道
	import_channel("15893.zip",parent,userinfo_session.getId());//APP管理
	import_channel("16319.zip",parent,userinfo_session.getId());//APP配置
	import_channel("15963.zip",parent,userinfo_session.getId());//用户管理
	import_channel("15964.zip",parent,userinfo_session.getId());//互动管理
	import_channel("15933.zip",parent,userinfo_session.getId());//网站管理

	out.println("导入完成");
}
out.println("父频道编号："+parent);
%>