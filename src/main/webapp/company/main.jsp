<%@ page import="tidemedia.cms.system.*,
				 tidemedia.cms.base.*,
				 tidemedia.cms.util.*,
				 tidemedia.cms.user.*,
				 java.util.Date,
				 java.text.DecimalFormat,
				 java.text.SimpleDateFormat,
				 java.util.*,
				 java.sql.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp" %>
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
    Cookie cookie = new Cookie("Role", userinfo_session.getRole() + "");
    cookie.setMaxAge(60 * 60 * 24 * 365);
    response.addCookie(cookie);

    int Flag = getIntParameter(request, "Flag");
    String time = CmsCache.getExpiresDateStr();
    long current = System.currentTimeMillis();
    time = time.replaceAll("-", "/");
    Date date = new Date(time);
    long ExpiresDate = date.getTime();
    long diff = (ExpiresDate - current) / 1000; //秒
    String url = request.getRequestURL() + "";
    String base = url.replace(request.getRequestURI(), "");
    if (CmsCache.hasValidLicense()) diff = 1000000;
    String system_logo = CmsCache.getParameter("system_logo").getContent();
    
    int companyid = userinfo_session.getCompany();
    Company company1 = new Company(companyid);
%>


<!DOCTYPE html>
<html id="pgcMnanage">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title><%=title_%></title>

    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/rickshaw/rickshaw.min.css" rel="stylesheet">
    <link href="../lib/2018/chartist/chartist.css" rel="stylesheet">

    <link rel="stylesheet" href="../style/2018/bracket.css">

    <link rel="stylesheet" href="../style/2018/common.css">
    <link rel="stylesheet" href="../style/2018/theme.css">
    <!--<link rel="stylesheet" href="../style/2018/tcenter.css">-->

    <script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>

    <style>
        #zh_gailan .zh_bg_item{text-align:center;position:relative}
        #zh_gailan .col-xl-2{flex:0 0 20%;max-width:20%}
        #zh_gailan .zh_bg_item .img-box{width:70px;height:70px;overflow:hidden;text-align:center}
        #zh_gailan .zh_bg_item .img-box img{width:100%;height:100%;border-radius:50%}
        #zh_gailan .zh_bg_item .zh_gdtj_num{font-size:40px;word-break:break-all;line-height:1.2;flex:1;display:flex;align-items:center}
        #zh_gailan .zh_bg_item .zh_gdtj_today_num{min-height:18px}
        #zh_gailan .zh_bg_item .zh_bg_item_container{min-height:174px}
        #zh_gailan .zh_bg_item .zh_enter{position:absolute;right:5px;top:5px;width:40px;height:40px}
        #zh_gailan .zh_bg_item .zh_enter a{color:#eee}
        #zh_gailan .zh_bg_item .zh_enter a:hover{color:#fff}
        #zh_gailan .zh_bg_item .zh_name{min-height:21px}
        .column-1px{width:1px;background:#eee;height:50px;margin:0 10px 0 20px}
        ul,li{list-style:none}
        .product-tool-box ul{display:flex;flex-direction:row;flex-wrap:wrap}
        .product-tool-box ul li{width:72px;font-size:12px;transition:ease-in-out 0.3s;list-style:none;margin-right:10px;margin-bottom:10px}
        .product-tool-box ul li .fa{font-size:28px}
        .product-tool-box ul li a{width:72px;height:72px;display:flex;justify-content:center;align-items:center;flex-direction:column;border-radius:5px;font-size:12px;color:#fff;background-color:#da850a}
        .product-tool-box ul li a span{margin-top:5px}
        .product-tool-box ul .add-li a{background-color:rgba(147,147,147,0.3)}
    </style>

</head>
<script>

    $(function() {
    	$.ajax({
            type : "post",
            url : 'main_data.jsp',
            dataType:"json",
            success : function(data) {
                var pic_size = data.pic_size;
                var video_size = data.video_size;
                var userCount = data.userCount;
                var jobCount = data.jobCount;
                var todayJobCount = data.todayJobCount;
                var file_size = data.file_size;
                var useFileSpace = data.useFileSpace;
                var space = data.space;
                var publishCount = data.publishCount;
                var notSolveCount = data.notSolveCount;
                var useTotalSize = data.useTotalSize;
                var todayCount = data.todayCount;
                
                var yyzc = data.yyzc;
                var yyfb = data.yyfb;
                var zyhj = data.zyhj;
                var scgj = data.scgj;
                $("#file-use-p").text(useFileSpace+"G");
                $("#video-use-p").text(video_size+"G");
                $("#img-use-p").text(pic_size+"G");
                $("#publishCount").text(publishCount);
                $("#userCount").text(userCount);
                $("#total-use-p").html(useTotalSize+"G/"+"<span class=\"tx-20\" >"+space+"G"+"</span>");
                $("#totalSpace").text(space+"G");
                $("#jobCount").text(jobCount);
                $("#notSolveCount").text(notSolveCount);
                $("#todayCount").text("今日发稿量："+todayCount);
                $("#todayJobCount").text("今日提交工单："+todayJobCount);
                for (var i = 0; i < yyzc.length; i++) {
                	$("#product").append("<li  class=\"op-9\"><a style=\"background-color: #F49917\" href=\"<%=base%>"+yyzc[i].url+"\" data-url=\"<%=base%>/tcenter/subject/index_tcenter.jsp\" onclick=\"jumpTool(this)\">"+yyzc[i].logo+"<span>"+yyzc[i].proName+"</span></a><p class=\"tx-center mg-y-5\">已开通</p></li>");
				}
                for (var i = 0; i < yyfb.length; i++) {
                	$("#product").append("<li class=\"op-9\"><a style=\"background-color: rgba(255, 64, 95, 0.75)\" href=\"<%=base%>"+yyfb[i].url+"\" data-url=\"<%=base%>/tcenter/subject/index_tcenter.jsp\" onclick=\"jumpTool(this)\">"+yyfb[i].logo+"<span>"+yyfb[i].proName+"</span></a><p class=\"tx-center mg-y-5\">已开通</p></li>");
				}
                for (var i = 0; i < zyhj.length; i++) {
                	$("#product").append("<li class=\"op-9\"><a style=\"background-color: rgb(139, 195, 74)\" href=\"<%=base%>"+zyhj[i].url+"\" data-url=\"<%=base%>/tcenter/subject/index_tcenter.jsp\" onclick=\"jumpTool(this)\">"+zyhj[i].logo+"<span>"+zyhj[i].proName+"</span></a><p class=\"tx-center mg-y-5\">已开通</p></li>");
				}
                for (var i = 0; i < scgj.length; i++) {
                	$("#product").append("<li class=\"op-9\"><a style=\"background-color: rgba(37, 185, 255, 0.75)\" href=\"<%=base%>"+scgj[i].url+"\" data-url=\"<%=base%>/tcenter/subject/index_tcenter.jsp\" onclick=\"jumpTool(this)\">"+scgj[i].logo+"<span>"+scgj[i].proName+"</span></a><p class=\"tx-center mg-y-5\">已开通</p></li>");
				}
                $("#product").append("<li class=\"add-li\"><a href=\"<%=base%>/tcenter/company/product_index.jsp\"><i class=\"fa fa-plus tx-30\"></i></a></li>");
                
            }
        });
    });

</script>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">
<div class="br-logo">
    <a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
        <img class="ht-100p" src="../img/2019/system_logo.png">
    </a>
</div>

<div class="br-sideleft overflow-y-auto">
    <label class="sidebar-label pd-x-15 mg-t-20 pd-sm-x-10"></label>
    <div class="br-sideleft-menu">

        <a href="../company/main.jsp" class="br-menu-link active menu-home">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-home tx-22"></i>
                <span class="menu-item-label">概览</span>
            </div>
            <!-- menu-item -->
        </a>
        <a href="../user/company_user_index.jsp" class="br-menu-link menu-users">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-users tx-20"></i>
                <span class="menu-item-label">用户管理</span>
            </div>
        </a>
        <a href="../company/document_index.jsp" class="br-menu-link menu-channel">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-file-text-o tx-20"></i>
                <span class="menu-item-label">全部稿件</span>
            </div>
        </a>
        <a href="../company/approve_index.jsp" class="br-menu-link menu-channel">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-file-excel-o tx-22-force"></i>
                <span class="menu-item-label">全部审核</span>
            </div>
        </a>
        <a href="../company/xuanti_index.jsp" class="br-menu-link menu-xuanti">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-check-square-o tx-22"></i>
                <span class="menu-item-label">全部选题</span>
            </div>
        </a>
        <a href="../company/renwu_index.jsp" class="br-menu-link menu-task">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-th-list tx-22-force"></i>
                <span class="menu-item-label">全部任务</span>
            </div>
        </a>
        <a href="../company/shipin_index.jsp" class="br-menu-link menu-video">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-youtube-play tx-20"></i>
                <span class="menu-item-label">全部视频</span>
            </div>
        </a>
        <a href="wo_index.jsp" class="br-menu-link menu-wo">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-play-circle-o tx-22-force"></i>
                <span class="menu-item-label">工单管理</span>
            </div>
        </a>
        <a href="product_index.jsp" class="br-menu-link menu-channel">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-th-large tx-22-force"></i>
                <span class="menu-item-label">产品管理</span>
            </div>
        </a>
    </div>
    <!-- br-sideleft-menu -->
</div>
<!-- br-sideleft -->

<div class="br-header">
    <div class="br-header-left">
        <div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
        <div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
        <div class="hidden-md-down system-name"><a href="javascript:;"><i class=""></i><%=company1.getName()%></a></div>
    </div>
    <!-- br-header-left -->
    <script language=javascript>var navi_menu = "运营支撑";</script>
   <%@include file="../include/header_navigate.jsp"%><!--静态包含-->
    
</div>
<!-- br-header -->

<!-- ########## START: MAIN PANEL ########## -->
<div class="br-mainpanel with-first-nav">
    <div class="d-flex pd-30 pd-t-20 pd-b-15-force ">
        <div class="">
            <h4 class="tx-gray-800 mg-b-5">概览</h4>
        </div>
    </div>
    <div class="br-pagebody mg-t-5 pd-x-30 " id="zh_gailan">
        <div class="row row-sm">
            <div class="col-sm-6 col-xl-2 mg-b-20">
                <div class="bg-info rounded overflow-hidden zh_bg_item tx-white">
                    <div class="pd-15 d-flex align-items-center justify-content-center flex-column">
                        <div class="img-box">
                            <img src="/tcenter/img/2019/tide_user.png" />
                        </div>
                        <span class="zh_name mg-t-2"><%=company1.getName()%></span>
                        <span class="zh_welcome tx-12 mg-t-10">欢迎进入tcenter</span>
                        <span class="zh_last_login_time tx-12 mg-t-5">上次登录时间：<%=userinfo_session.getLastLoginDate().replace(".0","")%></span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-2 mg-b-20">
                <div class="bg-danger rounded overflow-hidden zh_bg_item tx-white">
                    <div class="pd-15 d-flex align-items-center justify-content-between flex-column zh_bg_item_container">
                        <div class="zh_gdtj">工单统计</div>
                        <span class="zh_gdtj_num mg-t-2" id="jobCount"></span>
                        <span class="zh_gdtj_today_num tx-12 mg-t-5" id="todayJobCount">今日提交工单：0</span>
                    </div>
                    <div class="zh_enter">
                        <a href="/tcenter/company/wo_index.jsp" class="tx-white tx-24" title="进入"><i class="fa fa-sign-in"></i></a>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-2 mg-b-20">
                <div class="bg-warning rounded overflow-hidden zh_bg_item tx-white">
                    <div class="pd-15 d-flex align-items-center justify-content-between flex-column zh_bg_item_container">
                        <div class="zh_gdtj">发稿量统计</div>
                        <span class="zh_gdtj_num mg-t-2" id="publishCount"></span>
                        <span class="zh_gdtj_today_num tx-12 mg-t-5" id="todayCount"></span>
                    </div>
                    <div class="zh_enter">
                        <a href="/tcenter/company/document_index.jsp" class="tx-white tx-24" title="进入"><i class="fa fa-sign-in"></i></a>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-2 mg-b-20">
                <div class="bg-teal rounded overflow-hidden zh_bg_item tx-white">
                    <div class="pd-15 d-flex align-items-center justify-content-between flex-column zh_bg_item_container">
                        <div class="zh_gdtj">待审核总量</div>
                        <span class="zh_gdtj_num mg-t-2" id="notSolveCount"></span>
                        <span class="zh_gdtj_today_num tx-12 mg-t-5">今日待审量：0</span>
                    </div>
                    <div class="zh_enter">
                        <a href="/tcenter/company/approve_index.jsp" class="tx-white tx-24" title="进入"><i class="fa fa-sign-in"></i></a>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-2 mg-b-20">
                <div class="bg-purple rounded overflow-hidden zh_bg_item tx-white">
                    <div class="pd-15 d-flex align-items-center justify-content-between flex-column zh_bg_item_container">
                        <div class="zh_gdtj">用户数量</div>
                        <span class="zh_gdtj_num mg-t-2" id="userCount"></span>
                        <span class="zh_gdtj_today_num tx-12 mg-t-5"> </span>
                    </div>
                    <div class="zh_enter">
                        <a href="/tcenter/user/company_user_index.jsp" class="tx-white tx-24" title="进入"><i class="fa fa-sign-in"></i></a>
                    </div>
                </div>
            </div>

        </div>
        <!-- row -->
        <div class="bg-white pd-15 rounded-5">
            <div class=" pd-x-0 pd-media pd-b-10">
                <h4 class="tx-gray-800 mg-b-15 tx-18">产品应用</h4>
                <div class="product-tool-box">
                    <ul class="tool" id = "product">
                        <!-- <li class="op-9"><a href="javascript:;" data-url="http://123.56.71.230:889/tcenter/subject/index_tcenter.jsp" onclick="jumpTool(this)"><i class="fa fa-check-square-o"></i><span>选题任务</span></a><p class="tx-center mg-y-5">已开通</p></li> -->
                        

                        
                    </ul>
                </div>
            </div>
        </div>

        <div class="row row-sm mg-t-20">
            <div class="col-sm-6 col-xl-3" id="video-use">
                <div class="bg-white rounded overflow-hidden">
                    <div class="pd-25 d-flex align-items-center">
                        <i class="fa fa-video-camera tx-50 lh-0 tx-warning"></i>
                        <span class="column-1px"></span>
                        <div class="mg-l-10">
                            <p class="tx-14 tx-spacing-1 tx-mont tx-medium tx-black tx-uppercase mg-b-10 op-7">视频使用空间</p>
                            <p class="tx-26 tx-lato tx-bold tx-black mg-b-2 lh-1" id="video-use-p"></p>
                        </div>
                    </div>
                </div>
            </div>
            <!-- col-3 -->
            <div class="col-sm-6 col-xl-3 mg-t-20 mg-sm-t-0" id="img-use">
                <div class="bg-white rounded overflow-hidden">
                    <div class="pd-25 d-flex align-items-center">
                        <i class="fa fa-picture-o tx-50 lh-0 tx-teal"></i>
                        <span class="column-1px"></span>
                        <div class="mg-l-10 ">
                            <p class="tx-14 tx-spacing-1 tx-mont tx-medium tx-black tx-uppercase mg-b-10 op-7">图片使用空间</p>
                            <p class="tx-26 tx-lato tx-bold tx-black mg-b-2 lh-1" id="img-use-p"></p>
                        </div>
                    </div>
                </div>
            </div>
            <!-- col-3 -->
            <div class="col-sm-6 col-xl-3 mg-t-20 mg-xl-t-0" id="file-use">
                <div class="bg-white rounded overflow-hidden">
                    <div class="pd-25 d-flex align-items-center">
                        <i class="fa fa-file tx-50 lh-0 tx-danger"></i>
                        <span class="column-1px"></span>
                        <div class="mg-l-10">
                            <p class="tx-14 tx-spacing-1 tx-mont tx-medium tx-black tx-uppercase mg-b-10 op-7">文件使用空间</p>
                            <p class="tx-26 tx-lato tx-bold tx-black mg-b-2 lh-1" id="file-use-p"></p>
                        </div>
                    </div>
                </div>
            </div>
            <!-- col-3 -->
            <div class="col-sm-6 col-xl-3 mg-t-20 mg-xl-t-0" id="total-use">
                <div class="bg-white rounded overflow-hidden">
                    <div class="pd-25 d-flex align-items-center">
                        <i class="fa fa-pie-chart tx-50 lh-0 tx-info"></i>
                        <span class="column-1px"></span>
                        <div class="mg-l-10">
                            <p class="tx-14 tx-spacing-1 tx-mont tx-medium tx-black tx-uppercase mg-b-10 op-7">已使用/<span class="tx-10">总空间</span> </p>
                            <p class="tx-26 tx-lato tx-bold tx-black mg-b-2 lh-1" id="total-use-p"></p>
                        </div>
                    </div>
                </div>
            </div>
            <!-- col-3 -->
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
                        	TableUtil tu = new TableUtil("user");
							String sql = "select id,Role,LastLoginDate,Name from userinfo where company="+companyid;
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
							<td class="pd-l-0-force wd-5p">
								<img src="/tcenter/tcenter/img/2018/logo_mob.png" class="wd-40 rounded-circle" alt="">
							</td>
							<td>
								<h6 class="tx-inverse tx-14 mg-b-0"><%=Name%></h6>
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
                <iframe class="wd-100p"  src="/tcenter/tcenter/include/usehelp.html" class="height"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
            </div>
            <!-- col-3 -->
        </div>
        <!-- row -->
    </div>

</div>
<!-- br-mainpanel -->
<!-- ########## END: MAIN PANEL ########## -->
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../common/2018/bracket.js"></script>

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

</script>
</body>
</html>
