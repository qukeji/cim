<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    //{"x":["2013-03-23","2013-03-24","2013-03-26","2013-03-27","2013-03-28","2013-03-29"],
	// "y":["8","4","5","2","2","3"]}
    String gid = getParameter(request,"gid");
	int i = Util.parseInt( gid )+10000; 
	gid = i + "";
    //gson格式：
	//{"x":["2013-03-23","2013-03-24","2013-03-26","2013-03-27","2013-03-28"],"y":["8","4","5","2","2"]}
    String x = "\"x\":[";
	String y = "\"y\":[";
//  HashMap gmap = new HashMap();	
	String sql="select date,num from tidecms_visit_date where gid="+gid+"";
	TableUtil tu = new TableUtil();
	ResultSet rs = tu.executeQuery(sql);
	while(rs.next()){
		x += "\"" + rs.getString("date") + "\"";
        y += "\"" + rs.getInt("num") + "\"";
		if(!rs.isLast())
		{
			x += ",";
			y += ",";
		}
//	gmap.put(rs.getString("date"),rs.getInt("num"));
	}
	tu.closeRs(rs);
	x+="]";
	y+="]";
	String json = "{" + x + ","+ y + "}";
	out.println(json);
    String value1 = null;
    try
    {
     //将字符串转换成jsonObject对象
     JSONObject myJsonObject = new JSONObject(json);
//	 	out.print(myJsonObject);
    }
    catch (JSONException e)
    {
    }

%>