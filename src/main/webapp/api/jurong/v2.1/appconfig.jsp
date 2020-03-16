<%@ page contentType="text/html;charset=utf-8" %>
<%@page errorPage="/cms_error.jsp"%><%
    response.setHeader("Pragma","No-cache");
    response.setHeader("Cache-Control","no-cache");
    response.setDateHeader("Expires", 0);

    request.setCharacterEncoding("utf-8");

    tidemedia.cms.user.UserInfo  userinfo_session  = new tidemedia.cms.user.UserInfo();
  
    String username="";
    int		userid			= 0;

	if(session.getAttribute("appUserInfo")!=null)
    {
        userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("appUserInfo");
        userid=userinfo_session.getId();//session用户id
        username=userinfo_session.getName();
    }

	if(userid==0){
        org.json.JSONObject json_session=new org.json.JSONObject();
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
        
        return true;
    }
%>
