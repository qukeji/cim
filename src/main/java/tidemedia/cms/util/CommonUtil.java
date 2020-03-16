package tidemedia.cms.util;

import org.apache.jasper.runtime.JspWriterImpl;
import org.springframework.ui.ModelMap;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.user.UserInfo;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class CommonUtil {

    /**
     *
     * @param time
     *           时间
     * @param num
     *           加的数，-num就是减去
     * @return
     *          减去相应的数量的天的日期
     * @throws ParseException Date
     */
    public static Date dayAddNum(Date time, Integer num){
        //SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        //Date date = format.parse(time);

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(time);
        calendar.add(Calendar.MONDAY, num);
        Date newTime = calendar.getTime();
        return newTime;
    }

    /**
     * 按天增加
     * @param time
     * @param num
     * @return
     */
    public static Date dayAddByDay(Date time, Integer num) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(time);
        calendar.add(Calendar.DATE, num);
        Date newTime = calendar.getTime();
        return newTime;
    }

    /**
     * 获取当天零点的毫秒数
     * @return
     */
    public static Long getCurrentZeroTime() {
     Calendar calendar = Calendar.getInstance();
     calendar.setTime(new Date());
     calendar.set(Calendar.HOUR_OF_DAY, 0);
     calendar.set(Calendar.MINUTE, 0);
     calendar.set(Calendar.SECOND, 0);
     Date zero = calendar.getTime();
     long time = zero.getTime();
     return time;
    }

    /**
     * 用于Base64解码（对接荔枝云CAS）
     * @param input
     * @return
     * @throws Exception
     */
    public static String decodeBase64(String input) throws Exception{
        Class clazz=Class.forName("com.sun.org.apache.xerces.internal.impl.dv.util.Base64");
        Method mainMethod= clazz.getMethod("decode", String.class);
        mainMethod.setAccessible(true);
        Object retObj=mainMethod.invoke(null, input);
        return new String((byte[])retObj,"utf-8");
    }

    public static List<Date> getEveryDay(Date beginime,Date endtime){
        //定义一个接受时间的集合
        List<Date> lDate = new ArrayList<Date>();
        lDate.add(beginime);
        Calendar calBegin = Calendar.getInstance();
        // 使用给定的 Date 设置此 Calendar 的时间
        calBegin.setTime(beginime);
        Calendar calEnd = Calendar.getInstance();
        // 使用给定的 Date 设置此 Calendar 的时间
        calEnd.setTime(endtime);
        // 测试此日期是否在指定日期之后
        while (endtime.after(calBegin.getTime()))  {
            // 根据日历的规则，为给定的日历字段添加或减去指定的时间量
            calBegin.add(Calendar.DAY_OF_MONTH, 1);
            lDate.add(calBegin.getTime());
            System.out.println(calBegin.getTime());
        }
        return lDate;
    }
    public static String getParameter(HttpServletRequest request, String str)
    {
        if(request.getParameter(str)==null)
            return "";
        else
            return request.getParameter(str);
    }

    public static String convertNull(String input)
    {
        if(input==null)
            return "";
        else
            return input;
    }

    public static String getParentChannelPath(Channel channel) throws MessageException, SQLException {

        String path = "";
        ArrayList arraylist = channel.getParentTree();

        if ((arraylist != null) && (arraylist.size() > 0))
        {
            for (int i = 0; i < arraylist.size(); ++i)
            {
                Channel ch = (Channel)arraylist.get(i);
                path = path  + ch.getId()  + ((i < arraylist.size() - 1) ? "," : "");
            }
        }

        arraylist = null;

        return path;
    }
    public static int getIntParameter(HttpServletRequest request, String str) {
        String tempstr = getParameter(request, str);
        if (tempstr.equals(""))
            return 0;
        else
            return Integer.valueOf(tempstr).intValue();
    }

    public ModelMap config(UserInfo userinfo_session, HttpServletResponse response, HttpServletRequest request, ModelMap modelMap) throws Exception {
        HttpSession session = request.getSession();

        String ico = "favicon.ico";
        String title_ = CmsCache.getCompany();
        String title_main = "";
        String company_info = "";
        try{
            TideJson system_ico = CmsCache.getParameter("system_ico").getJson();
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

        modelMap.addAttribute("ico",ico);
        modelMap.addAttribute("title_",title_);
        modelMap.addAttribute("title_main",title_main);
        modelMap.addAttribute("company_info",company_info);


        if(session.getAttribute("CMSUserInfo")!=null)
        {
            userinfo_session = (UserInfo)session.getAttribute("CMSUserInfo");
            String path = request.getServletPath();
            if(path.startsWith("/explorer/"))
            {
                //文件管理
                if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageFile")){}
                else{ response.sendRedirect("../noperm.jsp");return null;}
            }

            if(path.startsWith("/channel/"))
            {
                //结构管理
                if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
                else{ response.sendRedirect("../noperm.jsp");return null;}

                if(userinfo_session.isSiteAdministrator())
                {
                    int channelid_ = CommonUtil.getIntParameter(request,"ChannelID");
                    Channel channel_ = CmsCache.getChannel(channelid_);
                    System.out.println("channelid_"+channelid_+",site:"+userinfo_session.getSite()+","+channel_.getSite().getId());
                    if(!userinfo_session.getSite().equals(channel_.getSite().getId()+""))
                    {response.sendRedirect("../noperm.jsp");return null;}
                }
            }

            if(path.startsWith("/system/"))
            {
                //系统管理
                if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageSystem")){}
                else{ response.sendRedirect("../noperm.jsp");return null;}
            }
        }

        if(userinfo_session==null || userinfo_session.getId()==0)
        {

            String url = request.getRequestURI();
            String url2 = request.getQueryString();
            String Username = CommonUtil.getParameter(request,"Username");
            String Username2 =CommonUtil.getParameter(request,"Username2");

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
                UserInfo userinfo = new UserInfo();

                if(userinfo.Authorization(request,response,Username,Username2,true)==1)
                {
                    if(url.equals(""))
                        response.sendRedirect("cms_main.jsp");
                    else
                        response.sendRedirect(url);
                    return null;
                }
            }

            String url_session = CmsCache.getParameterValue("new_platform_url");
            if(url_session==null||url_session.equals(""))
                url_session=request.getContextPath();

            JspWriter out = new JspWriterImpl();
            out.println("<script>");
            out.println("var h=top.location.href;if(h.indexOf('/cms_main.jsp')!=-1||h.indexOf('/main.jsp')!=-1||h.indexOf('/main_')!=-1||h.indexOf('/index')!=-1||h.indexOf('Index2018.jsp')!=-1||h.indexOf('/webIndex.jsp')!=-1) top.location='"+url_session+"/index.jsp';else top.location=\""+url_session+"/index.jsp?Url="+ URLEncoder.encode(url)+"\";");
            out.println("</script>");
            out.close();

            return null;
        }
        return modelMap;
    }

    public UserInfo getSessionObject(HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session.getAttribute("CMSUserInfo") != null){
            UserInfo userinfo_session = (tidemedia.cms.user.UserInfo) session.getAttribute("CMSUserInfo");

            return userinfo_session;
        }
        return null;
    }

    public static void main(String[] args) throws ParseException {

// 2. 使用Calendar类获取
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = format.parse("2019-08-31 20:20:20");
        System.out.println("-------"+dayAddNum(date,-1));
        getEveryDay(date,dayAddNum(date,20));
        System.out.println(dayAddNum(date,20).getTime()/1000);
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String date_str = sdf.format(new Date(1567153179*1000L));// 时间戳转换成时间
        System.out.println(date_str);

    }
}
