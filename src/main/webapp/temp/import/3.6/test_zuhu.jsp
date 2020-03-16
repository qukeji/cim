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
//	import_channel("15893.zip",parent,userinfo_session.getId());//APP管理
//	import_channel("16319.zip",parent,userinfo_session.getId());//APP配置
//	import_channel("15963.zip",parent,userinfo_session.getId());//用户管理
//	import_channel("15964.zip",parent,userinfo_session.getId());//互动管理
//	import_channel("15933.zip",parent,userinfo_session.getId());//网站管理

	out.println("导入完成");
}
out.println("父频道编号："+parent);

	Page p = new Page(15934);//页面内容
	out.println(p.getName());
	out.println(new TemplateFile(p.getTemplateFileID()).getFileName());

	/*
	String s = "";
	String sql = "select * from channel where Name='互动管理' order by id desc";
	TableUtil tu = new TableUtil();
	ResultSet Rs = tu.executeQuery(sql);
	while (Rs.next()) {
		s += ","+Rs.getInt("id");
	}
	tu.closeRs(Rs);
	s = s.substring(1);
	out.println(s+"<br>");*/
/*
	s = "32495, 32446, 32377, 32348, 32328, 32270, 32167, 32085, 32050, 32035, 31961, 31937, 31888, 31814, " +
			"31755, 31642, 31419, 31292, 31022, 29411, 27911, 27798, 27764, 27609, 27185, 26978, 26949, 26729, " +
			"26682, 26481, 25929, 25880, 25846, 25349, 25338, 25136, 24985, 24491, 24311, 23887, 23855, 23683, " +
			"23657, 23408, 23338, 23068, 23021, 22725, 22594, 22339, 22308, 22075, 22010, 21814, 21731, 21426, " +
			"21270, 21112, 20764, 20669, 20623, 20591, " +
			"20312, 20240, 20025, 19946, 19707, 19608, 19394, 19321, 19124, 18990, 18847, 18650, 18490, 16408, 15970,";
*//*
	String ss[] = s.split(",");

	for(int i=0;i<ss.length;i++){
	    int parent = Integer.parseInt(ss[i]);
		System.out.println(parent+"导入开始<br>");
		import_channel("16323.zip",parent,userinfo_session.getId());
		
		//用户行为记录
		//import_channel("16324.zip",parent,userinfo_session.getId());
		//import_channel("16344.zip",parent,userinfo_session.getId());
		//import_channel("16345.zip",parent,userinfo_session.getId());

	    out.println(parent+"导入结束<br>");
		
	}
*/

%>