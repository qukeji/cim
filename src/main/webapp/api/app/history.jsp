 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				redis.clients.jedis.*,
				java.sql.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
//阅读量增加接口
%>

<%
/*
*1、刷新一次加1 
*2、去重机制，结合redis，同一个人访问同一个文章，只能加1次。
*/
int type		= getIntParameter(request,"type");
//int userid		= getIntParameter(request,"userid");//当前登录用户id
int gid				= getIntParameter(request,"globalid");//文章编号
String table		= getParameter(request,"tablename");//表名
String sessionid	= getParameter(request,"sessionid");//登录标识
String deviceid		= getParameter(request,"deviceid");//设备标识

try {
	if(gid==0||table.equals("")||sessionid.equals("")){
		return ;
	}
	if(type==2){
		String key = gid+"_"+sessionid ;
		if(deviceid!=null&&!deviceid.equals("")){
			key = gid+"_"+deviceid ;
		}
System.out.println("key:"+key);
		RedisUtil ru = RedisUtil.getInstance();
		String value = ru.RedisGet(key);
		if(value!=null){//redis中有此记录,阅读量不增加
			return ;
		}
		ru.RedisSet(key, "1", 864000);	
	}

	String sql = "update "+table+" set pv=pv+1 where Active=1 and status=1 and globalid="+gid;
	TableUtil tu = new TableUtil();
	tu.executeUpdate(sql);
}catch (Exception e) {
	e.printStackTrace();
}
%>
