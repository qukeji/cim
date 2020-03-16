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
				java.text.*,
				java.text.DecimalFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int site = 0;
int userCount = 0;
int jobCount = 0;
int todayJobCount = 0;
int publishCount = 0;//发稿量
int todayCount;//今日新增
int space = 0;//租户总空间
Double useFileSpace = 0d;
Double video_size = 0d;
Double pic_size = 0d;
JSONObject json = new JSONObject();
int userid = userinfo_session.getId();
int companyid = userinfo_session.getCompany();
String cms_api = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
String cmsUrl = cms_api+"/tcenter/storage/size/ziyuan_tongji.jsp?userid="+userid;
String vmsUrl = cms_api+"/vms/storage/size/ziyuan_tongji.jsp?userid="+userid;
//查询图片视频使用总空间
String  vmsResult = Util.connectHttpUrl(vmsUrl);
String cmsResult = Util.connectHttpUrl(cmsUrl);
JSONObject cmsZiyuan = new JSONObject(cmsResult);
JSONObject vmsZiyuan = new JSONObject(vmsResult);
pic_size = cmsZiyuan.getDouble("pic_totle_size")+vmsZiyuan.getDouble("pic_totle_size");
video_size = vmsZiyuan.getDouble("video_totle_size");

TableUtil tu = new TableUtil("user");
//查询用户数量
String sql = " select count(*) count from userinfo where company="+companyid;
ResultSet rs = tu.executeQuery(sql);
if(rs.next()){
	userCount = rs.getInt("count");
}
sql = " select * from site where company="+companyid;
if(rs.next()){
	site = rs.getInt("id");
}
tu.closeRs(rs);
Calendar calendar = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
calendar.set(Calendar.HOUR_OF_DAY, 0);
calendar.set(Calendar.MINUTE, 0);
calendar.set(Calendar.SECOND, 0);
String nowDate = sdf.format(calendar.getTime());//当天0点时间
calendar.add(Calendar.DATE, +1);
String  date1 = sdf.format(calendar.getTime());//后一天0点时间
publishCount = ReportUtil2.getEsNum(site+"", 0, 0, false, 0, "", "");
todayCount = ReportUtil2.getEsNum(site+"",0,0,false,0,nowDate,date1);
//发稿量
JSONObject jo = ReportUtil2.mainData(userid);
publishCount = jo.getInt("PublishCount");
todayCount = jo.getInt("TodayCount");
//租户已开通产品
JSONArray yyzc = new JSONArray();
JSONArray yyfb = new JSONArray();
JSONArray zyhj = new JSONArray();
JSONArray scgj = new JSONArray();
Company company = new Company(companyid);
useFileSpace = Double.parseDouble((company.getUseFileSpace()+""))/1024/1024;//租户使用文件大小
space = company.getSpace();
String company_products = company.getProducts();
String products[] = company_products.split(",");
for(int i=0;i<products.length;i++){
	JSONObject json1 = new JSONObject();
	if("".equals(products[i])){
		continue;
	}
	int productId = Integer.parseInt(products[i]);
	Product product = new Product(productId);
	if("tcenter".equals(product.getCode())||"operate".equals(product.getCode())||"company".equals(product.getCode())){
		continue;
	}
	String proName = product.getName();
	String logo = product.getLogo();
	int groupId = product.getGroupId();
	String url = product.getUrl();
	json1.put("productId", productId);
	json1.put("proName", proName);
	json1.put("logo", logo);
	json1.put("groupId", groupId);
	json1.put("url", url);
	if(groupId==1){
        yyzc.put(json1);
    }else if(groupId==2){
        yyfb.put(json1);
    }else if(groupId==3){
        zyhj.put(json1);
    }else if(groupId==4){
        scgj.put(json1);
    }
}
//租户工单统计
	Channel channel = ChannelUtil.getApplicationChannel("workorder");
	Channel replyChannel = CmsCache.getChannel("work_order_reply");
	Channel channel_ = ChannelUtil.getCompanyChannelByShare(channel, companyid);
	TableUtil tu1 = new TableUtil();
	sql = " select count(*) count from "+channel.getTableName()+" where active=1 and Category="+channel_.getId();
	ResultSet rs1 = tu1.executeQuery(sql);
	if(rs1.next()){//总工单
		jobCount = rs1.getInt("count");
	}
	sql = " select count(*) count from "+channel.getTableName()+" where active=1 and Category="+channel_.getId()+" and date_format(from_unixtime(createdate),'%Y-%m-%d') = date_format(now(),'%Y-%m-%d') ";
	rs1 = tu1.executeQuery(sql);
	if(rs1.next()){//今日处理
		todayJobCount = rs1.getInt("count");
	}
	tu1.closeRs(rs1);
json.put("pic_size",String.format("%.1f",pic_size) );//图片空间
json.put("video_size",String.format("%.1f",video_size)  );//视频空间
json.put("useFileSpace",String.format("%.1f",useFileSpace) );//文件空间
json.put("space", space);//总空间
json.put("publishCount", publishCount);//发稿量
json.put("todayCount", todayCount);//今日发稿
json.put("notSolveCount", 0);//待审
json.put("jobCount", jobCount);//工单统计
json.put("todayJobCount", todayJobCount);//今日工单统计
json.put("userCount", userCount);//用户统计
json.put("yyzc", yyzc);
json.put("yyfb", yyfb);
json.put("zyhj", zyhj);
json.put("scgj", scgj);
json.put("useTotalSize",String.format("%.1f",useFileSpace+video_size+pic_size) );
out.println(json.toString());
%>