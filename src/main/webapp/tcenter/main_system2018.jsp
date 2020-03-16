<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*,
				java.sql.*"%>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%!
    //获取用户一月内登录次数
    public int getCount(int userId) throws MessageException,SQLException{
        int login_count = 0 ;

        String sql = "";
        TableUtil tu = new TableUtil();

        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        calendar.add(Calendar.DATE, +1);
        String  endDate = sdf.format(calendar.getTime());
        calendar.add(Calendar.DATE, -30);
        String  startDate = sdf.format(calendar.getTime());

        sql= "select count(*) from login_log where Date>='"+startDate+"' and Date<'"+endDate+"' and User=" +userId;
        ResultSet Rs = tu.executeQuery(sql);
        while(Rs.next()) {
            login_count = Rs.getInt(1);
        }
        tu.closeRs(Rs);

        return login_count ;
    }
%>
<%

    Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
    cookie.setMaxAge(60*60*24*365);
    response.addCookie(cookie);
    String url = request.getRequestURL()+"";
    String base = url.replace(request.getRequestURI(),"");
    String system_logo = CmsCache.getParameter("system_logo").getContent();
    //当前登录用户的租户id
    int companyid = userinfo_session.getCompany();
    String url2="http://123.56.71.230:889/vms/pingtai_index_tcenter.jsp";
    url2 = Util.ClearPath(url2);
    String text =  Util.postHttpUrl(url2,"","utf-8");
    String sql = "";
    TableUtil tu = new TableUtil("user");

//用户管理数量
    int user_count = 0 ;
    sql= "select count(*) from userinfo";
    if(companyid!=0){
        sql += " where company="+companyid;
    }
    ResultSet Rs = tu.executeQuery(sql);
    while(Rs.next()) {
        user_count = Rs.getInt(1);
    }
    tu.closeRs(Rs);

//产品应用数量
    int product_count = 0 ;
    String products = new Company(companyid).getProducts();
    product_count = products.split(",").length;
/*sql= "select count(*) from tide_products";
ResultSet Rs1 = tu.executeQuery(sql);
while(Rs1.next()) {
	product_count = Rs1.getInt(1);
}
tu.closeRs(Rs1);
*/

//获取同租户下的用户
    String userids = "";
    if(companyid!=0){
        String sql2="select * from userinfo where company="+companyid;
        TableUtil tu2 = new TableUtil("user");
        ResultSet Rs2 = tu2.executeQuery(sql2);
        while(Rs2.next()){
            if(!userids.equals("")){
                userids += ",";
            }
            userids += Rs2.getInt("id");
        }
        tu2.closeRs(Rs2);
    }
//本日登录次数
    int login_count = 0 ;
    Calendar calendar = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String nowDate = sdf.format(calendar.getTime());
    calendar.add(Calendar.DATE, +1);
    String  endDate = sdf.format(calendar.getTime());
    sql= "select count(*) from login_log where Date>='"+nowDate+"' and Date<'"+endDate+"'";
    if(!userids.equals("")){
        sql +=" and User in ("+userids+")";
    }
    ResultSet Rs2 = tu.executeQuery(sql);
    while(Rs2.next()) {
        login_count = Rs2.getInt(1);
    }
    tu.closeRs(Rs2);

    String url11 = "/vms/system/pingtai_index.jsp?id=15&flag=6";//
    String encodeUrl11 = URLEncoder.encode(url11, "UTF-8");
    String url22 = "/vms/system/pingtai_index.jsp?id=13&flag=6";//
    String encodeUrl22 = URLEncoder.encode(url22, "UTF-8");

%>

<!DOCTYPE html>

<html id="green">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="../<%=ico%>">
    <title><%=title_%></title>

    <link href="lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="lib/2018/rickshaw/rickshaw.min.css" rel="stylesheet">
    <link href="lib/2018/chartist/chartist.css" rel="stylesheet">
    <link href="lib/2018/morris.js/morris.css" rel="stylesheet">
    <link rel="stylesheet" href="style/2018/bracket.css">

    <link rel="stylesheet" href="style/2018/common.css">
    <link rel="stylesheet" href="style/2018/tcenter.css">
    <link rel="stylesheet" href="style/theme/theme.css">

    <script type="text/javascript" src="lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="common/2018/common2018.js"></script>
    <script>
    </script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">
<div class="br-logo">
    <a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
        <img class="ht-100p" src="img/2019/<%=system_logo%>">
    </a>
</div>

