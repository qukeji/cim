<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%!
//获取资源数
public int getNum(String sql){

	int num = 0 ;
	try{
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(sql);
		if(Rs.next()) {
			num = Rs.getInt("num");
		}
		tu.closeRs(Rs);
	}catch(Exception e) {
		e.printStackTrace();			
	}
	return num ;

} 

%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);

int Flag = getIntParameter(request,"Flag");
String time = CmsCache.getExpiresDateStr();  
long current = System.currentTimeMillis();
time  = time.replaceAll("-","/");
Date date = new Date(time);
long ExpiresDate = date.getTime();
long diff = (ExpiresDate - current)/1000; //秒
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");
if(CmsCache.hasValidLicense()) diff = 1000000;

//查询站点总数
int sitenum = 0 ;
String sql= "select * from site";
TableUtil tu = new TableUtil();
ResultSet Rs = tu.executeQuery(sql);
while(Rs.next()) {
	if(Rs.getInt("id")==1){
		continue;
	}
	sitenum++; //= Rs.getInt("rowCount");
}
tu.closeRs(Rs);

//查询频道总数
sql = "select count(*) as num from channel";
int channelnum = getNum(sql);

//查询资源总数
//sql = "select count(*) as num from item_snap";
int count = tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,0,"","");//getNum(sql);
int countAudited = tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,2,"","");//getNum(sql);
int countUnaudited = tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,1,"","");//getNum(sql);

//今日新增
Calendar calendar = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
String nowDate = sdf.format(calendar.getTime());
//calendar.add(Calendar.DATE, +1);
//String  date1 = sdf.format(calendar.getTime());
long nowTime=Util.getFromTime(nowDate,"");
sql = "select count(*) as num from item_snap where Active=1 and CreateDate>="+nowTime+" and CreateDate<"+(nowTime+86400);
int count1 = getNum(sql);//tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,0,nowDate,date1);//

//7天数据
calendar.add(Calendar.DATE, -6);
String  date2= sdf.format(calendar.getTime());
long time2 = Util.getFromTime(date2,"");
sql = "select count(*) as num from item_snap where Active=1 and CreateDate>="+time2+" and CreateDate<"+(nowTime+86400);
int count2 = getNum(sql);//tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,0,date2,date1);//

//用户发稿量
sql = "select count(*) as num from item_snap where Active=1 and Status=1 and User="+userinfo_session.getId();
int count3 = getNum(sql);
//近24小时发稿量
int time1 = (int)(System.currentTimeMillis()/1000);
sql = "select count(*) as num from item_snap where Active=1 and Status=1 and User="+userinfo_session.getId()+" and PublishDate>="+(time1-86400)+" and PublishDate<"+time1;
int count4 = getNum(sql);
%>

