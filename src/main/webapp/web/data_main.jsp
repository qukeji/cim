<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//弃用
%>
<%!
//获取资源数
public int getNum(String sql){

	int num = 0 ;
	try{
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(sql);
		if(Rs.next()) {
			num = Rs.getInt("num");
		}
		tu.closeRs(Rs);
	}catch(Exception e) {
		e.printStackTrace();			
	}
	return num ;

} 

%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);

int Flag = getIntParameter(request,"Flag");
String time = CmsCache.getExpiresDateStr();  
long current = System.currentTimeMillis();
time  = time.replaceAll("-","/");
Date date = new Date(time);
long ExpiresDate = date.getTime();
long diff = (ExpiresDate - current)/1000; //秒
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");
if(CmsCache.hasValidLicense()) diff = 1000000;

//获取租户id
int companyid = userinfo_session.getCompany();

//查询站点总数
int sitenum = 0 ;
String siteids = "";
String sql = "select * from channel where Parent=-1 and Type=5";
TableUtil tu = new TableUtil();
ResultSet Rs = tu.executeQuery(sql);
while(Rs.next()) {
	int siteid = Rs.getInt("site");
	int channelID = Rs.getInt("id");
	String application_ = convertNull(Rs.getString("application"));
	Site site = CmsCache.getSite(siteid);

	//当前登录用户绑定了租户,站点不是公共站点,用户无站点权限，
	if(companyid!=0&&(!application_.equals("publishsite"))&&(companyid!=site.getCompany())){
		continue ;
	}
	if(!siteids.equals("")){
		siteids += ",";
	}
	siteids += Rs.getInt("Site");
	sitenum++;
}
tu.closeRs(Rs);
//查询频道总数
sql = "select count(*) as num from channel";
if(companyid!=0){
	sql += " where Site in ("+siteids+")";
}
int channelnum = getNum(sql);


//查询资源总数
int count = tidemedia.cms.util.ESUtil.searchESDocument(siteids,0,false,0,"","");
int countAudited = tidemedia.cms.util.ESUtil.searchESDocument(siteids,0,false,2,"","");
int countUnaudited = tidemedia.cms.util.ESUtil.searchESDocument(siteids,0,false,1,"","");


//今日新增
Calendar calendar = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
calendar.set(Calendar.HOUR_OF_DAY, 0);
calendar.set(Calendar.MINUTE, 0);
calendar.set(Calendar.SECOND, 0);
String nowDate = sdf.format(calendar.getTime());
calendar.add(Calendar.DATE, +1);
String  date1 = sdf.format(calendar.getTime());
int count1 = tidemedia.cms.util.ESUtil.searchESDocument(siteids,0,false,0,nowDate,date1);//getNum(sql);//

//7天数据
calendar.add(Calendar.DATE, -6);
String  date2= sdf.format(calendar.getTime());
int count2 = tidemedia.cms.util.ESUtil.searchESDocument(siteids,0,false,0,date2,date1);

//用户发稿量
sql = "select count(*) as num from item_snap where Active=1 and Status=1 and User="+userinfo_session.getId();
int count3 = getNum(sql);

//近24小时发稿量
int time1 = (int)(System.currentTimeMillis()/1000);
sql = "select count(*) as num from item_snap where Active=1 and Status=1 and User="+userinfo_session.getId()+" and PublishDate>="+(time1-86400)+" and PublishDate<"+time1;
int count4 = getNum(sql);

   JSONArray array = new JSONArray();
   JSONObject json = new JSONObject(); 
    json.put("count",count);
    json.put("count1",count1);
    json.put("count2",count2);
    json.put("count3",count3);
    json.put("count4",count4);
    out.println(json.toString());
%>



