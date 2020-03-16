<%@page errorPage="/cms_error.jsp"%>
<%!
//Í¨¹ýTokenµÇÂ½
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
	}%>

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

if(session.getAttribute("CMSUserInfo")!=null)
{
	userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
}

if(userinfo_session==null || userinfo_session.getId()==0)
{

		String url = request.getRequestURI();
		String url2 = request.getQueryString();
		String Username = getParameter(request,"Username");
		String Username2 =getParameter(request,"Username2");
		String Token = getParameter(request,"Token");

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
		else if(!Token.equals(""))
		{
		 
			int userid = UserInfoUtil.AuthUserByToken(Token);
			userinfo_session = new  tidemedia.cms.user.UserInfo(userid);
			userinfo_session.Authorization(request,response,userinfo_session.getUsername(),userinfo_session.getPassword());
		}
		
		if(!Username2.equals(""))
		{		tidemedia.cms.user.UserInfo userinfo = new tidemedia.cms.user.UserInfo();
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
		out.println("var h=top.location.href;if(h.indexOf('/cms_main.jsp')!=-1||h.indexOf('/main.jsp')!=-1||h.indexOf('/main_')!=-1) top.location='"+url_session+"/index.jsp';else top.location=\""+url_session+"/index.jsp?Url="+java.net.URLEncoder.encode(url)+"\";");
		out.println("</script>");
		out.close();
		return;
}
%>
