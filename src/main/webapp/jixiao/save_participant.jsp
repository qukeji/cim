<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				org.apache.commons.lang.StringEscapeUtils,
				java.sql.*"%>
<%@ page import="javax.sound.sampled.Line" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    int jixiao_id = getIntParameter(request,"itemId");//绩效方案ID
    System.out.println("jixiao_id="+jixiao_id);
    String users_id	= getParameter(request,"users_id");//参与人员ID
    System.out.println("users_id="+users_id);
    String[] userIdArray = users_id.split(",");
    String insertSql = "insert into channel_jixiao_participant (jixiao_id,user_id,title) values ("+jixiao_id+",";
    TableUtil tu = new TableUtil();
    for (String userIdString : userIdArray){
        if(userIdString.length()>0){
            int userId = Integer.parseInt(userIdString);
            String name = CmsCache.getUser(userId).getName();
            String sql = insertSql+userId+",'"+name+"')";
            System.out.println("sql="+sql);
            tu.executeUpdate(sql);
        }
    }

%>
