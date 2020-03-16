<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
int	commentid	=	getIntParameter(request,"id");

if(commentid!=0){
{
	try{
    TableUtil tu= new TableUtil();
    String sql = "update channel_tidehome_comment set Active=0 where  id= " + commentid;
    tu.executeUpdate(sql);
	out.println("{\"status\":1}");			
	}catch(Exception e){
		e.printStackTrace();
		out.println("{\"status\":2}");
	}			   
}else{
	out.println("{\"status\":2}");
}
%>
