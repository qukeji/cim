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
	服务端程序，通过该jsp获得升级包信息。
*/
	int channelid_sjb = 5047;//升级包channelid
	int channelid_wj=5048;//升级文件channelid
	int itemid=0;
	itemid=getIntParameter(request,"id");

	String content="";
	Channel channel_sjb = CmsCache.getChannel(channelid_sjb);
	String sql="";
	String site="http://www.tidedemo.com";

	String Title_sjb="";
	String PublishDate_sjb="";
	String Summary_sjb="";
	String folder_wj="";
	String title_wj="";
	String updated_message="";
	String update_before_message="";
	String createtime="";
	String do_after_updated="";
	String isdoupdate="";
	int id=0;
	Channel channel_wj = CmsCache.getChannel(channelid_wj);
	String sql2="";

	if(itemid!=0){
		
	sql="select * from "+channel_sjb.getTableName()+" where Active=1 and Status=1 and id="+itemid+" order by PublishDate desc";
	TableUtil tu = new TableUtil();
	ResultSet rs= tu.executeQuery(sql);
	int temp=0;
	while(rs.next()){
		if(temp!=0){
			content+=",";
		}
		Title_sjb=rs.getString("Title");
		PublishDate_sjb	= Util.convertNull(rs.getString("PublishDate"));
		PublishDate_sjb=Util.FormatDate("yyyy-MM-dd HH:mm",Long.parseLong(PublishDate_sjb)*1000);
		Summary_sjb=Util.convertNull(rs.getString("Summary"));
		createtime=Util.convertNull(rs.getString("createtime"));
		do_after_updated=Util.convertNull(rs.getString("do_after_updated"));
		if(createtime.equals("")){
		createtime=PublishDate_sjb;
		}
		String gid=rs.getString("GlobalID");
		updated_message=Util.convertNull(rs.getString("updated_message"));
		update_before_message=Util.convertNull(rs.getString("update_before_message"));
		//isdoupdate=Util.convertNull(rs.getString("isdoupdate"));
		id=rs.getInt("id");
		content+="{";
		content+="\"title\":\""+Title_sjb+"\",\"Summary\":\""+Summary_sjb+"\",\"PublishDate\":\""+PublishDate_sjb+"\"";
		content+=",\"GlobalID\":\""+gid+"\"";
		content+=",\"createtime\":\""+createtime+"\"";
		content+=",\"do_after_updated\":\""+do_after_updated+"\"";
		content+=",\"update_before_message\":\""+update_before_message+"\"";
		content+=",\"updated_message\":\""+updated_message+"\"";
		//content+=",\"isdoupdate\":\""+isdoupdate+"\"";
		content+=",\"id\":\""+id+"\"";
		content+="}";
		temp++;
	}
	tu.closeRs(rs);
	content=content.replace("\r\n","</br>");
	out.println(content);

	}else{
	content+="[";
	sql="select * from "+channel_sjb.getTableName()+" where Active=1 and Status=1 order by PublishDate desc";
	TableUtil tu = new TableUtil();
	ResultSet rs= tu.executeQuery(sql);
	int temp=0;
	while(rs.next()){
		if(temp!=0){
			content+=",";
		}
		Title_sjb=rs.getString("Title");
		PublishDate_sjb	= Util.convertNull(rs.getString("PublishDate"));
		PublishDate_sjb=Util.FormatDate("yyyy-MM-dd HH:mm",Long.parseLong(PublishDate_sjb)*1000);
		Summary_sjb=Util.convertNull(rs.getString("Summary"));
		createtime=Util.convertNull(rs.getString("createtime"));
		do_after_updated=Util.convertNull(rs.getString("do_after_updated"));
		if(createtime.equals("")){
		createtime=PublishDate_sjb;
		}
		String gid=rs.getString("GlobalID");
		updated_message=Util.convertNull(rs.getString("updated_message"));
		update_before_message=Util.convertNull(rs.getString("update_before_message"));
		//isdoupdate=Util.convertNull(rs.getString("isdoupdate"));
		id=rs.getInt("id");
		content+="{";
		content+="\"title\":\""+Title_sjb+"\",\"Summary\":\""+Summary_sjb+"\",\"PublishDate\":\""+PublishDate_sjb+"\"";
		content+=",\"GlobalID\":\""+gid+"\"";
		content+=",\"createtime\":\""+createtime+"\"";
		content+=",\"do_after_updated\":\""+do_after_updated+"\"";
		content+=",\"update_before_message\":\""+update_before_message+"\"";
		content+=",\"updated_message\":\""+updated_message+"\"";
		//content+=",\"isdoupdate\":\""+isdoupdate+"\"";
		content+=",\"id\":\""+id+"\"";
		content+="}";
		temp++;
	}
	tu.closeRs(rs);
	content+="]";
	content=content.replace("\r\n","</br>");
	out.println(content);
	}
%>

