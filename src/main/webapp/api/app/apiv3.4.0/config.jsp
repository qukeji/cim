<%@ page contentType="text/html;charset=utf-8" %>
<%@page errorPage="/cms_error.jsp"%><%
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);

request.setCharacterEncoding("utf-8");

tidemedia.app.system.appUserInfo  appUserInfo_session = new tidemedia.app.system.appUserInfo();
int userid=0;
System.out.println("登录session："+session.getAttribute("appUserInfo"));
if(session.getAttribute("appUserInfo")!=null)
{
	appUserInfo_session = (tidemedia.app.system.appUserInfo)session.getAttribute("appUserInfo");
	userid=appUserInfo_session.getId();//session用户id
}
System.out.println("登录userid："+userid);
if(userid==0){
    JSONObject json_session=new JSONObject();
    json_session.put("status",300);
    json_session.put("message","对不起请登陆后再执行此操作。");
    out.println(json_session);
    return;
}

%>
<%!
public String getParameter(HttpServletRequest request,String str)
	{
	if(request.getParameter(str)==null)
		return "";
	else
		return request.getParameter(str);
	}

public int getIntParameter(HttpServletRequest request,String str)
	{
		String tempstr = getParameter(request,str);
		if(tempstr.equals(""))
			return 0;
		else
			{
				int i = 0;
				try{
					i = Integer.valueOf(tempstr).intValue();
				}catch(Exception e){}
				return i;
			}
	}

public String convertNull(String input)
	{
	if(input==null)
		return "";
	else
		return input;
//		return tidemedia.cms.util.Util.convertEncode(input);
	}
public void removeSession(HttpSession session,String[] items)
	{
		for(int i=0;i<items.length;i++)
		{
			session.removeAttribute(items[i]);
		}
	}
	
public boolean CheckExplorerSite(tidemedia.cms.user.UserInfo userinfo_session,int siteid)
{
	if(!(userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()))
	{ return false;}

	if(userinfo_session.isSiteAdministrator())
	{
		if(!userinfo_session.getSite().equals(siteid+""))
		{return false;}
	}
	return true;
}
%>
