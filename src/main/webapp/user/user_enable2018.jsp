<%@ page import="tidemedia.cms.system.*,
                java.sql.*,
				java.net.URL,
				tidemedia.cms.user.*,
				tidemedia.cms.spider.*,
				tidemedia.cms.base.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.util.*"%>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
int id = getIntParameter(request,"id");
int flag = getIntParameter(request,"flag");
String field = getParameter(request,"field");
UserInfo userinfo = new UserInfo(id);

if(userinfo.getRole()==1)
{
	if(!(new UserPerm().canManageAdminUser(userinfo_session)))
	{response.sendRedirect("../noperm.jsp");return;}
}

if(id!=0)
{	
	if("Status".equals(field)){
		userinfo.enable(flag);
	}
	if("jurong".equals(field)){
		userinfo.enableJurong(flag);
	}
	JSONObject json = new JSONObject();
	json.put("code",200);
	json.put("msg","操作成功");
	out.println(json);
}
   


%>

