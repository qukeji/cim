 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
                java.util.Calendar,
				tidemedia.cms.util.*,
				java.sql.SQLException,
				java.sql.Timestamp,
				java.text.ParseException,
				java.text.SimpleDateFormat,
				java.text.DecimalFormat,
				java.util.Date,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>



<%
    JSONObject o = new JSONObject();
	try{
	int returnType = getIntParameter(request,"returnType");
	TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
    int statisticsid = politics.getInt("statisticsid");//问政统计信息频道
    //Channel channel = CmsCache.getChannel(statisticsid);
    String type = "";
    String wheresql = "";
    if(returnType==1){
        type = " ,satisfy_num as num ";
        wheresql = " order by satisfy_num desc ";
    }else if(returnType==2){
        type = " ,finished_num  as num ";
        wheresql = " order by finished_num desc ";
    }else if(returnType==3){
        type = " ,reply_num  as num ";
        wheresql = " order by reply_num desc ";
    }
    String deptsql = "select Title "+ type +" from "+CmsCache.getChannel(statisticsid).getTableName() +" where active =1 " + wheresql +" limit 10";
    TableUtil depttu = new TableUtil();
    ResultSet deptRs = depttu.executeQuery(deptsql);
    JSONArray typeArr = new JSONArray();
    JSONArray typenameArr = new JSONArray();
    while(deptRs.next()) {
        float num = 0.0f;
        if(returnType==1||returnType==2||returnType==3){
            num =  deptRs.getFloat("num");
        }
        String channelname = deptRs.getString("Title");       
        
        typeArr.put(num*100+"");     
        typenameArr.put(channelname+"");

    }
    depttu.closeRs(deptRs);
    o.put("data",typeArr);
    o.put("labels",typenameArr);

	}catch(Exception e){
	    o.put("status",0);
	    o.put("message","出错了");
        e.printStackTrace();
	}
	 
	out.println(o.toString());
%>



