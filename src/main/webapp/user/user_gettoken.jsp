<%@ page import="java.sql.*,
				java.util.*,
				java.text.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
		java.util.Date now = new java.util.Date(); 
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy年MM月dd日HH时mm分ss秒");//可以方便地修改日期格式
		String nows = dateFormat.format( now ); 
		String content = StringUtils.getMD5(nows);
		out.println(content);

%>
