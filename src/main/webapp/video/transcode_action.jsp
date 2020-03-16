<%@ page import="tidemedia.cms.video.*,tidemedia.cms.base.*,java.sql.*,tidemedia.cms.util.*,java.util.*,tidemedia.cms.system.*,org.json.JSONArray,org.json.JSONObject"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int id		= getIntParameter(request,"id");
int action	= getIntParameter(request,"action");

if(action==1)
{
	//ÖØÐÂ×ªÂë
	TableUtil tu = new TableUtil();
	tu.executeUpdate("update channel_transcode set Status2=0,PublishStatus=0,progress=0,duration=0 where id="+id);
	TranscodeManager.getInstance().Start();
}
%>