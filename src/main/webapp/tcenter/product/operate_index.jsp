<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);

int Flag = getIntParameter(request,"Flag");
int ChannelID =  getIntParameter(request,"ChannelID");
String time = CmsCache.getExpiresDateStr();  
long current = System.currentTimeMillis();
time  = time.replaceAll("-","/");
Date date = new Date(time);
long ExpiresDate = date.getTime();
long diff = (ExpiresDate - current)/1000; //秒
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");
if(CmsCache.hasValidLicense()) diff = 1000000;

String dir="product";
String system_logo = CmsCache.getParameter("system_logo").getContent();

TideJson json = CmsCache.getParameter("tcenter_main").getJson();//首页模块
JSONArray arr = new JSONArray();
if(json!=null&&json.getInt("state")==1){
	arr = json.getJSONArray("main");
}
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
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/sidebar-menu-channel.css">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/theme/theme.css">

<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>

<script language=javascript>

var dir = "<%=dir%>";

function init()
{	
	window.status="当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
	set_main_class("index");
	<%if(diff<10*24*3600){%>
		tidecms.dialog("./system/license_notify.jsp",500,300,"许可证到期提醒",2);
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

	<%@include file="../../operate/include/tree.jsp"%><!--静态包含-->

	<%@include file="../../operate/include/header.jsp"%><!--静态包含-->

	<div class="br-subleft br-subleft-file">
        <div class="sidebar-menu-box ht-100p-force">
			<ul class="sidebar-menu">	  	  

			</ul>
		</div>
    </div><!-- br-subleft -->

    <!-- ########## START: MAIN PANEL ########## -->
    <div class="br-mainpanel with-second-nav br-mainpanel-file " id="js-source">
        <iframe src="product_list2018.jsp" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
    </div><!-- br-mainpanel -->
	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/sidebar-menu-channel.js"></script>

	<script>	

        $(function(){
			
			'use strict';
			
        	$("#menu-product").addClass("active");
        	// $("#system-menu-product").css("display","block");
			$("#system-menu-cms-product").addClass("active");
			
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
                  });
				  $("#system-menu-product").css("display","block");
				} else {
				  $('body').removeClass('expand-menu');

				  // hide current shown menu
				   $('.show-sub + .br-menu-sub').slideUp();

				  var menuText = $('.menu-item-label,.menu-item-arrow');
				  menuText.addClass('op-lg-0-force');
				  menuText.addClass('d-lg-none');
				  $("#system-menu-product").css("display","none");
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
		        }    
		        else    
		        {    
		            $(this).find(":checkbox").prop("checked", true);    
		        }     
		    }); 
//=============================================================================================================
		
			//二级菜单
			var arr = <%=arr%>;
			var menu = $('.sidebar-menu');
			var html = '<li><a href="javascript:;" channelid="" load="" cloud=""><i class="fa fisrtNav fa-home" have="1"></i><span>所有产品</span></a>';
			html += '<ul class="treeview-menu " style="display: block;">';
			html += '<li><a href="#" id="1"><i class="fa fisrtNav fa-home"></i><span>运营支撑</span></a></li>';
			html += '<li><a href="#" id="2"><i class="fa fisrtNav fa-home"></i><span>应用发布</span></a></li>';
			html += '<li><a href="#" id="3"><i class="fa fisrtNav fa-home"></i><span>资源汇聚</span></a></li>';
			html += '<li><a href="#" id="4"><i class="fa fisrtNav fa-home"></i><span>生产工具</span></a></li>';
			for(var i=0;i<arr.length;i++){
				var arr1 = arr[i].module;
				for(var j=0;j<arr1.length;j++){
					var title = arr1[j].title;
					var id = arr1[j].id ;
					html += '<li><a href="#" id="'+id+'"><i class="fa fisrtNav fa-home"></i><span>'+title+'</span></a></li>';
				}
			}
			
			html += '</ul></li>';
			menu.append(html);
			$(".sidebar-menu>li:first").addClass("active");

			//多级导航自定义
			$.sidebarMenu(menu);
		});
        
		function activeFn(){
			var timer = setInterval(function(){
				if($(".sidebar-menu li.active a:first")){
					var activeChannel = $(".sidebar-menu li.active a:first");
					//var activeChannelId  = $(".sidebar-menu li.active a:first").attr("channelid") ;
					activeChannel[0].click();
					clearInterval(timer)
				}
			},20)       	
		}
//===================================================================

		$.sidebarMenu = function(menu) {
			var animationSpeed = 300;
		  
			$(menu).on('click', 'li a', function(e) {

				var $this = $(this);
				var checkElement = $this.next();
				var id = $this.attr("id");

				sidebarMenu_show(checkElement,animationSpeed,$this);

				
				changeFrameSrc( window.frames["content_frame"] , "product_list2018.jsp?GroupID="+id );

				if (checkElement.is('.treeview-menu')) {
					e.preventDefault();
				}
			});
		}	
    </script>
</body>
</html>
