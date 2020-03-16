
<%@page errorPage="/cms_error.jsp" contentType="text/html;charset=utf-8"%><%
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);

request.setCharacterEncoding("utf-8");

   JSONObject json1=new JSONObject();
  //判断用户是否登陆
  tidemedia.app.system.appUserInfo  appUserInfo =(tidemedia.app.system.appUserInfo)session.getAttribute("appUserInfo");
    int userid=0;//用户id
    if (appUserInfo==null||appUserInfo.getId()==0){
        json1.put("message","对不起请登陆后再执行此操作。");
        out.println(json1);
        return;
    }else{
       userid=appUserInfo.getId();
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
