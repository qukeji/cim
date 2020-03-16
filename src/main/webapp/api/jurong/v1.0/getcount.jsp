 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config1.jsp"%>
<%@ include file="include/config.jsp"%>
<%
//线索汇聚接口
%>
<%!
 public HashMap<String, Object> getItems(int userId){
	HashMap<String, Object> map = new HashMap<String, Object>() ;

	
	return map ;
}
public int getNumber(String sql) throws MessageException, SQLException
{
	int num = 0;
	
	TableUtil tu = new TableUtil();
	ResultSet rs = tu.executeQuery(sql);
	if (rs.next())
		num = rs.getInt(1);
	tu.closeRs(rs);
	
	return num;
}
%>
<%
tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();
if(session.getAttribute("CMSUserInfo")!=null)
{
	userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
}
int userId = userinfo_session.getId();//当前登录用户id
System.out.println("userId:"+userId);
JSONObject json = new JSONObject();

try{		
	TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
	int channel_xiansuo = jurong.getInt("collect");
	int channelId_hot = jurong.getInt("hotword");

	Channel channel_review = ChannelUtil.getApplicationChannel("task_doc");
	int channelid = channel_review.getId() ;//选题频道编号
	
	Channel channel = CmsCache.getChannel(channel_xiansuo);
	Channel channel_hot = CmsCache.getChannel(channelId_hot);

	TableUtil tu = new TableUtil();
	String countSql = "";

	//查询线索汇聚总数量
	countSql = "select count(*) from "+channel.getTableName()+" where Active=1";
	int count = getNumber(countSql);
	//System.out.println("线索："+countSql);

	//查询热点跟踪总数量
	countSql = "select count(*) from "+channel_hot.getTableName()+" where Active=1";
	int count_hot = getNumber(countSql);

	//查询审核数量
	//稿件待审核数量
	int count_review = 0 ;
	String ChannelIds = getUserChannelString(userId, channelid, 1);//用户频道权限
	if(!ChannelIds.equals("")){//有权限
		countSql = "select count(*) from item_snap where Active=1 and ChannelID in("+ChannelIds+") and Status=0";
		count_review = getNumber(countSql);
	}
	//选题待审核数量
	ChannelIds = getUserChannelString(userId, channelid, 2);//用户频道权限
	if(!ChannelIds.equals("")){//有权限
		countSql = "select count(*) from "+channel_review.getTableName()+" where Active=1 and task_status=0 and Category in ("+ChannelIds+")";
		count_review += getNumber(countSql);
	}
	
	//查询选题数量
	int count_topic = 0 ;
	ChannelIds = getUserChannelString(userId, channelid, 2);//用户频道权限
	if(!ChannelIds.equals("")){//有权限
		countSql = "select count(*) from "+channel_review.getTableName()+" where Active=1 and Category in ("+ChannelIds+")";
		System.out.println("countSql:"+countSql);
		count_topic += getNumber(countSql);
	}

	json.put("count",count);
	json.put("hotcount",count_hot);
	json.put("reviewcount",count_review);
	json.put("topiccount",count_topic);
	json.put("status",200);
	json.put("message","成功");
	
}catch(Exception e){
	json.put("status",500);
	json.put("message","程序异常");
	e.printStackTrace();
} 

out.println(json);
%>
