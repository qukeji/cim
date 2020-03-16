<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*,java.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<% 
	int ChannelID = getIntParameter(request,"ChannelID");
	int RelationID = getIntParameter(request,"RelationID");	
	int Type = getIntParameter(request,"Type");
	JSONObject json = new JSONObject();
	TableUtil tu = new TableUtil();
	String sql = "select * from channel_recommend where ChannelID=" + ChannelID + " and RelationID=" + RelationID+ " and Type=" + Type;
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next()){
		String Relationship = rs.getString("Relationship");
		int RelationchannelType = rs.getInt("RelationchannelType");
		String defaultRelationship="Title=Title\n" + 
				"PublishDate=PublishDate\n" + 
				"Summary=Summary\n" + 
				"Photo=Photo\n" + 
				"Content=Content\n" + 
				"DocForm=DocForm\n" + 
				"IsPhotoNews=IsPhotoNews";
		if(defaultRelationship.equals(Relationship)){
			Relationship ="";
		}
		json.put("Relationship",Relationship);
		json.put("RelationchannelType",RelationchannelType);
	}else{//不存在 返回默认值
		json.put("Relationship","");
		json.put("RelationchannelType",0);
	}
	tu.closeRs(rs);
	out.println(json);return;
%>