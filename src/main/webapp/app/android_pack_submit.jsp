<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
    //新增
%>
<%
    String callback=getParameter(request,"callback");
    JSONObject json = new JSONObject();
    int   id      =   getIntParameter(request,"ItemID");
    int   ChannelID      =   getIntParameter(request,"ChannelID");
    //基本信息
    String Title=getParameter(request,"Title");
    String packag=getParameter(request,"package");
    String HOME_URL=getParameter(request,"HOME_URL");
    String PHP_URL=getParameter(request,"PHP_URL");
    String SITE=getParameter(request,"SITE");
    String version=getParameter(request,"version");
    HashMap politicsmap=new HashMap();
    politicsmap.put("Title",Title+"");
    politicsmap.put("packag",packag+"");
    politicsmap.put("HOME_URL",HOME_URL+"");
    politicsmap.put("PHP_URL",PHP_URL+"");
    politicsmap.put("SITE",SITE+"");
    politicsmap.put("version",version+"");
    //首页样式
    String home_style=getParameter(request,"home_style");
    String main_bottom1=getParameter(request,"main_bottom1");
    String main_bottom2=getParameter(request,"main_bottom2");
    String main_bottom3=getParameter(request,"main_bottom3");
    String main_bottom4=getParameter(request,"main_bottom4");

    String main_bottm1="{main_bottom_bar_str_1:"+main_bottom1+",main_bottom_bar_str_2:"+main_bottom2+"}";
    String main_bottom="{\"main_bottom_bar_str_1\":\""+main_bottom1+"\"," +
                         "\"main_bottom_bar_str_2\":\""+main_bottom2+"\"," +
                         "\"main_bottom_bar_str_3\":\""+main_bottom3+"\"," +
                         "\"main_bottom_bar_str_4\":\""+main_bottom4+"\"}";
    String THEME_COLOR=getParameter(request,"THEME_COLOR");
    String THEME_TOP_COLOR=getParameter(request,"THEME_TOP_COLOR");

    politicsmap.put("home_style",home_style+"");
    politicsmap.put("main_bottom",main_bottom+"");
    politicsmap.put("THEME_COLOR",THEME_COLOR+"");
    politicsmap.put("THEME_TOP_COLOR",THEME_TOP_COLOR+"");
   

    //480*800图片信息
    String hdpi_logo=getParameter(request,"hdpi_logo");
    String hdpi_launcher_pic=getParameter(request,"hdpi_launcher_pic");
    String hdpi_logo_home=getParameter(request,"hdpi_logo_home");
    String hdpi_column=getParameter(request,"hdpi_column");//状态栏目标图需要存json格式
    String hdpi_default_pic=getParameter(request,"hdpi_default_pic");//列表页文章默认加载图
    String hdpi_ic_mine_home_black=getParameter(request,"hdpi_ic_mine_home_black");//顶部左上角图标
    String hdpi_ic_search_home_black=getParameter(request,"hdpi_ic_search_home_black");//顶部右上角图标
    politicsmap.put("hdpi_logo",hdpi_logo+"");
    politicsmap.put("hdpi_launcher_pic",hdpi_launcher_pic+"");
    politicsmap.put("hdpi_logo_home",hdpi_logo_home+"");
    politicsmap.put("hdpi_column",hdpi_column+"");
    politicsmap.put("hdpi_default_pic",hdpi_default_pic+"");
    politicsmap.put("hdpi_ic_mine_home_black",hdpi_ic_mine_home_black+"");
    politicsmap.put("hdpi_ic_search_home_black",hdpi_ic_search_home_black+"");
    
    //720*1280图片信息
    String xhdpi_logo=getParameter(request,"xhdpi_logo");
    String xhdpi_launcher_pic=getParameter(request,"xhdpi_launcher_pic");
    String xhdpi_logo_home=getParameter(request,"xhdpi_logo_home");
    String xhdpi_column=getParameter(request,"xhdpi_column");//状态栏目标图需要存json格式
    String xhdpi_default_pic=getParameter(request,"xhdpi_default_pic");//列表页文章默认加载图
    String xhdpi_ic_mine_home_black=getParameter(request,"xhdpi_ic_mine_home_black");//顶部左上角图标
    String xhdpi_ic_search_home_black=getParameter(request,"xhdpi_ic_search_home_black");//顶部右上角图标
    politicsmap.put("xhdpi_logo",xhdpi_logo+"");
    politicsmap.put("xhdpi_launcher_pic",xhdpi_launcher_pic+"");
    politicsmap.put("xhdpi_logo_home",xhdpi_logo_home+"");
    politicsmap.put("xhdpi_column",xhdpi_column+"");
    politicsmap.put("xhdpi_default_pic",xhdpi_default_pic+"");
    politicsmap.put("xhdpi_ic_mine_home_black",xhdpi_ic_mine_home_black+"");
    politicsmap.put("xhdpi_ic_search_home_black",xhdpi_ic_search_home_black+"");
    
    //1080*1920
    String xxhdpi_logo=getParameter(request,"xxhdpi_logo");
    String xxhdpi_launcher_pic=getParameter(request,"xxhdpi_launcher_pic");
    String xxhdpi_logo_home=getParameter(request,"xhdpi_logo_home");
    String xxhdpi_column=getParameter(request,"xxhdpi_column");//状态栏目标图需要存json格式
    String xxhdpi_default_pic=getParameter(request,"xxhdpi_default_pic");//列表页文章默认加载图
    String xxhdpi_ic_mine_home_black=getParameter(request,"xxhdpi_ic_mine_home_black");//顶部左上角图标
    String xxhdpi_ic_search_home_black=getParameter(request,"xxhdpi_ic_search_home_black");//顶部右上角图标
    politicsmap.put("xxhdpi_logo",xxhdpi_logo+"");
    politicsmap.put("xxhdpi_launcher_pic",xxhdpi_launcher_pic+"");
    politicsmap.put("xxhdpi_logo_home",xxhdpi_logo_home+"");
    politicsmap.put("xxhdpi_column",xxhdpi_column+"");
    politicsmap.put("xxhdpi_default_pic",xxhdpi_default_pic+"");
    politicsmap.put("xxhdpi_ic_mine_home_black",xxhdpi_ic_mine_home_black+"");
    politicsmap.put("xxhdpi_ic_search_home_black",xxhdpi_ic_search_home_black+"");
    
    //第三方信息
    String UMENG_APP1=getParameter(request,"UMENG_APP");
    String UMENG_APP_KEY=getParameter(request,"UMENG_APP_KEY");
    String UMENG_APP="{\"UMENG_APP\":\""+UMENG_APP1+"\"," +
                      "\"UMENG_APP_KEY\":\""+UMENG_APP_KEY+"\"}";
                        
    String WECHAT_APP1=getParameter(request,"WECHAT_APP");
    String WECHAT=getParameter(request,"WECHAT");
    
    String WECHAT_APP="{\"WECHAT_APPID\":\""+WECHAT_APP1+"\"," +
                      "\"WECHAT_APPKEY\":\""+WECHAT+"\"}";
    System.out.println("钥匙："+WECHAT);                 
    String QQ_APP1=getParameter(request,"QQ_APP");
    String QQ_APP_KEY=getParameter(request,"QQ_APP_KEY");
    String QQ_APP="{\"QQ_APPID\":\""+QQ_APP1+"\"," +
                    "\"QQ_APPKEY\":\""+QQ_APP_KEY+"\"}";
    System.out.println("钥匙QQ_APP_KEY："+QQ_APP_KEY);
    String SINA_APP1=getParameter(request,"SINA_APP");
    String SINA_APP_KEY=getParameter(request,"SINA_APP_KEY");
    String SINA_APP_URL=getParameter(request,"SINA_APP_URL");
    String SINA_APP="{\"SINA_APPID\":\""+SINA_APP1+"\"," +
                      "\"SINA_APPKEY\":\""+SINA_APP_KEY+"\"," +
                      "\"SINA_BACK_URL\":\""+SINA_APP_URL+"\"}";
                      
    String MIPUSH_APP1=getParameter(request,"MIPUSH_APP");
    String MIPUSH_APP_KEY=getParameter(request,"MIPUSH_APP_KEY");
    String MIPUSH_APP="{\"MIPUSH_APPID\":\""+MIPUSH_APP1+"\"," +
                      "\"MIPUSH_APPKEY\":\""+MIPUSH_APP_KEY+"\"}";
                      
    String BUGLY1=getParameter(request,"BUGLY");
    String BUGLY_KEY=getParameter(request,"BUGLY_KEY");
    String BUGLY="{\"BUGLY_ID\":\""+BUGLY1+"\"," +
                      "\"BuglykeY\":\""+BUGLY_KEY+"\"}";
                      
    String baidu1=getParameter(request,"baidu");
    String baidu_KEY=getParameter(request,"baidu_KEY");
    String baidu="{\"baidu1\":\""+baidu1+"\"," +
                      "\"baidu_stat_id\":\""+baidu_KEY+"\"}";
                      
    String baidu_map1=getParameter(request,"baidu_map");
    String baidu_map_KEY=getParameter(request,"baidu_map_KEY");
    String baidu_map="{\"baidu_map1\":\""+baidu_map1+"\"," +
                      "\"baidu_map_key\":\""+baidu_map_KEY+"\"}";
                      
    String JUXIAN_TOkEN1=getParameter(request,"JUXIAN_TOkEN");
    String JUXIAN_COMPANYID=getParameter(request,"JUXIAN_COMPANYID");
    String JUXIAN_ADRESS=getParameter(request,"JUXIAN_ADRESS");
    String JUXIAN_COMPANYNAME=getParameter(request,"JUXIAN_COMPANYNAME");
    String JUXIAN_COLOR=getParameter(request,"JUXIAN_COLOR");
    String JUXIAN="{\"JUXIAN_TOkEN1\":\""+JUXIAN_TOkEN1+"\"," +
                     "\"JUXIAN_COMPANYID\":\""+JUXIAN_COMPANYID+"\"," +
                     "\"JUXIAN_ADRESS\":\""+JUXIAN_ADRESS+"\"," +
                     "\"JUXIAN_COMPANYNAME\":\""+JUXIAN_COMPANYNAME+"\"," +
                     "\"JUXIAN_COLOR\":\""+JUXIAN_COLOR+"\"}";
                      
    politicsmap.put("UMENG_APP",UMENG_APP+"");
    politicsmap.put("WECHAT_APP",WECHAT_APP+"");
    politicsmap.put("QQ_APP",QQ_APP+"");
    politicsmap.put("SINA_APP",SINA_APP+"");
    politicsmap.put("MIPUSH_APP",MIPUSH_APP+"");
    politicsmap.put("BUGLY",BUGLY+"");
    politicsmap.put("baidu",baidu+"");
    politicsmap.put("baidu_map",baidu_map+"");
    politicsmap.put("JUXIAN",JUXIAN+"");
   
    try {
        int gid = ItemUtil.addItemGetGlobalID(ChannelID, politicsmap);
    }catch (Exception e){
        out.println("失败"+e.toString());
    }


%>















