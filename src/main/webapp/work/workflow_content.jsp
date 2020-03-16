<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.base.*,
                tidemedia.cms.util.*,
                tidemedia.cms.user.*,
                java.util.Date,
                java.text.DecimalFormat,
                java.text.SimpleDateFormat,
                java.util.*,
                java.sql.*,
                org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
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
    String system_logo = CmsCache.getParameter("system_logo").getContent();
    int   userinfo_sessionid=userinfo_session.getId();
    TideJson  tidejson = CmsCache.getParameter("personal_workbench").getJson();
    JSONArray jsonarr = tidejson.getJSONArray("urlarr");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="renderer" content="webkit">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="robots" content="noindex, nofollow">
		<link rel="Shortcut Icon" href="<%=ico%>">
		<title><%=title_%></title>

		<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
		<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
		<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
		<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
		<link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
		<link rel="stylesheet" href="../style/2018/bracket.css">
		<link rel="stylesheet" href="../style/2018/common.css">
		<!-- workstate -->
		<link rel="stylesheet" href="../style/2018/workflow.css">
		<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
		<script type="text/javascript" src="../common/2018/common2018.js"></script>
		<script type="text/javascript" src="../common/2018/content.js"></script>
		<script>
			var  listType = "";
			var  userid = <%=userinfo_sessionid%> ;
		</script>
	</head>

	<body class="collapsed-menu email" id="js-source">

		<!-- ########## START: MAIN PANEL ########## -->
		<div class="br-mainpanel with-first-nav pd-b-30 mg-l-0-force mg-t-0-force">
			
			<div class="br-pagebody mg-t-20 pd-x-30">
				
				<div class="row row-sm">
					<div class="col-sm-2">
						<div class="flowitem flowitem1 rounded-5" id="xiansuo">
							<div class="workflow-top rounded-5 mg-b-10">
								<div class="tx-14 pd-x-12 ht-40 d-flex justify-content-between align-items-center">
									<span class="tx-16 tx-white d-flex align-items-center">
										<i class="fa fa-feed mg-r-10 tx-22"></i>线索
									</span>
									<span class="tx-22">
										<i class="fa fa-refresh cursor-pointer" onclick="refresh(0)"></i>
									</span>
								</div>
								<div class="flow-triangle flow-triangle1"></div>
							</div>
							<div class="pd-b-15 flow-box">
								<div class="flow-list">
									
									
								</div>
							</div>
						
						</div>
					</div>

					<div class="col-sm-2">
						<div class="flowitem flowitem2 rounded-5" id="xuanti">
							<div class="workflow-top rounded-5 mg-b-10">
								<div class="tx-14 pd-x-12 ht-40 d-flex justify-content-between align-items-center">
									<span class="tx-16 tx-white d-flex align-items-center"><i class="fa fa-check-square-o mg-r-10 tx-22"></i>选题</span>
									<span class="tx-22"><i class="fa fa-refresh cursor-pointer" onclick="refresh(1)"></i></span>
								</div>
								<div class="flow-triangle flow-triangle2"></div>
							</div>
							<div class="pd-b-15 flow-box">
								<div class="flow-list">
									
								</div>
							</div>
						</div>
					
					</div>
					<div class="col-sm-2">
						<div class="flowitem flowitem3 rounded-5" id="mytask">
							<div class="workflow-top rounded-5 mg-b-10">
								<div class="tx-14 pd-x-12 ht-40 d-flex justify-content-between align-items-center">
									<span class="tx-16 tx-white d-flex align-items-center"><i class="fa fa-tasks mg-r-10 tx-22"></i>任务</span>
									<span class="tx-22"><i class="fa fa-refresh cursor-pointer" onclick="refresh(2)"></i></span>
								</div>
								<div class="flow-triangle flow-triangle3"></div>
							</div>
							<div class="pd-b-15 flow-box">
								<div class="flow-list">
									
								</div>
							</div>
						</div>
					
					</div>
					<div class="col-sm-2">
						<div class="flowitem flowitem4 rounded-5" id="produce">
							<div class="workflow-top rounded-5 mg-b-10">
								<div class="tx-14 pd-x-12 ht-40 d-flex justify-content-between align-items-center">
									<span class="tx-16 tx-white d-flex align-items-center"><i class="fa fa-file-text-o mg-r-10 tx-22"></i>生产</span>
									<span class="tx-22"><i class="fa fa-refresh cursor-pointer" onclick="refresh(3)"></i></span>
								</div>
								<div class="flow-triangle flow-triangle4"></div>
							</div>
							<div class="pd-b-15 flow-box">
								<div class="flow-list">
									
								</div>
							</div>
						</div>
					
					</div>
					<div class="col-sm-2">
						<div class="flowitem flowitem5 rounded-5" id="publish">
							<div class="workflow-top rounded-5 mg-b-10">
								<div class="tx-14 pd-x-12 ht-40 d-flex justify-content-between align-items-center">
									<span class="tx-16 tx-white d-flex align-items-center"><i class="fa fa-send mg-r-10 tx-22"></i>发布</span>
									<span class="tx-22"><i class="fa fa-refresh cursor-pointer" onclick="refresh(4)"></i></span>
								</div>
								<div class="flow-triangle flow-triangle5"></div>
							</div>
							<div class="pd-b-15 flow-box">
								<div class="flow-list">
									
								</div>
							</div>
						</div>
					
					</div>
					<div class="col-sm-2">
						<div class="flowitem flowitem6 rounded-5" id="effect">
							<div class="workflow-top rounded-5 mg-b-10">
								<div class="tx-14 pd-x-12 ht-40 d-flex justify-content-between align-items-center">
									<span class="tx-16 tx-white d-flex align-items-center"><i class="fa fa-line-chart mg-r-10 tx-22"></i>效果</span>
									<span class="tx-22"><i class="fa fa-refresh cursor-pointer" onclick="refresh(5)"></i></span>
								</div>
								<div class="flow-triangle flow-triangle6"></div>
							</div>
							<div class="pd-b-15 flow-box">
								<div class="flow-list">
									
								</div>
							</div>
						</div>
					
					</div>
				
				</div>
			</div>
		</div>
		<!-- br-mainpanel -->
		<!-- ########## END: MAIN PANEL ########## -->

		<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
		<script src="../lib/2018/popper.js/popper.js"></script>
		<script src="../lib/2018/bootstrap/bootstrap.js"></script>
		<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
		<script src="../lib/2018/moment/moment.js"></script>
		<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
		<script src="../lib/2018/peity/jquery.peity.js"></script>
        <script src="../lib/2018/chart.js/Chart.js"></script>
		<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
		<script src="../common/2018/TideDialog2018.js"></script>
		<script src="../common/2018/bracket.js"></script>
		<!-- workstate -->
		
		<script>
			$(function() {
				'use strict'
				$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

				$(document).on('mouseover', function(e) {
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
							menuText.css({
								"display": "block",
								"opacity": "1"
							})
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
				$(window).resize(function() {
					minimizeMenu();
				});
				minimizeMenu();
				function minimizeMenu() {
					if(window.matchMedia('(min-width: 992px)').matches && window.matchMedia('(max-width: 1299px)').matches) {
						// show only the icons and hide left menu label by default
						$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
						$('body').addClass('collapsed-menu');
						$('.show-sub + .br-menu-sub').slideUp();
					} else if(window.matchMedia('(min-width: 1300px)').matches && !$('body').hasClass('collapsed-menu')) {
						$('.menu-item-label,.menu-item-arrow').removeClass('op-lg-0-force d-lg-none');
						$('body').removeClass('collapsed-menu');
						$('.show-sub + .br-menu-sub').slideDown();
					}
				}
			})
		</script>
		<script src="http://jushi-yanshi.tidemedia.com/123/leader-line.min.js"></script>
		<script src="../common/2018/workflow.js"></script>
	</body>

</html>