<%@ page import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.system.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
if(!userinfo_session.isAdministrator())
{out.close();return;}

int id = getIntParameter(request,"id");
int type = getIntParameter(request,"type");
String Action = getParameter(request,"Action");
String jobname = getParameter(request,"jobname");
int SiteId=Util.getIntParameter(request,"SiteId");
int actionUser = userinfo_session.getId();
//PublishScheme publishscheme = new PublishScheme(id);
QuartzJob quartzPublish = new QuartzJob();
QuartzUtil QuartzUtil = new tidemedia.cms.system.QuartzUtil();
if(Action.equals("Check")){
	boolean flag = new tidemedia.cms.system.QuartzUtil().Check(jobname);
	//flag=true时可以使用
	if(flag){
		out.print("1");
	}else{
		out.print("0");
	}

}else{

	if(Action.equals("Enable"))
	{
		QuartzUtil.setActionUser(actionUser);
		QuartzUtil.Enable(id);
	}

	if(Action.equals("Disable"))
	{
		QuartzUtil.setActionUser(actionUser);
		QuartzUtil.Disable(id);
	}
	if(Action.equals("Del"))
	{
		quartzPublish.setActionUser(actionUser);
		quartzPublish.Delete(id);
	}

	//  CmsCache.getSite(publishscheme.getSite()).clearPublishSchemes();
	response.sendRedirect("content_quartz2018.jsp");
}
%>
