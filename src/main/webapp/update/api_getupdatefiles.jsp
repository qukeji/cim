<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.net.*,
				java.text.*,
				java.io.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
/*

	服务端程序，通过该jsp获得某升级包包含的文件信息。
*/
	//out.println("test");
	int channelid_sjb = 5047;
	int channelid_wj=5048;
	int globalid=0;
	//globalid=Integer.praseInt(getParameter(request,"globalid"));
	int		id				= getIntParameter(request,"id");
	String content="";
	Channel channel_sjb = CmsCache.getChannel(channelid_sjb);
	String sql="";
	String site="";
	String Title_sjb="";
	String PublishDate_wj="";
	String Summary_sjb="";
	String folder_wj="";
	String title_wj="";
	String filesize="";
	String filename="";


	int itemID=0;
	Channel channel_id = CmsCache.getChannel(5047);
	String sql_id="select GlobalID from "+channel_id.getTableName()+" where id="+id;
	TableUtil tu_id = new TableUtil();
	ResultSet rs_id=tu_id.executeQuery(sql_id);
	if(rs_id.next()){
		//out.println("rs中");
		globalid = rs_id.getInt("GlobalID");

	}
	tu_id.closeRs(rs_id);

	Channel channel_wj = CmsCache.getChannel(channelid_wj);
	String sql2="";
	sql2="select * from "+channel_wj.getTableName()+" where Active=1 and Parent='"+globalid+"'";
	content+="{";
	content+="\"files\":[";

	TableUtil tu2 = new TableUtil();
	ResultSet rs2 = tu2.executeQuery(sql2);
	int temp2=0;
	while(rs2.next()){
		if(temp2!=0){
			content+=",";
		}

	title_wj=Util.convertNull(rs2.getString("Title"));
	PublishDate_wj=Util.convertNull(rs2.getString("PublishDate"));
	folder_wj=Util.convertNull(rs2.getString("folder"));
	if(!folder_wj.endsWith("/")){
		folder_wj+="/";
	}
	filesize=Util.convertNull(rs2.getString("filesize"));
	filename=Util.convertNull(rs2.getString("file"));
	content+="{";
	content+="\"name\":\""+title_wj+"\",";
	content+="\"PublishDate\":\""+PublishDate_wj+"\",";
	content+="\"id\":\""+id+"\",";
	content+="\"filename\":\""+filename+"\",";
	content+="\"filesize\":\""+filesize+"\",";
	content+="\"url\":\"";
	content+=folder_wj;
	content+="\"}"; 
	temp2++;
	}
	tu2.closeRs(rs2);
	content+="]";
	content+="}";

	content=content.replace("\r\n","</br>");
	out.println(content);

%>

