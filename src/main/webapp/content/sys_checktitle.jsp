<%@ page import="java.sql.*,
				java.util.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<% 
  
 String Title= getParameter(request,"Title");
 int ItemID= getIntParameter(request,"ItemID");
 int ChannelId	= getIntParameter(request,"ChannelID");
	 
 int title_repeat_config=CmsCache.getParameter("sys_checktitle").getIntValue();
 if(title_repeat_config==1||title_repeat_config==2){//判断标题是否重复
     boolean chongfu=false;
	 
	 TableUtil tu=new TableUtil();
	 Channel channel=CmsCache.getChannel(ChannelId);
	 String sql="select id from "+channel.getTableName()+" where Category="+ChannelId+" and Title='"  +tu.SQLQuote(Title)+ "' and Active=1 and id!= "+ItemID;
 	 ResultSet rs=tu.executeQuery(sql);
 	 if(rs.next()){
 		 chongfu=true;
 	 }
 	 tu.closeRs(rs);
 	 
 	 if(chongfu){//重复
 		 out.println("{\"type\":"+title_repeat_config+",\"message\":\"标题已经存在\"}");
 	 }else{//不重复
 		 out.println("{\"type\":0}");
 	 }
 }else{//关闭提示
	 out.println("{\"type\":0}");
 }
%>