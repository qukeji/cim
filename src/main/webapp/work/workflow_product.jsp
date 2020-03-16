 <%@page import="java.util.Date"%>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				tidemedia.cms.util.*,
				java.sql.SQLException,
				java.sql.Timestamp,
				java.text.ParseException,
				java.text.SimpleDateFormat,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%

	JSONObject oo = new JSONObject();
	String Serial_No_video = "video";
	String Serial_No_video_url = "video_url";
	Channel video_channel = CmsCache.getChannel(Serial_No_video);//音视频媒资频道
	Channel video_url_channel = CmsCache.getChannel(Serial_No_video_url);//视频地址频道
	Channel pgc_doc_channel = ChannelUtil.getApplicationChannel("pgc_doc");//图文频道
	Channel pgc_live_channel = ChannelUtil.getApplicationChannel("pgc_live");//直播频道
	Channel pgc_video_channel = ChannelUtil.getApplicationChannel("pgc_video");//pgc视频频道
	UserInfo user = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
	if(user.getCompany()!=0){
		video_channel = CmsCache.getChannel(new Tree().getChannelID(video_channel.getId(),user));
		pgc_doc_channel = CmsCache.getChannel(new Tree().getChannelID(pgc_doc_channel.getId(),user));
		pgc_live_channel = CmsCache.getChannel(new Tree().getChannelID(pgc_live_channel.getId(),user));
	}

	ResultSet rs = null;
	TableUtil tu = new TableUtil();
	String sql = "";
	JSONArray jsonArray = new JSONArray(); 
		
	//视频频道数据查询
	sql = 	"select * from " + video_channel.getTableName() + " where Active = 1 and channelcode like '" + pgc_video_channel.getChannelCode()+"%'";
	if(user.getCompany()!=0){
		sql += " and Category = "+video_channel.getId();
	}
	System.out.println("sql1==="+sql);
	rs = tu.executeQuery(sql);
	while(rs.next()){
		JSONObject o = new JSONObject();
		o.put("Title",tu.convertNull(rs.getString("Title")));
		o.put("CreateDate",new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format( new Date(Long.parseLong(tu.convertNull(rs.getString("CreateDate"))+"000"))) );//发布日期
		o.put("User",getName(rs.getInt("User")));
		//o.put("type",0);//视频频道
		sql = "select Url from " + video_url_channel.getTableName() + " where Parent = " + rs.getInt("GlobalID") + " and Active=1";
		rs = tu.executeQuery(sql);
		String video_source = "";
		while(rs.next()){
			video_source = rs.getString("Url");
		}
		o.put("video_source",video_source);//视频地址信息	
		o.put("type",2);
		o.put("avatar","");//用户头像
		jsonArray.put(o);
	}
	
	//图文频道数据查询
	sql = 	"select * from " + pgc_doc_channel.getTableName() + " where Active = 1 " ;
	if(user.getCompany()!=0){
		sql += " and Category = "+pgc_doc_channel.getId();
	}
	System.out.println("sql2==="+sql);
	rs = tu.executeQuery(sql);
	while(rs.next()){
		JSONObject o = new JSONObject();
		JSONArray photojsonArray = new JSONArray();
		o.put("Title",tu.convertNull(rs.getString("Title")));
		o.put("CreateDate",new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format( new Date(Long.parseLong(tu.convertNull(rs.getString("CreateDate"))+"000"))) );//发布日期
		o.put("url",tu.convertNull(rs.getString("url")));
		String photo = tu.convertNull(rs.getString("Photo"));
		if(!"".equals(photo)){
			photojsonArray.put(photo);
		}
		o.put("Photo",photojsonArray);
		o.put("User",getName(rs.getInt("User")));
		o.put("type",1);//图文频道
		o.put("avatar","");//用户头像
		jsonArray.put(o);
	}
	
	//直播频道数据查询
	sql = 	"select * from " + pgc_live_channel.getTableName() + " where Active = 1 " ;
	if(user.getCompany()!=0){
		sql += " and Category = "+pgc_live_channel.getId();
	}
	System.out.println("sql3==="+sql);
	rs = tu.executeQuery(sql);
	while(rs.next()){
		JSONObject o = new JSONObject();
		JSONArray photojsonArray = new JSONArray();
		o.put("Title",tu.convertNull(rs.getString("Title")));
		o.put("CreateDate",new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format( new Date(Long.parseLong(tu.convertNull(rs.getString("CreateDate"))+"000"))) );//发布日期
		o.put("pc_url",tu.convertNull(rs.getString("pc_url")));
		String photo = tu.convertNull(rs.getString("Photo"));
		if(!"".equals(photo)){
			photojsonArray.put(photo);
		}
		o.put("Photo",photojsonArray);
		o.put("User",getName(rs.getInt("User")));
		o.put("type",2);//直播频道
		o.put("avatar","");//用户头像
		jsonArray.put(o);
	}
	
	tu.closeRs(rs);
	oo.put("result",jsonArray);
	out.println(oo.toString());
%>
<%!
	public String getUserAvatar(int userid) throws Exception{
		TableUtil tu1 = new TableUtil();
		String Sql = "select avatar from " + CmsCache.getChannel("register").getTableName()+ " where Active=1 and id="+userid;
		ResultSet Rs = tu1.executeQuery(Sql);
		String avatar = "";
		if(Rs.next()){
			avatar =  Rs.getString("avatar");
		}
		tu1.closeRs(Rs);
		return avatar;
	}
	public String getName(int userid) throws Exception{
		String username = "";
		if(userid!=0){
			UserInfo user = new UserInfo(userid);
			username = user.getName();
		}
		return username;
	}


%>
