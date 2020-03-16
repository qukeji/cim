<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.util.Date,
				tidemedia.cms.user.*"%>
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

String dir = request.getServletPath().substring(1,request.getServletPath().lastIndexOf("/"));
String system_logo = CmsCache.getParameter("system_logo").getContent();
%>
<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../<%=ico%>">
<title><%=title_%></title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

<!--<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">-->

<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/sidebar-menu-channel.css">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/2018/theme.css">

<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>

<script language=javascript>
var dir = "site";

function init()
{	
	window.status="当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
//	window.onresize=reSize;
//	reSize();

//	if (jQuery.browser.msie) {
//		var version=parseInt(jQuery.browser.version);
//		if(version==6){
//			alert("你当前使用的浏览器是IE6,请升级你的浏览器!");
//		}
//	}

	set_main_class("index");
	<%if(diff<10*24*3600){%>
		tidecms.dialog("../system/license_notify.jsp", 500, 300, "许可证到期提醒", 2);
	<%}%>
}

function reSize() {
	document.getElementById("main").style.height = Math.max(document.body.clientHeight - document.getElementById("main").offsetTop, 0) + "px";
}
function set_main_class(str){
	jQuery('.header_menu  li').removeClass('on');
	jQuery('#home_'+str).addClass('on');
}
 

function feed()
{
	title='反馈'
	url="http://123.125.148.3:888/cms/feedback.jsp";
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle(title);
		dialog.show();
};
</script>
</head>

<body class="collapsed-menu email" id="withSecondNav" onLoad="init();">

   <div class="br-logo">
	<a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
	   <img class="ht-100p" src="../img/2019/<%=system_logo%>">
	</a>
    </div>

	<%@include file="../tcenter/include/tree.jsp"%><!--静态包含-->

	<%@include file="../tcenter/include/header.jsp"%><!--静态包含-->

	<div class="br-subleft br-subleft-file">
        <div class="sidebar-menu-box ht-100p-force">
			<ul class="sidebar-menu">	  	  

			</ul>
		</div>
    </div><!-- br-subleft -->

    <!-- ########## START: MAIN PANEL ########## -->
    <div class="br-mainpanel with-second-nav br-mainpanel-file " id="js-source">
        <iframe src="site2018.jsp?id=53" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
    </div><!-- br-mainpanel -->
	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	
	<!--<script src="../lib/2018/select2/js/select2.min.js"></script>-->

	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/sidebar-menu-channel.js"></script>

	<script>
        $(function(){
			'use strict';
            $("#system-menu-site").addClass("active");
			$("#system-menu-cms-site").addClass("active");
			//show only the icons and hide left menu label by default
			$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
        
			$(document).on('mouseover', function(e){
			  e.stopPropagation();
			  if($('body').hasClass('collapsed-menu')) {
				var targ = $(e.target).closest('.br-sideleft').length;
				if(targ) {
				  $('body').addClass('expand-menu');

				  // show current shown sub menu that was hidden from collapsed
				  // $('.show-sub + .br-menu-sub').slideDown();

				  var menuText = $('.menu-item-label,.menu-item-arrow');
				  menuText.removeClass('d-lg-none');
				  menuText.removeClass('op-lg-0-force');
                  menuText.css({
                      "display":"block",
                      "opacity":"1"
                  })
                  $("#system-menu-site").css("display","block");
				} else {
				  $('body').removeClass('expand-menu');

				  // hide current shown menu
				  $('.show-sub + .br-menu-sub').slideUp();
                  
				  var menuText = $('.menu-item-label,.menu-item-arrow');
				  menuText.addClass('op-lg-0-force');
				  menuText.addClass('d-lg-none');
				  
				  $("#system-menu-site").css("display","none");
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
        
			$("#js-source-table tr:gt(0)").click(function () {     
		        console.log($(this).find(":checkbox").prop("checked"))    
		        if ($(this).find(":checkbox").prop("checked"))// 此处要用prop不能用attr，至于为什么你测试一下就知道了。    
		        {    
		            $(this).find(":checkbox").removeAttr("checked");    
		            // $(this).find(":checkbox").attr("checked", 'false');     
		        }    
		        else    
		        {    
		            $(this).find(":checkbox").prop("checked", true);    
		        }     
		    }); 

//=========================================================================================
            loadSite() //加载站点
			
		});
		
        function loadSite(){
        	var url="tree2018.jsp";
			$.ajax({type:"GET",dataType:"json",url:url,success: function(json){
				var menu = $('.sidebar-menu').html("");
				for(var i=0;i<json.length;i++){
					var html = '';
					if(json[i].child && json[i].child.length>0)
					{
						html = '<li class="treeview active">';
					}
					else
					{
						if(i==0){
							html = '<li class="active">';
						}else{
							html = '<li >';
						}
					}
					if( json[i].load==1 || (json[i].child!=null && json[i].child.length>0) ){
					   html += '<a href="#" load="'+json[i].load+'" siteid="'+json[i].id+'" load="'+json[i].load+'"><i class="fa fisrtNav fa-home " have="1" ></i><span>'+json[i].name+'</span>';
				    }else{
						 html += '<a href="#" load="'+json[i].load+'" siteid="'+json[i].id+'" load="'+json[i].load+'"><i class="fa fisrtNav fa-home " have="0" ></i><span>'+json[i].name+'</span>';   
					}	   
					if(json[i].load==1||(json[i].child && json[i].child.length>0)){//说明有子频道
						html += '<i class="fa fa-angle-right pull-right"></i>';
					}
					html += '</a></li>';

					menu.append(html);
					
				}

				activeFn();
			
				//多级导航自定义
				$.sidebarMenu(menu);
			}});
        }

		function activeFn(){
        	var timer = setInterval(function(){
        		if($(".sidebar-menu li.active a:first")){
        			var activeChannel = $(".sidebar-menu li.active a:first");
					try {
						activeChannel[0].click();
					}catch(err) {
					}
					clearInterval(timer)
        		}
        	},20)       	
        }
        
        function reLoadNav(obj){
			console.log(obj);
			if(obj.site){  //如果是操作站点
				loadSite();
				return ;
			}        
        }
//========================================================================
		$.sidebarMenu = function(menu) {
			var animationSpeed = 300;
		  
			$(menu).on('click', 'li a', function(e) {
				var $this = $(this);
				var checkElement = $this.next();
				var siteid = $this.attr("siteid");//频道编号

				sidebarMenu_show(checkElement,animationSpeed,$this);

				//内容显示
				changeFrameSrc( window.frames["content_frame"] , "../system/site2018.jsp?id="+siteid )					
				
			});
		}	
    </script>
</body>
</html>
