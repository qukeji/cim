<%@ page
	import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../../config1.jsp"%>
<%


String channel_SerialNo="s66_h";//问政报表频道频道标识
Channel channel=CmsCache.getChannel(channel_SerialNo);
int channelid = channel.getId();
String sql = "";
int globalid =  getIntParameter(request,"globalid");

HashMap<String,String> map = new HashMap<>();
Document doc = CmsCache.getDocument(globalid);
String Title = doc.getTitle();
String ModifiedDate = doc.getModifiedDate();
String probstatus = doc.getValue("probstatus");
String Status2 = doc.getValue("Status2");
map.put("Title",Title);

map.put("probstatus",probstatus);
map.put("parentid",globalid+"");
map.put("Status2",Status2);
TableUtil tu = new TableUtil();

Map<String,Integer> map1 = new HashMap<String,Integer>();
map1.put("0",0);
map1.put("1",0);
map1.put("2",0);
sql = "select Status3,count(*) total from " +channel.getTableName()+" where Active=1  and parentid="+globalid+ " group by Status3";
ResultSet Rs = tu.executeQuery(sql);
while(Rs.next()){
    map1.put(Rs.getString("Status3"),Rs.getInt("total"));
}
tu.closeRs(Rs);
int category = doc.getCategoryID();
if("7".equals(probstatus)&&map1.get("2")==0){
	map.put("Status3","2");
	map.put("ModifiedDate",ModifiedDate);
	ItemUtil.addItemGetGlobalID(channelid, map);
}
if(category!=0&&map1.get("1")==0){
	map.put("Status3","1");
	map.put("ModifiedDate",ModifiedDate);
	ItemUtil.addItemGetGlobalID(channelid, map);
}
if(map1.get("0")==0){
    map.put("Status3","0");
    map.put("ModifiedDate",ModifiedDate);
	ItemUtil.addItemGetGlobalID(channelid, map);
}






%>

