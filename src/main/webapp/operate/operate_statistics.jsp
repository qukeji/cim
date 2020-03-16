<%@page import="java.io.File"%>
<%@page import="tidemedia.cms.user.UserInfo"%>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				tidemedia.cms.video.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*,
				java.text.DecimalFormat,
				java.util.*"%>
<%@ page import="tidemedia.cms.system.ChannelUtil" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int userCount = 0;
int companyCount = 0;
int productCount = 0;
int jobCount = 0;
int todayJobCount = 0;
Double useFileSpace = 0d;
Double video_size = 0d;
Double pic_size = 0d;
JSONObject json = new JSONObject();
int userid = userinfo_session.getId();
String cms_api = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
String cmsUrl = cms_api+"/tcenter/storage/size/ziyuan_tongji.jsp?userid="+userid;
String vmsUrl = cms_api+"/vms/storage/size/ziyuan_tongji.jsp?userid="+userid;
//查询图片视频使用总空间
String  vmsResult = Util.connectHttpUrl(vmsUrl);
String cmsResult = Util.connectHttpUrl(cmsUrl);
//System.out.println("vmsResult==="+vmsResult);
//System.out.println("cmsResult==="+cmsResult);
JSONObject cmsZiyuan = new JSONObject(cmsResult);
JSONObject vmsZiyuan = new JSONObject(vmsResult);
pic_size = cmsZiyuan.getDouble("pic_totle_size")+vmsZiyuan.getDouble("pic_totle_size");
video_size = vmsZiyuan.getDouble("video_totle_size");



TableUtil tu = new TableUtil("user");
//查询用户数量
String sql = " select count(*) count from userinfo where company!=0";
ResultSet rs = tu.executeQuery(sql);
if(rs.next()){
	userCount = rs.getInt("count");
}
//查询租户数量
sql = " select count(id) count,sum(useFileSpace) sumUseFileSpace  from company";
rs = tu.executeQuery(sql);
if(rs.next()){
	companyCount = rs.getInt("count");
	useFileSpace = rs.getDouble("sumUseFileSpace")/1024/1024;
	
}
//查询产品数量
sql = " select count(*) count from tide_products";
rs = tu.executeQuery(sql);
if(rs.next()){
	productCount = rs.getInt("count");
}
tu.closeRs(rs);
//租户工单统计
	Channel channel = ChannelUtil.getApplicationChannel("workorder");
	Channel replyChannel = CmsCache.getChannel("work_order_reply");
	TableUtil tu1 = new TableUtil();
	sql = " select count(*) count from "+channel.getTableName()+" where active=1";
	ResultSet rs1 = tu1.executeQuery(sql);
	if(rs1.next()){//总工单
		jobCount = rs1.getInt("count");
	}
	sql = " select count(*) count from "+replyChannel.getTableName()+" where active=1 and date_format(from_unixtime(createdate),'%Y-%m-%d') = date_format(now(),'%Y-%m-%d') ";
	rs1 = tu1.executeQuery(sql);
	if(rs1.next()){//今日处理
		todayJobCount = rs1.getInt("count");
	}
	tu1.closeRs(rs1);

json.put("pic_size", String.format("%.1f",pic_size));
json.put("video_size", String.format("%.1f",video_size));
json.put("useFileSpace", String.format("%.1f",useFileSpace));
json.put("jobCount", jobCount);
json.put("todayJobCount", todayJobCount);
json.put("userCount", userCount);
json.put("companyCount", companyCount);
json.put("productCount", productCount);
ReportUtil2.getSite(0,json);
out.println(json.toString());
%>