<div class="br-sideleft overflow-y-auto">
    <label class="sidebar-label pd-x-15 mg-t-20"></label>

    <div class="br-sideleft-menu">

        <a href="#" class="br-menu-link active menu-home">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-home tx-22"></i>
                <span class="menu-item-label">概览</span>
            </div>
            <!-- menu-item -->
        </a>

        <!-- 结构管理-->
        <a href="#" class="br-menu-link menu-channel">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-sitemap tx-20"></i>
                <span class="menu-item-label">结构管理</span>
                <i class="menu-item-arrow fa fa-angle-down"></i>
            </div>
        </a>

        <!-- br-menu-link -->
        <ul class="br-menu-sub nav flex-column" id="system-menu-channel">
            <li class="nav-item"><a href="/tcenter/channel/pingtai_channel.jsp" class="nav-link system-menu3" id="system-menu-cms-channel">内容结构管理</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/channel/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-vms-channel">媒资结构管理</a></li>
        </ul>


        <%if(userinfo_session.hasPermission("ManageSystem")){%>
        <a href="#" class="br-menu-link menu-system-pingtai" id="menu-system">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-gears  tx-20"></i>
                <span class="menu-item-label">配置管理</span>
                <i class="menu-item-arrow fa fa-angle-down"></i>
            </div>
        </a>
        <ul class="br-menu-sub nav flex-column" id="system-menu-pingtai">


            <%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=1" class="nav-link system-menu1" id="system-menu-license">平台许可证</a></li><%}%>
            <%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=1" class="nav-link system-menu1" id="system-menu-license-vms">媒资许可证</a></li><%}%>
            <%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=2" class="nav-link system-menu2" id="system-menu-parameter">平台系统参数</a></li><%}%>
            <li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=11" class="nav-link system-menu11" id="system-menu-approve">工作流管理</a></li>
            <%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=10" class="nav-link system-menu10" id="system-menu-photoscheme">内容图片尺寸</a></li>   <%}%>
            <li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=12" class="nav-link system-menu12" id="system-menu-watermark">内容水印方案</a></li>

            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=2" class="nav-link system-menu" id="system-menu-vms-parameter">媒资系统参数</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=16" class="nav-link system-menu" id="system-menu-naly">AI功能配置</a></li>

            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=10" class="nav-link system-menu" id="system-menu-vms-photoscheme">转码服务器配置</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=11" class="nav-link system-menu" id="system-menu-photoscheme2">视频转码方案</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=12" class="nav-link system-menu" id="system-menu-vms-watermark">视频水印方案</a></li>

            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=<%=encodeUrl22%>" class="nav-link system-menu" id="system-menu-photoscheme3">视频全局配置</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=14" class="nav-link system-menu" id="system-menu-photoscheme4">视频目录配置</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=<%=encodeUrl11%>" class="nav-link system-menu" id="system-menu-chatiao">视频拆条配置</a></li>
            <li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=13" class="nav-link system-menu12" id="system-menu-loginverify">登陆验证</a></li>



        </ul>
        <%}%>

        <!-- 站点管理-->
        <a href="#" class="br-menu-link menu-site">
            <div class="br-menu-item ">
                <i class="menu-item-icon fa fa-gear tx-22"></i>
                <span class="menu-item-label">站点管理</span>
                <i class="menu-item-arrow fa fa-angle-down"></i>
            </div>
        </a>

        <!-- br-menu-link -->
        <ul class="br-menu-sub nav flex-column" id="system-menu-site" >
            <li class="nav-item"><a href="/tcenter/system/pingtaiindex.jsp" class="nav-link system-menu3" id="system-menu-cms-site">内容站点管理</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtaiindex.jsp" class="nav-link system-menu3" id="system-menu-vms-site">媒资站点管理</a></li>
        </ul>


        <!-- 文件管理-->
        <a href="#" class="br-menu-link menu-exploer">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-folder tx-20"></i>
                <span class="menu-item-label">文件管理</span>
                <i class="menu-item-arrow fa fa-angle-down"></i>
            </div>
        </a>

        <!-- br-menu-link -->
        <ul class="br-menu-sub nav flex-column" id="system-menu-exploer">
            <li class="nav-item"><a href="/tcenter/explorer/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-cms-exploer">内容文件管理</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/explorer/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-vms-exploer">媒资文件管理</a></li>
        </ul>
        <!-- 模板管理-->
        <a href="#" class="br-menu-link menu-template" >
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-calendar-o tx-20"></i>
                <span class="menu-item-label">模板管理</span>
                <i class="menu-item-arrow fa fa-angle-down"></i>
            </div>
        </a>
        <!-- br-menu-link -->
        <ul class="br-menu-sub nav flex-column" id="system-menu-template">
            <li class="nav-item"><a href="/tcenter/template/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-cms-template">内容模板管理</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/template/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-vms-template">媒资模板管理</a></li>
        </ul>
        <!-- 日志管理-->

        <!-- 备份管理-->
        <a href="#" class="br-menu-link menu-backup">
            <div class="br-menu-item">
                <i class="menu-item-icon  fa fa-clone tx-20"></i>
                <span class="menu-item-label">备份管理</span>
                <i class="menu-item-arrow fa fa-angle-down"></i>
            </div>
        </a>
        <!-- br-menu-link -->
        <ul class="br-menu-sub nav flex-column" id="system-menu-backup">
            <li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=7" class="nav-link system-menu3" id="system-menu-cms-backup">内容管理备份</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=7" class="nav-link system-menu3" id="system-menu-vms-backup">媒资管理备份</a></li>
        </ul>
        <!-- 备份管理-->
        <a href="#" class="br-menu-link menu-publish">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-share  tx-20"></i>
                <span class="menu-item-label">分发管理</span>
                <i class="menu-item-arrow fa fa-angle-down"></i>
            </div>
        </a>
        <!-- br-menu-link -->
        <ul class="br-menu-sub nav flex-column" id="system-menu-publish">
            <li class="nav-item"><a href="/tcenter/publish/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-cms-publish">内容分发管理</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/publish/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-vms-publish">媒资分发管理</a></li>
        </ul>
        <!-- 备份管理-->
        <a href="#" class="br-menu-link menu-manager">
            <div class="br-menu-item">
                <i class="menu-item-icon  fa fa-desktop tx-20"></i>
                <span class="menu-item-label">系统监控</span>
                <i class="menu-item-arrow fa fa-angle-down"></i>
            </div>
        </a>
        <!-- br-menu-link -->
        <ul class="br-menu-sub nav flex-column" id="system-menu-manager">
            <li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=8" class="nav-link system-menu3" id="system-menu-cms-manager">内容系统监控</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=8" class="nav-link system-menu3"id="system-menu-vms-manager">媒资系统监控</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/check/pingtai_index.jsp" class="nav-link system-menu3"	id="system-menu-vms-manager1">转码任务监测</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/check/pingtai_kuaibian_index.jsp" class="nav-link system-menu3" id="system-menu-vms-manager2">快编任务检测</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/check/pingtai_chatiao_index.jsp" class="nav-link system-menu3" id="system-menu-vms-manager3">拆条任务检测</a></li>
        </ul>
        <!-- 调度管理-->
        <a href="#" class="br-menu-link menu-quartz">
            <div class="br-menu-item">
                <i class="menu-item-icon  fa fa-joomla  tx-20"></i>
                <span class="menu-item-label">调度管理</span>
                <i class="menu-item-arrow fa fa-angle-down"></i>
            </div>
        </a>
        <!-- br-menu-link -->
        <ul class="br-menu-sub nav flex-column" id="system-menu-quartz">
            <li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=9" class="nav-link system-menu3" id="system-menu-cms-quartz">内容调度管理</a></li>
            <li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=9" class="nav-link system-menu3" id="system-menu-vms-quartz">媒资调度管理</a></li>
        </ul>

        <!-- 采集系统 -->
        <a href="/tcenter/spider/pingtai_index.jsp" class="br-menu-link  menu-spider">
            <div class="br-menu-item">
                <i class="menu-item-icon  fa fa-cloud-download tx-20"></i>
                <span class="menu-item-label">采集系统</span>
            </div>
            <!-- menu-item -->
        </a>

    </div>
    <!-- br-sideleft-menu -->
