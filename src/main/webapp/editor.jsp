<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
String copyright = CmsCache.getParameter("copyright").getContent();
String background_image = CmsCache.getParameter("background_image").getContent();
String logo_image = CmsCache.getParameter("logo_image").getContent();
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
<title><%=title_main%></title>
<!-- vendor css -->
<link href="lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<!-- Bracket CSS -->
<link rel="stylesheet" href="style/2018/bracket.css">
<link rel="stylesheet" href="style/2018/common.css">
<link rel="stylesheet" href="style/2018/login.css">
<link rel="stylesheet" href="style/2018/animate.min.css">
</head>

<style>
	.mg-t-200{margin-top:200px}
	.login_in_menu_box ul li a  {font-size: 16px;}
	.login_in_menu_box ul li a .fa {font-size: 36px;}
	.login_in_menu_box ul li{width:120px;height:120px;}
	.login_in_menu_box ul li a{width:120px;height:120px;}
</style>

<body class="bg-br-primary">

	<div class="login">
		<div class="login-top">
  			<div class="logo">
  			    <img src="img/2019/<%=logo_image%>">
  			</div>
  			<div class="login_out tx-white">
  				<i class="fa fa-user-circle-o tx-26 mg-r-10"></i>
  				<span><%=userinfo_session.getName()%>，你好</span> 
  				<a href="media_help.html" target="_blank" title="帮助中心" class="valign-middle tx-gray-900 mg-l-10"><i class="icon ion-help-circled tx-18 tx-white"></i></a>
  				<span class="mg-x-8">|</span>
  				<a href="logout.jsp" class="tx-white">退出</a>
  			</div>
  		</div>  
		
		<div class="login-mid d-flex justify-content-start">
	    	<div class="wd-lg-1000">
		    	<div class="login_in_menu_box wd-lg-1000 mg-t-200">
					<div class="row  tx-white mg-x-0-force">
		    			<div class=" scgj wd-100p ">
		    				<ul class="wd-100p d-flex justify-content-between ">
		    				    <li class="op-9">
		    						<a href="/tcenter/collect/Index2018.jsp">		    							
										<i class="fa fa fa-binoculars"></i>
		    							<span>线索</span>
		    						</a>
		    					</li>		    				    
		    				    <li class="op-9">
		    						<a href="/tcenter/task/Index2018.jsp">		    							
										<i class="fa fa-check-square-o "></i>
		    							<span>选题</span>
		    						</a>
		    					</li>		    				    
		    				    <li class="op-9">
		    						<a href="/vms/lib/webIndex.jsp?channelid=8800">		    							
										<i class="fa fa-database"></i>
		    							<span>媒资</span>
		    						</a>
		    					</li>
		    				    <li class="op-9">
		    						<a href="/tcenter/shengao/Index2018.jsp">		    							
										<i class="fa fa-folder-open "></i>
		    							<span>文稿</span>
		    						</a>
		    					</li>
		    				    <li class="op-9">
		    						<a href="/tcenter/app/appIndex2018.jsp?childGroup=1">		    							
										<i class="fa fa-tablet tx-40"></i>
		    							<span>APP</span>
		    						</a>
		    					</li>
		    				    <li class="op-9">
		    						<a href="/tcenter/web/lib_webIndex.jsp">		    							
										<i class="fa fa-laptop tx-40"></i>
		    							<span>网站</span>
		    						</a>
		    					</li>		    				    
		    				</ul>
		    			</div>
		    		</div>
		    	</div>
	    	</div>
		</div><!-- d-flex -->

	    <div class="login_footer index-login_footer tx-14 tx-white">
	    	<%=copyright%>
	    </div>
    </div>
</body>    
<script src="lib/2018/jquery/jquery.js"></script>   
<script src="lib/2018/popper.js/popper.js"></script>
<script src="lib/2018/bootstrap/bootstrap.js"></script>
<script src="common/jquery.anystretch.min.js"></script>
<script src="common/2018/common2018.js"></script>
<script src="common/2018/TideDialog2018.js"></script>
<script>
	$(".login").anystretch("<%=background_image%>");
</script>
</html>
