<%@page errorPage="/cms_error.jsp"%>
<%
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);

request.setCharacterEncoding("utf-8");
int max_perpage 	= 20;		//MAX DISPLAY RECORDS IN ONE PAGE//

tidemedia.cms.system.Site defaultSite = tidemedia.cms.system.CmsCache.getDefaultSite();

tidemedia.cms.base.Config defaultConfig=tidemedia.cms.system.CmsCache.getConfig();
//check user validate
tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();

String ico = "favicon.ico";
String title_ = tidemedia.cms.system.CmsCache.getCompany();
String title_main = "";
String company_info = "";
try{ 
	tidemedia.cms.util.TideJson system_ico = tidemedia.cms.system.CmsCache.getParameter("system_ico").getJson();
	if(system_ico!=null){
		if(!system_ico.getString("ico").equals("")){
			ico = system_ico.getString("ico");
		}
		if(!system_ico.getString("title").equals("")){
			title_ = system_ico.getString("title");
		}
		if(!system_ico.getString("title_main").equals("")){
			title_main = system_ico.getString("title_main");
		}
		if(!system_ico.getString("company_info").equals("")){
			company_info = system_ico.getString("company_info");
		}
	}
}catch(Exception e){
	e.printStackTrace();
} 



if(session.getAttribute("CMSUserInfo")!=null)
{
	userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
	String path = request.getServletPath();
	if(path.startsWith("/explorer/"))
	{
		//文件管理
		if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageFile")){}
		else{ response.sendRedirect("../noperm.jsp");return;}
	}

	if(path.startsWith("/channel/"))
	{
		//结构管理
		if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
		else{ response.sendRedirect("../noperm.jsp");return;}

		if(userinfo_session.isSiteAdministrator())
		{	
			int channelid_ = getIntParameter(request,"ChannelID");
			tidemedia.cms.system.Channel channel_ = tidemedia.cms.system.CmsCache.getChannel(channelid_);
			System.out.println("channelid_"+channelid_+",site:"+userinfo_session.getSite()+","+channel_.getSite().getId());
			if(!userinfo_session.getSite().equals(channel_.getSite().getId()+""))
			{response.sendRedirect("../noperm.jsp");return;}
		}
	}

	if(path.startsWith("/system/"))
	{
		//系统管理
		if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageSystem")){}
		else{ response.sendRedirect("../noperm.jsp");return;}
	}
}

if(userinfo_session==null || userinfo_session.getId()==0)
{

		String url = request.getRequestURI();
		String url2 = request.getQueryString();
		String Username = getParameter(request,"Username");
		String Username2 =getParameter(request,"Username2");

		if(url==null) url = "";
		if(url2!=null&&url2.length()>0) url += "?"+url2;

		Cookie[] cookies = request.getCookies();

		if(cookies!=null&&Username.length()==0&&Username2.length()==0)
		{ 

			for(int i=0;i<cookies.length;i++)
			{
				if(cookies[i].getName().equals("Username"))
					Username = cookies[i].getValue();	
				if(cookies[i].getName().equals("Username2"))
					Username2 = cookies[i].getValue();	
			}
		}
		
		if(!Username2.equals(""))
		{
				tidemedia.cms.user.UserInfo userinfo = new tidemedia.cms.user.UserInfo();

				if(userinfo.Authorization(request,response,Username,Username2,true)==1)
				{
					if(url.equals(""))
						response.sendRedirect("cms_main.jsp");
					else
						response.sendRedirect(url);
					return;
				}
		}

		String url_session = tidemedia.cms.system.CmsCache.getParameterValue("new_platform_url");
		if(url_session==null||url_session.equals(""))
			url_session=request.getContextPath();

		out.println("<script>");
		out.println("var h=top.location.href;if(h.indexOf('/cms_main.jsp')!=-1||h.indexOf('/main.jsp')!=-1||h.indexOf('/main_')!=-1||h.indexOf('/index')!=-1||h.indexOf('Index2018.jsp')!=-1||h.indexOf('/webIndex.jsp')!=-1) top.location='"+url_session+"/index.jsp';else top.location=\""+url_session+"/index.jsp?Url="+java.net.URLEncoder.encode(url)+"\";");
		out.println("</script>");
		out.close();
		return;
}
%><%!
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