</div>
<!-- br-sideleft -->

<div class="br-header">
    <div class="br-header-left">
        <div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
        <div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
        <div class="hidden-md-down system-name"><a href="javascript:;"><i class=""></i>平台管理中心</a></div>
    </div>
    <!-- br-header-left -->
    <script language=javascript>var navi_menu = "运营支撑";</script>
    <%@include file="../include/header_navigate.jsp"%><!--静态包含-->
    <!-- br-header-right -->
</div>
<!-- br-header -->

<!-- ########## START: MAIN PANEL ########## -->
<div class="br-mainpanel with-first-nav">
    <div class="d-flex pd-30">
        <div class="td-logo theme-bg mg-r-10"><i class="tx-white fa fa-cog tx-40"></i></div>
        <div class="">
            <h4 class="tx-gray-800 mg-b-5">平台管理中心<span hidden>20.14.1230</span></h4>
            <p class="mg-b-0">本系统用于构建全局多租户用户管理、接入产品的管理以及用户登录日志查看。</p>
        </div>

    </div>

    <div class="br-pagebody mg-t-5 pd-x-30 ">
        <div class="row row-sm">
            <div class="col-sm-6 col-xl-4 mg-b-20">
                <div class="theme-bg rounded overflow-hidden">
                    <div class="pd-25 d-flex align-items-center">
                        <i class="fa fa-users tx-60 lh-0 tx-white "></i>
                        <div class="mg-l-20">
                            <p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">用户数量</p>
                            <p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1"><%=user_count%></p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-4 mg-b-20 mg-sm-t-0">
                <div class="theme-bg-9 rounded overflow-hidden">
                    <div class="pd-25 d-flex align-items-center">
                        <i class="fa fa-shopping-cart tx-60 lh-0 tx-white "></i>
                        <div class="mg-l-20">
                            <p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">产品应用数据</p>
                            <p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1"><%=product_count%></p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-4 mg-b-20 mg-sm-t-0">
                <div class="theme-bg-8 rounded overflow-hidden">
                    <div class="pd-25 d-flex align-items-center">
                        <i class="fa fa-sign-in tx-60 lh-0 tx-white "></i>
                        <div class="mg-l-20">
                            <p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">本日登录次数</p>
                            <p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1"><%=login_count%></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- row -->

        <div class="row row-sm mg-t-20">
            <div class="col-sm-12 col-xl-8">
                <div class="card bd-0 shadow-base pd-30 mg-t-0">
                    <div class=" pd-b-15">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <p class="tx-13 tx-uppercase tx-inverse tx-spacing-1 tx-18">
                                    <i class="fa fa-user-circle-o theme-tx-color mg-r-5 tx-20"></i>最近登录用户
                                </p>
                            </div>
                        </div>
                    </div>
                    <table class="table  table-valign-middle mg-b-0">
                        <tbody>

                        <%
                            sql = "select id,Role,LastLoginDate,Name from userinfo";
                            if(companyid!=0){
                                sql += " where company="+companyid;
                            }
                            sql += " order by LastLoginDate desc limit 0,10";
                            ResultSet Rs3 = tu.executeQuery(sql);
                            while(Rs3.next()) {
                                int id = Rs3.getInt("id");
                                String Name = convertNull(Rs3.getString("Name"));
                                String loginDate = convertNull(Rs3.getString("LastLoginDate")).replace(".0","");
                                int Role = Rs3.getInt("Role");
                                String RoleName = "";
                                if(Role==1)
                                    RoleName = "系统管理员";
                                else if(Role==2)
                                    RoleName = "频道管理员";
                                else if(Role==3)
                                    RoleName = "编辑";
                                else if(Role==4)
                                    RoleName = "站点管理员";
                                else if(Role==5)
                                    RoleName = "视客管理员";

                                int num = getCount(id);
                        %>
                        <tr>
                            <td class="pd-l-0-force wd-5p td_avatar_box">
                                <img src="img/2018/logo_mob.png" class="wd-40 rounded-circle" alt="">
                            </td>
                            <td>
                                <h6 class="tx-inverse tx-14 mg-b-0 td_user_name"><%=Name%></h6>
                                <span class="tx-12"><%=RoleName%></span>
                            </td>
                            <td>一月内登录次数：<%=num%>次</td>
                            <td>最近登录时间：<%=loginDate%></td>
                        </tr>
                        <%
                            }
                            tu.closeRs(Rs3);
                        %>
                        </tbody>
                    </table>
                </div><!-- card -->
            </div>
            <!-- col-9 -->
            <div class="col-sm-12 col-xl-4">
                <iframe  src="include/usehelp.html" class="height"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
            </div>
            <!-- col-3 -->
        </div>
        <!-- row -->
    </div>

