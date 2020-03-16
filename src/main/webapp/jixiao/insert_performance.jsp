<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				org.apache.commons.lang.StringEscapeUtils,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    TableUtil tu = new TableUtil();
    for (int i = 0;i<10;i++){
        String sql = "insert into channel_user_performance (title,report_id,user_id,web_score,web_pv_score,app_score,app_pv_score,weixin_score,weixin_pv_score,subject_score,video_score,score) values" +
                " ('王力',1,21,10.1,10.2,10.3,10.4,10.5,10.6,10.7,10.8,83.6)";
        tu.executeUpdate(sql);
    }

%>
