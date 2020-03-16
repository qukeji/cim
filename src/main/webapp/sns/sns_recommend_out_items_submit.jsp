<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.source.*,
				java.util.ArrayList,
				java.sql.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	int			ChannelID				= getIntParameter(request,"ChannelID");//推荐到的频道编号
	String		SourceItemID			= getParameter(request,"RecommendItemID");//推荐出去的记录编号
	String		sns_tablename			= getParameter(request,"sns_tablename");//推荐出去的文档来自的表名
	int		userid					= getIntParameter(request,"userid");//推荐出去的文档作者名
	//视频：uchome_video  话题：uchome_blog  图文（相册）： uchome_pic  活动：uchome_event
	String doinfo = "";//href 中需要的do参数
	String idstr = "";//不同表中的主键
	
	if(sns_tablename.equals("uchome_thread")){
		doinfo = "thread";
		idstr = "tid";
	}else if(sns_tablename.equals("uchome_blog")){
		doinfo = "blog";
		idstr = "blogid";
	}else if(sns_tablename.equals("uchome_pic")){
		doinfo = "album";
		idstr = "picid";
	}else if(sns_tablename.equals("uchome_event")){
		doinfo = "event";
		idstr = "eventid";
	}else{
	    doinfo = "poll";
		idstr = "pid";
	}
	String href = "";
	TableUtil tu = new TableUtil("sns");
	String sql = "select * from "+sns_tablename+" where "+idstr+" in ("+SourceItemID+")";
	ResultSet rs = tu.executeQuery(sql);
	while(rs.next()){
		int id = 0; 
		int uid = 0;
		String title = "";
		String filepath = "";
		if(sns_tablename.equals("uchome_thread")){
			id = rs.getInt("tid");
			uid = rs.getInt("uid");
			title = rs.getString("subject");
			href = "http://sns.tidedemo.com/space.php?do=thread&id="+id;
		}else if(sns_tablename.equals("uchome_blog")){
			id = rs.getInt("blogid");
			uid = rs.getInt("uid");
			title = rs.getString("subject");
			href = "http://sns.tidedemo.com/space.php?uid="+uid+"&do=blog&id="+id;
		}else if(sns_tablename.equals("uchome_pic")){
			id = rs.getInt("picid");
			uid = rs.getInt("uid");
			title = rs.getString("filename");
            filepath = rs.getString("filepath");
			href ="http://sns.tidedemo.com/attachment/"+filepath;
		}else if(sns_tablename.equals("uchome_event")){
			id = rs.getInt("eventid");
			uid = rs.getInt("uid");
			title = rs.getString("title");
			href = "http://sns.tidedemo.com/space.php?do=event&id=" + id;
		}else{
		    id = rs.getInt("pid");
			uid = rs.getInt("uid");
			title = rs.getString("subject");
			href = "http://sns.tidedemo.com/space.php?uid="+uid+"&do=poll&pid="+id;
		}
		//String photo = "/sns/attachment/"+rs.getString("filepath");
		//推荐到指定频道中
		HashMap map = new HashMap();
		map.put("Title",title);
		map.put("user",uid+"");
		map.put("Href",href);
		map.put("Status","1");
		map.put("tidecms_addGlobal","1");
		map.put("User",userid+"");
		ItemUtil util = new ItemUtil();
		util.addItem(ChannelID, map);
	}
	tu.closeRs(rs);

	/*int GlobalID						= 0;
	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}
	Source.RecommendToChannel(SourceChannelID,SourceItemID,ChannelID,userinfo_session.getId());*/
%>
推荐成功
<script>
setTimeout("top.TideDialogClose('')",2000);
</script>
