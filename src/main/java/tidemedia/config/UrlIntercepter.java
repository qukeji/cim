package tidemedia.config;


import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.Util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

@Configuration
public class UrlIntercepter implements HandlerInterceptor {
    long start = System.currentTimeMillis();

    public String getParameter(HttpServletRequest request, String str) {
        if (request.getParameter(str) == null)
            return "";
        else
            return request.getParameter(str);
    }

    public int getIntParameter(HttpServletRequest request, String str) {
        String tempstr = getParameter(request, str);
        if (tempstr.equals(""))
            return 0;
        else {
            int i = 0;
            try {
                i = Integer.valueOf(tempstr).intValue();
            } catch (Exception e) {
            }
            return i;
        }
    }

    public String convertNull(String input) {
        if (input == null)
            return "";
        else
            return input;
//		return tidemedia.cms.util.Util.convertEncode(input);
    }

    public void removeSession(HttpSession session, String[] items) {
        for (int i = 0; i < items.length; i++) {
            session.removeAttribute(items[i]);
        }
    }

    public boolean CheckExplorerSite(tidemedia.cms.user.UserInfo userinfo_session, int siteid) {
        if (!(userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator())) {
            return false;
        }

        if (userinfo_session.isSiteAdministrator()) {
            if (!userinfo_session.getSite().equals(siteid + "")) {
                return false;
            }
        }
        return true;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
        //三步判断 是否静态资源 是否登录用户 用户角色，更详细的权限在具体代码里面实现
        start = System.currentTimeMillis();
        HttpSession session = request.getSession();
        String path = request.getServletPath();//实际请求路径
        //System.out.println("ServerPath:"+ServerPath);

        //静态资源或首页判断
        if(path.startsWith("/common/")) return true;
        if(path.startsWith("/lib/")) return true;
        if(path.startsWith("/style/")) return true;
        if(path.startsWith("/img/")) return true;
        if(path.startsWith("/index.jsp")||path.startsWith("/index")) {
            return true;
        }

        tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();

        if(session.getAttribute("CMSUserInfo")!=null)
        {
            userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
        }
        if(userinfo_session==null || userinfo_session.getId()==0)
        {
            PrintWriter writer = null;
            response.setCharacterEncoding("UTF-8");
            response.setContentType("text/html; charset=utf-8");

            String url_session=request.getContextPath();
            String s = "<script>";
            s += ("var h=top.location.href;top.location=\""+url_session+"/index?Url="+java.net.URLEncoder.encode(path,"utf-8")+"\";");
            s += "</script>";
            writer = response.getWriter();
            writer.print(s);
            writer.close();
            return false;
        }


        if (path.startsWith("/explorer/")) {
            //文件管理
            if ((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageFile")) {
                return true;
            } else {
                response.sendRedirect("/noperm.jsp");
                return false;
            }
        }

        if (path.startsWith("/channel/")) {
            //结构管理
            if ((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")) {
                return true;
            } else {
                response.sendRedirect("../noperm.jsp");
                return false;
            }
        }

        if (path.startsWith("/system/")) {
            //系统管理
            if ((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageSystem")) {
                return true;
            } else {
                response.sendRedirect("../noperm.jsp");
                return false;
            }
        }

        return true;
        /*

        boolean isPass = false;

        if(!isPass){
            httpServletResponse.setHeader("Pragma", "No-cache");
            httpServletResponse.setHeader("Cache-Control", "no-cache");
            httpServletResponse.setDateHeader("Expires", 0);

            httpServletRequest.setCharacterEncoding("utf-8");
            int max_perpage = 20;        //MAX DISPLAY RECORDS IN ONE PAGE//

            tidemedia.cms.system.Site defaultSite = tidemedia.cms.system.CmsCache.getDefaultSite();

            tidemedia.cms.base.Config defaultConfig = tidemedia.cms.system.CmsCache.getConfig();
            //check user validate
            tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();

            String ico = "favicon.ico";
            String title_ = tidemedia.cms.system.CmsCache.getCompany();
            String title_main = "";
            String company_info = "";
            try {
                tidemedia.cms.util.TideJson system_ico = tidemedia.cms.system.CmsCache.getParameter("system_ico").getJson();
                if (system_ico != null) {
                    if (!system_ico.getString("ico").equals("")) {
                        ico = system_ico.getString("ico");
                    }
                    if (!system_ico.getString("title").equals("")) {
                        title_ = system_ico.getString("title");
                    }
                    if (!system_ico.getString("title_main").equals("")) {
                        title_main = system_ico.getString("title_main");
                    }
                    if (!system_ico.getString("company_info").equals("")) {
                        company_info = system_ico.getString("company_info");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }




            if (userinfo_session == null || userinfo_session.getId() == 0) {

                String url = httpServletRequest.getRequestURI();
                String url2 = httpServletRequest.getQueryString();
                String Username = getParameter(httpServletRequest, "Username");
                String Username2 = getParameter(httpServletRequest, "Username2");

                if (url == null) url = "";
                if (url2 != null && url2.length() > 0) url += "?" + url2;

                Cookie[] cookies = httpServletRequest.getCookies();

                if (cookies != null && Username.length() == 0 && Username2.length() == 0) {

                    for (int i = 0; i < cookies.length; i++) {
                        if (cookies[i].getName().equals("Username"))
                            Username = cookies[i].getValue();
                        if (cookies[i].getName().equals("Username2"))
                            Username2 = cookies[i].getValue();
                    }
                }

                if (!Username2.equals("")) {
                    tidemedia.cms.user.UserInfo userinfo = new tidemedia.cms.user.UserInfo();

                    if (userinfo.Authorization(httpServletRequest, httpServletResponse, Username, Username2, true) == 1) {
                        isPass=true;
                        if (url.equals(""))
                            httpServletResponse.sendRedirect("cms_main.jsp");
                        else
                            httpServletResponse.sendRedirect(url);
                    }
                }

                String url_session = tidemedia.cms.system.CmsCache.getParameterValue("new_platform_url");
                if (url_session == null || url_session.equals(""))
                    url_session = httpServletRequest.getContextPath();

                PrintWriter writer = null;
                httpServletResponse.setCharacterEncoding("UTF-8");
                httpServletResponse.setContentType("text/html; charset=utf-8");
                try {
                    writer = httpServletResponse.getWriter();
                    writer.print("<script>");
                    writer.print("var h=top.location.href;if(h.indexOf('/cms_main.jsp')!=-1||h.indexOf('/main.jsp')!=-1||h.indexOf('/main_')!=-1||h.indexOf('/index')!=-1||h.indexOf('Index2018.jsp')!=-1||h.indexOf('/webIndex.jsp')!=-1) top.location='" + url_session + "/index';else top.location=\"" + url_session + "/index?Url=" + java.net.URLEncoder.encode(url) + "\";");
                    writer.print("</script>");
                    writer.close();
                    return false;
                } catch (IOException e) {
                    e.printStackTrace();
                } finally {
                    if (writer != null)
                        writer.close();
                }

            }
        }


        */

    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {
        //System.out.println("Interceptor cost=" + (System.currentTimeMillis() - start));
    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {
    }
}
