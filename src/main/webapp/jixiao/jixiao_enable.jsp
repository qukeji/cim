<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.base.*,
                tidemedia.cms.util.*,
                tidemedia.cms.user.*,
                java.util.*,
                java.sql.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="static tidemedia.cms.util.Util2.getIntParameter" %>
<%@ page import="static tidemedia.cms.util.Util2.getParameter" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    int id = getIntParameter(request,"id");
    int flag = getIntParameter(request,"flag");//需要设置的开关值 0：关 1：开
    String field = getParameter(request,"field");//字段
	if(id!=0||!field.equals("")){
		String sql = "update  channel_jixiao_scheme set "+field+"="+flag+" where id ="+id;
		TableUtil tu = new TableUtil();
		tu.executeUpdate(sql);
	}
    
%>
