<%@page errorPage="/cms_error.jsp"%><%
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
        response.sendRedirect("ugc_main.jsp");
    }

    if(userinfo_session==null || userinfo_session.getId()==0)
    {

        String token = "";
        String url = "";

        Cookie[] cookies = request.getCookies();

        if(cookies!=null)
        {

            for(int i=0;i<cookies.length;i++)
            {
                if(cookies[i].getName().equals("token"))
                    token = cookies[i].getValue();
            }
        }

        if(!token.equals(""))
        {
            tidemedia.cms.user.UserInfo userinfo = new tidemedia.cms.user.UserInfo();

            if(userinfo.Authorization(request,response,"",token,true)==1)
            {
                if(url.equals(""))
                    response.sendRedirect("ugc_main.jsp");
                else
                    response.sendRedirect(url);
                return;
            }
        }
    }
%>
