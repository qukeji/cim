<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				java.util.*,
				java.sql.*,
				org.json.*"%>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="tidemedia.cms.util.TideJson" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	if(!userinfo_session.isAdministrator())
	{ response.sendRedirect("../noperm.jsp");return;}
	int companyid = userinfo_session.getCompany();//租户id
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="renderer" content="webkit">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="noindex, nofollow">
	<link rel="Shortcut Icon" href="../<%=ico%>">
	<title><%=title_%></title>
	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
	<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
	<link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
	<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
	<!-- Bracket CSS -->
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	<link rel="stylesheet" href="../style/2018/login_tcenter.css">
	<link rel="stylesheet" href="../tcenter/style/theme/theme.css">
	<style>
		.collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
		
		html,body{width: 100%;height: 100%;}
		ul li .fa{font-size: 30px}
		.cursor-pointer{
			cursor: pointer;
			color:#0866c6;
		}
		#display-select .config-box ul li.not a{
		   position:relative;
		}
		#display-select .config-box ul li.not a:after{
		   content:"";
		   width:100%;
		   height:100%;
		   background:rgba(0,0,0,0.3);
		   position:absolute;
		   left:0;
		   top:0;
		}
	</style>

	<script src="../lib/2018/jquery/jquery.js"></script>
	<script type="text/javascript" src="../common/2018/common2018.js"></script>

	<script>
		$(function () {
			var companyId={"companyid":<%=companyid%>}
			$.ajax({
				type : "post",
				url : '<%=request.getContextPath()%>/company/request/product',
				data :companyId,
				dataType:"json",
				success : function(data) {
					//console.log(data)
					var yyzc = data.yyzc;
					var yyfb = data.yyfb;
					var zyhj = data.zyhj;
					var scgj = data.scgj;
					//运营支撑
					for(var i = 1;i<yyzc.length;i++){
						if(yyzc[i].flag==1){//已开通
							$("#group1").append("<li class=\"op-9\" pid=" + yyzc[i].pid+ "><a href=\"javascript:;\">"+yyzc[i].logo+"<span>"+yyzc[i].Name+"</span></a><span>已开通</span></li>");
						}
					}
					for(var i = 1;i<yyzc.length;i++){
						if(yyzc[i].flag==2){//开通中
							$("#group1").append("<li class=\"op-9 not\" pid=" + yyzc[i].pid+ "><a href=\"javascript:;\">"+yyzc[i].logo+"<span>"+yyzc[i].Name+"</span></a><span class=\"cursor-pointer\">开通中</span></li>");
						}
					}
					for(var i = 1;i<yyzc.length;i++){//未开通
						if(yyzc[i].flag==0){
							$("#group1").append("<li onclick=\"applyOpen("+yyzc[i].pid+")\" class=\"op-9 not\" pid=" + yyzc[i].pid+ "><a href=\"javascript:;\">"+yyzc[i].logo+"<span>"+yyzc[i].Name+"</span></a><span class=\"cursor-pointer\" >申请开通</span></li>");
						}
					}
					//应用发布
					for(var i = 1;i<yyfb.length;i++){
						if(yyfb[i].flag==1){//已开通
							$("#group2").append("<li class=\"op-9\" pid=" + yyfb[i].pid+ "><a href=\"javascript:;\">"+yyfb[i].logo+"<span>"+yyfb[i].Name+"</span></a><span>已开通</span></li>");
						}
					}
					for(var i = 1;i<yyfb.length;i++){
						if(yyfb[i].flag==2){//开通中
							$("#group2").append("<li class=\"op-9 not\" pid=" + yyfb[i].pid+ "><a href=\"javascript:;\">"+yyfb[i].logo+"<span>"+yyfb[i].Name+"</span></a><span class=\"cursor-pointer\">开通中</span></li>");
						}
					}
					for(var i = 1;i<yyfb.length;i++){//未开通
						if(yyfb[i].flag==0){
							$("#group2").append("<li onclick=\"applyOpen("+yyfb[i].pid+")\" class=\"op-9 not\" pid=" + yyfb[i].pid+ "><a href=\"javascript:;\">"+yyfb[i].logo+"<span>"+yyfb[i].Name+"</span></a><span class=\"cursor-pointer\" >申请开通</span></li>");
						}
					}
					//资源汇聚
					for(var i = 1;i<zyhj.length;i++){
						if(zyhj[i].flag==1){//已开通
							$("#group3").append("<li class=\"op-9\" pid=" + zyhj[i].pid+ "><a href=\"javascript:;\">"+zyhj[i].logo+"<span>"+zyhj[i].Name+"</span></a><span>已开通</span></li>");
						}
					}
					for(var i = 1;i<zyhj.length;i++){
						if(zyhj[i].flag==2){//开通中
							$("#group3").append("<li class=\"op-9 not\" pid=" + zyhj[i].pid+ "><a href=\"javascript:;\">"+zyhj[i].logo+"<span>"+zyhj[i].Name+"</span></a><span class=\"cursor-pointer\">开通中</span></li>");
						}
					}
					for(var i = 1;i<zyhj.length;i++){//未开通
						if(zyhj[i].flag==0){
							$("#group3").append("<li onclick=\"applyOpen("+zyhj[i].pid+")\" class=\"op-9 not\" pid=" + zyhj[i].pid+ "><a href=\"javascript:;\">"+zyhj[i].logo+"<span>"+zyhj[i].Name+"</span></a><span class=\"cursor-pointer\" >申请开通</span></li>");
						}
					}
					//生产工具
					for(var i = 1;i<scgj.length;i++){
						if(scgj[i].flag==1){//已开通
							$("#group4").append("<li class=\"op-9\" pid=" + scgj[i].pid+ "><a href=\"javascript:;\">"+scgj[i].logo+"<span>"+scgj[i].Name+"</span></a><span>已开通</span></li>");
						}
					}
					for(var i = 1;i<scgj.length;i++){
						if(scgj[i].flag==2){//开通中
							$("#group4").append("<li class=\"op-9 not\" pid=" + scgj[i].pid+ "><a href=\"javascript:;\">"+scgj[i].logo+"<span>"+scgj[i].Name+"</span></a><span class=\"cursor-pointer\">开通中</span></li>");
						}
					}
					for(var i = 1;i<scgj.length;i++){//未开通
						if(scgj[i].flag==0){
							$("#group4").append("<li onclick=\"applyOpen("+scgj[i].pid+")\" class=\"op-9 not\" pid=" + scgj[i].pid+ "><a href=\"javascript:;\">"+scgj[i].logo+"<span>"+scgj[i].Name+"</span></a><span class=\"cursor-pointer\" >申请开通</span></li>");
						}
					}
				}
			});
		});
		function applyOpen(pid)
		{
			var	dialog = new top.TideDialog();
			dialog.setWidth(400);
			dialog.setHeight(300);
			dialog.setUrl("product_request.jsp?id="+pid);
			dialog.setTitle("申请开通");
			dialog.show();
		}
	</script>


</head>
<body class="collapsed-menu email" id="display-select">
<div class=" br-mainpanel br-mainpanel-file ">
	<div class="br-pageheader pd-y-15 pd-md-l-20">
		<nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">
			产品管理
		  </span>
		</nav>
	</div><!-- br-pageheader -->
	<div class="br-pagebody bg-white mg-t-0">
		<div class="config-box yyzc">
			<div class="pd-x-10 tx-16 pd-y-30">运营支撑</div>
			<ul id="group1">
			</ul>
		</div>

		<div class="config-box yyfb">
			<div class="pd-x-10 tx-16 pd-y-10">应用发布</div>
			<ul id="group2">
			</ul>
		</div>

		<div class="config-box zyhj">
			<div class="pd-x-10 tx-16 pd-y-10">资源汇聚</div>
			<ul id="group3">
			</ul>
		</div>

		<div class="config-box scgj">
			<div class="pd-x-10 tx-16 pd-y-10">生产工具</div>
			<ul id="group4">
			</ul>
		</div>
  
</div>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script src="../common/2018/bracket.js"></script>
</body>
</html>