</div>
<!-- br-mainpanel -->
<!-- ########## END: MAIN PANEL ########## -->
<script src="lib/2018/popper.js/popper.js"></script>
<script src="lib/2018/bootstrap/bootstrap.js"></script>
<script src="lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="lib/2018/moment/moment.js"></script>
<script src="lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="common/2018/bracket.js"></script>

<script>

    $(function() {
        'use strict'

        $(window).resize(function() {
            minimizeMenu();
        });

        minimizeMenu();

        function minimizeMenu() {
            if (window.matchMedia('(min-width: 992px)').matches && window.matchMedia('(max-width: 1299px)').matches) {
                $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
                $('body').addClass('collapsed-menu');
                $('.show-sub + .br-menu-sub').slideUp();
            } else if (window.matchMedia('(min-width: 1300px)').matches && !$('body').hasClass('collapsed-menu')) {
                $('.menu-item-label,.menu-item-arrow').removeClass('op-lg-0-force d-lg-none');
                $('body').removeClass('collapsed-menu');
                $('.show-sub + .br-menu-sub').slideDown();
            }
        }
    });
	
	//文字生成头像
	//;$(function(){
		var td_user_name = $(".td_user_name") ;
		$.each( td_user_name , function(vi,va){
			if( $(va).text() ){
				$(va).parents("tr").find(".td_avatar_box")
				.html('<div class="td_avatar" style="background:'+transNameToAvatar.tranColor( $(va).text() )+'">'+transNameToAvatar.firstName( $(va).text() )+'</div>')
			}
		})
	//})
	

</script>
</body>
</html>