<!DOCTYPE html>
<html id="appManage">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS 9.0</title>
    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
   
    <link rel="stylesheet" href="../style/2018/bracket.css">  
    <link rel="stylesheet" href="../style/2018/common.css">
    <link rel="stylesheet" href="../style/2018/tcenter.css">
    <link rel="stylesheet" href="../style/2018/theme.css">
      <style>
	.height{
        height:200px !important;
        width:100% !important;
    }
    </style>
    <script src="../lib/2018/jquery/jquery.js"></script>
  </head>
 
  <body class="collapsed-menu email content_pages">
   
    <div class="br-mainpanel br-mainpanel-file" id="">      
      
      	<div class="d-flex pd-30 ">
			<div class="td-logo theme-bg mg-r-10"><i class="tx-white fa fa-mobile tx-36"></i></div>
			<div class="">
				<h4 class="tx-gray-800 mg-b-5">网站管理</h4>
				<p class="mg-b-0">本系统用于构建全局多租户用户管理、接入产品的管理以及用户登录日志查看。</p>
			</div>
			
		</div>				
		
		<!-- d-flex -->
		<div class="br-pagebody mg-t-5 pd-x-30 ">
			<div class="row row-sm">
				<div class="col-sm-6 col-xl-3 mg-b-20">
					<div class="theme-bg rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-database tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">总内容数据量</p>
								<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1">	<%=count%></p>								
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-xl-3 mg-b-20 mg-sm-t-0">
					<div class="theme-bg-9 rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-file-text tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">今日新增内容</p>
								<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1"><%=count1%></p>								
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-xl-3 mg-b-20 mg-sm-t-0">
					<div class="theme-bg-8 rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-cloud-upload tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">当前用户发稿</p>
								<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1"><%=count3%></p>								
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-xl-3 mg-b-20 mg-sm-t-0">
					<div class="theme-bg-7 rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-line-chart tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">今日浏览量</p>
								<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 " id="main_pv1"></p>								
							</div>
						</div>
					</div>
				</div>	
			</div>
			<!-- row -->

			<div class="row row-sm mg-t-20">
				<div class="col-sm-12 col-xl-8">
					<div class="card pd-0 bd-0 shadow-base mg-b-20">
						<div class="pd-x-30 pd-t-30 pd-b-15">
							<div class="d-flex align-items-center justify-content-between">
								<div>
									<p class="tx-13 tx-uppercase tx-inverse tx-spacing-1 tx-18">
										<i class="fa fa-user-circle-o theme-tx-color mg-r-5"></i>媒体号排行
									</p>									
								</div>									
							</div>
						</div>
						<div class="pd-x-30 pd-b-40 pd-l-20" id="media-range">
							<ul class="">
								<li>
									<div class="user-info">
										<div class="img-box">
											<img src="../img/2018/logo_mob.png"/>
										</div>
										<div class="text-box">
											<div class="u-tl">江城第一帅</div>
											<div class="u-phone">18888888888</div>
										</div>										
									</div>
									<div class="xt-info">										
										<span class="xt-video"><i class="fa fa-video-camera"></i>234</span>
										<span class="xt-pics"><i class="fa fa-picture-o"></i>3444</span>
										<span class="xt-live"><i class="fa fa-play-circle-o"></i>333</span>
									</div>
									<div class="watch-num tx-12"><i class="fa fa-star tx-18"></i>关注人数：99999</div>								
								</li>
								<li>
									<div class="user-info">
										<div class="img-box">
											<img src="../img/2018/logo_mob.png"/>
										</div>
										<div class="text-box">
											<div class="u-tl">zzz</div>
											<div class="u-phone">18888888888</div>
										</div>										
									</div>
									<div class="xt-info">										
										<span class="xt-video"><i class="fa fa-video-camera"></i>3</span>
										<span class="xt-pics"><i class="fa fa-picture-o"></i>34444</span>
										<span class="xt-live"><i class="fa fa-play-circle-o"></i>3333</span>
									</div>
									<div class="watch-num tx-12"><i class="fa fa-star tx-18"></i>关注人数：99999</div>								
								</li>
								<li>
									<div class="user-info">
										<div class="img-box">
											<img src="../img/2018/logo_mob.png"/>
										</div>
										<div class="text-box">
											<div class="u-tl">zzz</div>
											<div class="u-phone">18888888888</div>
										</div>										
									</div>
									<div class="xt-info">
										<span class="xt-video"><i class="fa fa-video-camera"></i>2377</span>
										<span class="xt-pics"><i class="fa fa-picture-o"></i>344</span>
										<span class="xt-live"><i class="fa fa-play-circle-o"></i>339999</span>
									</div>
									<div class="watch-num tx-12"><i class="fa fa-star tx-18"></i>关注人数：99999</div>									
								</li>
								
							</ul>
						</div>
					</div>
					<!-- card -->
				</div>
				<!-- col-9 -->
				<div class="col-sm-12 col-xl-4">

		            <div class="card ">
		             
		              
		              	<%@include file="include/adress_daohang.html"%>
		             
		            </div>
		            
		            <div class="  bd-0 mg-t-20">			              
    			             <iframe  src="include/usehelp.html" class="height"  frameborder="0" onload="changeFrameHeight(this)" ></iframe>		              
			      </div>
				</div>
				<!-- col-3 -->
			</div>
			<!-- row -->
		</div>     

    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>   
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>  
	
    <script>
      $(function(){
        'use strict';

        //show only the icons and hide left menu label by default
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
        
        $(document).on('mouseover', function(e){
          e.stopPropagation();
          if($('body').hasClass('collapsed-menu')) {
            var targ = $(e.target).closest('.br-sideleft').length;
            if(targ) {
              $('body').addClass('expand-menu');

              // show current shown sub menu that was hidden from collapsed
              $('.show-sub + .br-menu-sub').slideDown();

              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.removeClass('d-lg-none');
              menuText.removeClass('op-lg-0-force');

            } else {
              $('body').removeClass('expand-menu');

              // hide current shown menu
              $('.show-sub + .br-menu-sub').slideUp();

              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.addClass('op-lg-0-force');
              menuText.addClass('d-lg-none');
            }
          }
        });

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function(e){
          e.preventDefault();
          if($('body').hasClass('show-mb-left')) {
            $('body').removeClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
          } else {
            $('body').addClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
          }
        });
         
  
      });
      
      //用户浏览量
     $(function()
    {
    	
    	$.ajax({
    		url:'../content/api_web_vister.jsp?id=15894',
    		data:'id=1',
    		type:'post',
    		dataType:'json',
    		success:function(data){
    		    console.log(data);
    			$("#main_pv1").html(data.pv1);
    			$("#main_pv2").html("最近7天PV "+data.pv2);
    		}
    	});
   	});
    </script>
   
   </body>
</html>
