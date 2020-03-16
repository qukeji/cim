<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		GlobalID	=	Util.getIntParameter(request,"GlobalID");
if(GlobalID!=0)
{
	new ChinaCache().RefreshItem(GlobalID);
}
%>
