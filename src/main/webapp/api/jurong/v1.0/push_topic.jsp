 <%@ page import="tidemedia.cms.system.*,
                  java.util.*,
				  tidemedia.cms.util.*,
				  tidemedia.cms.user.*,
				  java.sql.*,
				  tidemedia.cms.base.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@page import="org.json.JSONObject"%>
<%@ include file="../../../config1.jsp"%>
<%!
//获取所有拥有审核权限的用户
public String getUserPhones(int channelid) throws Exception{
	String phones = "";

	String sql="select * from userinfo";
	TableUtil tu = new TableUtil("user");
	ResultSet Rs = tu.executeQuery(sql);
	while(Rs.next()){
		String phone = tu.convertNull(Rs.getString("Tel"));
		if(phone.equals("")){
			continue;
		}
		int userId = Rs.getInt("id");
		UserInfo info = new UserInfo(userId);
		boolean flag = UserInfoUtil.hasChannelRight(channelid, 3, info.getChannelPermArray());
		if(!flag){
			continue;
		}

		if(!phones.equals("")){
			phones += "," ;
		}
		phones += phone ;
	}

	tu.closeRs(Rs);
	
	return phones ;
} 
//获取创建人手机号
public String getUserPhone(int userid) throws Exception{
	String phone = "";

	String sql="select * from userinfo where id="+userid;
	TableUtil tu = new TableUtil("user");
	ResultSet Rs = tu.executeQuery(sql);
	if(Rs.next()){
		phone = tu.convertNull(Rs.getString("Tel"));
	}
	tu.closeRs(Rs);
	
	return phone ;
} 
%>
<%
/**
* 用途：选题推送接口
*/

try {

	TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
	int xiaomi_push = jurong.getInt("xiaomi_push");


	int type = getIntParameter(request,"type");//1.创建 2.通过 3.毙稿 4.完成
	int gid = getIntParameter(request,"id");
	Document doc = CmsCache.getDocument(gid);
	int status = doc.getIntValue("task_status");
	String status_ = "";
	if(status==1){
		status_ = "审核通过";
	}else if(status==2){
		status_ = "毙稿";
	}else if(status==3){
		status_ = "已完成";
	}	
	
	String phones = getUserPhones(doc.getChannelID());
	String title = doc.getTitle()+"消息推送";
	String summary = "您发布的选题"+doc.getTitle()+status_;
	if(type==1){
		title = "发布任务消息推送";
		summary = "您有一条新的任务";
	}else if(type==2){
		phones = getUserPhone(doc.getUser());
	}else if(type==3){
		phones = getUserPhone(doc.getUser());
	}

	//推送记录
	HashMap map = new HashMap();
	map.put("Title",doc.getTitle());
	map.put("parent",gid+"");
	map.put("phones",phones);
	map.put("Summary",summary);
	if(phones.equals("")){
		map.put("state","0");
		ItemUtil.addItemGetGlobalID(xiaomi_push, map);	
		return ;
	}
	//System.out.println(phones);

	JSONObject  extra=new JSONObject();//extra  JSON集合
	extra.put("title",doc.getTitle());
	extra.put("contentID",gid);

	//获取第三方平台密钥
	TideJson json = CmsCache.getParameter("xiaomi_push").getJson();//小米推送信息

	if(json==null){
		map.put("Summary","小米推送信息未配置，请联系系统管理员.");
		map.put("state","0");
		ItemUtil.addItemGetGlobalID(xiaomi_push, map);	
		return ;
	}


	String package_name = json.getString("package_name");//"com.tidemedia.juxian";//Android客户端包名
	String bundleid = json.getString("bundleid");//"com.tidemedia.juxian";//IOS包名
	String android_secret_key = json.getString("android_secret_key");//"nn/3zwpRfOL0eiKaEaZdlQ==";//安卓-AppSecret
	String ios_secret_key = json.getString("ios_secret_key");//"2cTFn3tEU+Lj+KijWjRFEw==";//苹果-AppSecret	

	StringBuffer xml = new StringBuffer("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>");
	xml.append("<push>");
	xml.append("<platform>0</platform>");//推送平台 0所有
	xml.append("<object>1</object>");//0所有人,1别名,2序列号
	xml.append("<value>"+phones+"</value>");
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

	//推送记录
	map.put("state",obj.get("state"));
	map.put("xiaoxiID",obj.getString("Summary"));
	ItemUtil.addItemGetGlobalID(xiaomi_push, map);

} catch (Exception e) {
	e.printStackTrace();
}
%>
