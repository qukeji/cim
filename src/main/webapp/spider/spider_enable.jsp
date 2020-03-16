<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
 *	姓名		日期		备注
 *
 *	王海龙		2013/12/31	flag=1时开启调度，flag=2时关闭调度
 *
 */
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
int flag = getIntParameter(request,"flag");

if(id!=0)
{
	Spider s = new Spider(id);
	s.enable(flag);
	 if(flag == 2)
		 Spider.stopJob(id);
     if(flag == 1)
	  	 Spider.startJob(id,s.getPeriod());
}
%>