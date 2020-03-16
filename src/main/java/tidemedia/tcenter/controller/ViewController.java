package tidemedia.tcenter.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import springfox.documentation.annotations.ApiIgnore;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.CommonUtil;
import tidemedia.cms.util.Util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * 前端页面都使用此视图类
 */
@Controller
public class ViewController {

    @RequestMapping(method = RequestMethod.GET, value = {"/","/index"})
    public String index(HttpServletRequest request, HttpServletResponse response,ModelMap modelMap) throws MessageException, SQLException, IOException {
        String Username = "";
        String Username2 = "";

        Cookie[] cookies = request.getCookies();
        if(cookies!=null)
        {
            for(int i=0;i<cookies.length;i++)
            {
                if(cookies[i].getName().equals("Username"))
                    Username = cookies[i].getValue();
                if(cookies[i].getName().equals("Username2"))
                    Username2 = cookies[i].getValue();
            }
        }

        String Url = CommonUtil.getParameter(request,"Url");
        if(!Username2.equals(""))
        {
            UserInfo userinfo = new UserInfo();

            if(userinfo.Authorization(request,response,Username,Username2,true)==1)
            {
                if(Url.equals(""))
                    response.sendRedirect("main.jsp");
                else
                    response.sendRedirect(Url);
                return null;
            }
        }

        String copyright = CmsCache.getParameter("copyright").getContent();//底部
        String background_image = CmsCache.getParameter("background_image").getContent();//背景图片
        String logo_image = CmsCache.getParameter("logo_image").getContent();

        String ico = "favicon.ico";
        String title_ = tidemedia.cms.system.CmsCache.getCompany();
        tidemedia.cms.util.TideJson system_ico = tidemedia.cms.system.CmsCache.getParameter("system_ico").getJson();
        if(system_ico!=null){
            if(!system_ico.getString("ico").equals("")){
                ico = system_ico.getString("ico");
            }
            if(!system_ico.getString("title").equals("")){
                title_ = system_ico.getString("title_main");
            }
        }

        //HttpSession session = request.getSession();
        modelMap.addAttribute("title_", Util.convertNull(title_));
        modelMap.addAttribute("ico", Util.convertNull(ico));
        modelMap.addAttribute("logo_image", Util.convertNull(logo_image));
        modelMap.addAttribute("Url", Util.convertNull((Url)));
        modelMap.addAttribute("copyright", Util.convertNull(copyright));
        modelMap.addAttribute("background_image", Util.convertNull(background_image));
        modelMap.addAttribute("Username", Util.convertNull(Username));
        return "index";
    }


    @RequestMapping(method = RequestMethod.GET, value = {"/html/{viewname}"})
    public String test(@PathVariable("viewname") String viewname,
                       HttpServletRequest request, HttpServletResponse response,
                       @ApiIgnore ModelMap modelMap) throws MessageException, SQLException, IOException {
        String Username = "";
        String Username2 = "";

        Cookie[] cookies = request.getCookies();
        if(cookies!=null)
        {
            for(int i=0;i<cookies.length;i++)
            {
                if(cookies[i].getName().equals("Username"))
                    Username = cookies[i].getValue();
                if(cookies[i].getName().equals("Username2"))
                    Username2 = cookies[i].getValue();
            }
        }

        String Url = CommonUtil.getParameter(request,"Url");
        if(!Username2.equals(""))
        {
            UserInfo userinfo = new UserInfo();

            if(userinfo.Authorization(request,response,Username,Username2,true)==1)
            {
                if(Url.equals(""))
                    response.sendRedirect("main.jsp");
                else
                    response.sendRedirect(Url);
                return null;
            }
        }

        String copyright = CmsCache.getParameter("copyright").getContent();//底部
        String background_image = CmsCache.getParameter("background_image").getContent();//背景图片
        String logo_image = CmsCache.getParameter("logo_image").getContent();

        String ico = "favicon.ico";
        String title_ = tidemedia.cms.system.CmsCache.getCompany();
        tidemedia.cms.util.TideJson system_ico = tidemedia.cms.system.CmsCache.getParameter("system_ico").getJson();
        if(system_ico!=null){
            if(!system_ico.getString("ico").equals("")){
                ico = system_ico.getString("ico");
            }
            if(!system_ico.getString("title").equals("")){
                title_ = system_ico.getString("title_main");
            }
        }

        //HttpSession session = request.getSession();
        modelMap.addAttribute("title_", Util.convertNull(title_));
        modelMap.addAttribute("ico", Util.convertNull(ico));
        modelMap.addAttribute("logo_image", Util.convertNull(logo_image));
        modelMap.addAttribute("Url", Util.convertNull((Url)));
        modelMap.addAttribute("copyright", Util.convertNull(copyright));
        modelMap.addAttribute("background_image", Util.convertNull(background_image));
        modelMap.addAttribute("Username", Util.convertNull(Username));
        return viewname;
    }
}
