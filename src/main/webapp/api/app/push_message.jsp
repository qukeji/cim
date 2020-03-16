 <%@ page import="tidemedia.cms.system.*,
                  java.util.*,
				  tidemedia.cms.util.*,
				  tidemedia.cms.user.*,
				  java.sql.*,
				  tidemedia.cms.base.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@page import="org.json.JSONObject"%>
<%@ include file="../../config1.jsp"%>

<%
/**
* 用途：选题推送接口
*/

try {

	
	String userid		= getParameter(request,"userid");//消息接收人
	int siteid		= getIntParameter(request,"siteid");//客户端归属
	int type		= getIntParameter(request,"type");
	if(siteid==0) siteid=53 ;

	//消息通知内容
	String title = "消息通知";
	String summary = "";
	int target = 0;
	if(type==1){
		title = "粉丝通知";
		summary = "有人关注了您哦";
	}else if(type==2){
		title = "钱包通知";
		summary = "您有一条钱包动态";
	}else if(type==3){
		title = "点赞通知";
		summary = "有人点赞了您哦";
	}else if(type==4){
		title = "评论通知";
		summary = "您有一条新评论哦";
	}else if(type==5){
		title = getParameter(request,"title");
		summary = getParameter(request,"summary");
		target = getIntParameter(request,"target");
	}

	//信息推送记录
	int xiaomi_push = CmsCache.getChannel("s"+siteid+"_push").getId();
	HashMap map = new HashMap();
	map.put("Title",title);
	map.put("Summary",summary);
	if(target==-1){
		map.put("audience_type","0");
	}else{
		map.put("audience_type","1");
	}
	map.put("device_tag",userid);
	if("".equals(userid)||type==0){
		map.put("state","0");
		map.put("xiaoxiID","参数不全");
		ItemUtil.addItemGetGlobalID(xiaomi_push, map);	
		return ;
	}

	//获取第三方平台密钥
	String table = "channel_threadmanager";
	if(siteid!=53){
		table = "channel_s"+siteid+"_threadmanager";
	}
	String sql = "select packagename,bundleid,android_secrect_key,ios_secrect_key from "+table+" where Active=1 and siteflag="+siteid;
	TableUtil tu = new TableUtil();
	ResultSet rs = tu.executeQuery(sql);
	String package_name = "";
	String bundleid = "";
	String android_secret_key = "";
	String ios_secret_key = "";
	if(rs.next()){
		package_name = convertNull(rs.getString("packagename"));
		bundleid = convertNull(rs.getString("bundleid"));
		android_secret_key = convertNull(rs.getString("android_secrect_key"));
		ios_secret_key = convertNull(rs.getString("ios_secrect_key"));
	}
	tu.closeRs(rs);

	if(package_name.equals("")||bundleid.equals("")||android_secret_key.equals("")||ios_secret_key.equals("")){
		map.put("xiaoxiID","小米推送信息未配置，请联系系统管理员.");
		map.put("state","0");
		ItemUtil.addItemGetGlobalID(xiaomi_push, map);	
		return ;
	}

	JSONObject extra=new JSONObject();//extra  JSON集合
	extra.put("title",title);
	extra.put("push_type",1);
	extra.put("type",type);
		
	//小米推送信息
	StringBuffer xml = new StringBuffer("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>");
	xml.append("<push>");
	xml.append("<platform>0</platform>");//推送平台 0所有
	if(target==-1){
		xml.append("<object>0</object>");//0所有人,1别名,2序列号
	}else{
		xml.append("<object>1</object>");//0所有人,1别名,2序列号
	}
	xml.append("<value>"+userid+"</value>");
	xml.append("<title>"+title+"</title>");
	xml.append("<summary>"+summary+"</summary>");
	xml.append("<desc>"+summary+"</desc>");
	xml.append("<extra>"+extra+"</extra>");
	xml.append("<time>0</time>");
	xml.append("<badge>0</badge>");
	xml.append("<beat>0</beat>");//0是正式环境，1是测试环境
	xml.append("<package_name>"+package_name+"</package_name>");// android是包名
	xml.append("<bundleid>"+bundleid+"</bundleid>");// ios为bundelid
	xml.append("<android_secret_key>"+android_secret_key+"</android_secret_key>");
	xml.append("<ios_secret_key>"+ios_secret_key+"</ios_secret_key>");
	xml.append("<project>"+CmsCache.getCompany()+"</project>");
	xml.append("</push>");

	String result = Util.postHttpUrl("http://cloud.tidedemo.com:888/cms_cloud/push/mi_push_log.jsp",xml.toString());
	JSONObject obj = new JSONObject(result);
	System.out.println("result=============="+result);
	//推送记录
	map.put("state",obj.get("state"));
	map.put("xiaoxiID",obj.getString("Summary"));
	ItemUtil.addItemGetGlobalID(xiaomi_push, map);

} catch (Exception e) {
	e.printStackTrace();
}
%>
