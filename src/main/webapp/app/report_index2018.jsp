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
<html id="appManage">
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
<link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />

<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/sidebar-menu-channel.css">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/2018/tcenter.css">
<link rel="stylesheet" href="../style/2018/theme.css">

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script language=javascript>

var dir = "report";

$(function(){			
	var popTimer = null ;
	var updateTimer = null ;
	function updateManagerDate(){
		$.ajax({
			type: "get",
			url: "../system/manager_data.jsp?flag=6",
			success: function(msg){
				$(".pop-text").html(msg);
				var th = $(".pop-text").find("th:[scope=col]")
				th.parent("tr").remove();
			} 
		});
	}
	$(".frame_tool_c").mouseenter(function(){
                clearTimeout(updateTimer);
                clearTimeout(popTimer);		
		if( $(".pop-box").is(":hidden") ){
			updateManagerDate();
		}		
		updateTimer = setInterval(function(){
			updateManagerDate();
                        console.log(11)
		},3000)		
		$(".pop-box").fadeIn(100);
	}).mouseleave(function(){
		clearTimeout(updateTimer);
		popTimer = setTimeout(function(){
			$(".pop-box").fadeOut(100);
			clearTimeout(popTimer);			
		},200)   		
	})	    		
})
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

	<%@include file="include/tree.jsp"%><!--静态包含-->

	<%@include file="header.jsp"%><!--静态包含-->

	<div class="br-subleft br-subleft-file">
        <ul class="sidebar-menu">	  	  

		</ul>
    </div><!-- br-subleft -->

    <div class="br-mainpanel with-second-nav br-mainpanel-file " id="js-source">
        <iframe src="../report/report2018.jsp" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
    </div><!-- br-mainpanel -->

	<!--<script src="../lib/2018/jquery/jquery.js"></script>-->
	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<!--<script src="../lib/2018/peity/jquery.peity.js"></script>

	<script src="../lib/2018/datatables/jquery.dataTables.js"></script>
	<script src="../lib/2018/datatables-responsive/dataTables.responsive.js"></script>-->
	<script src="../lib/2018/select2/js/select2.min.js"></script>

	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/sidebar-menu-channel.js"></script>

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
                  menuText.css({
                      "display":"block",
                      "opacity":"1"
                  })
                  $("#system-menu").css("display","block");
				} else {
				  $('body').removeClass('expand-menu');

				  // hide current shown menu
				  $('.show-sub + .br-menu-sub').slideUp();

				  var menuText = $('.menu-item-label,.menu-item-arrow');
				  menuText.addClass('op-lg-0-force');
				  menuText.addClass('d-lg-none');
				  $("#system-menu").css("display","none");
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

//=========== 工作量统计管理==============================================================================

			var url="../report/tree2018.jsp";
			$.ajax({type:"GET",dataType:"json",url:url,success: function(json){
				var menu = $('.sidebar-menu');
				for(var i=0;i<json.length;i++){
					var html = '';
					if(json[i].child && json[i].child.length>0)
					{
						html = '<li class="treeview">';
					}
					else
					{
						html = '<li>';
					}
					if( json[i].load==1 || (json[i].child!=null && json[i].child.length>0) ){
					html += '<a href="#" load="'+json[i].load+'" SiteId="'+json[i].id+'" type="'+json[i].type+'"><i class="fa fisrtNav fa-home " have="1"></i> <span>'+json[i].name+'</span></a>';
                    }else{
				    html += '<a href="#" load="'+json[i].load+'" SiteId="'+json[i].id+'" type="'+json[i].type+'"><i class="fa fisrtNav fa-home " have="0"></i> <span>'+json[i].name+'</span></a>';
					}	 
					if(json[i].child && json[i].child.length>0)
					{
						html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
					}
					html += '</li>';
					menu.append(html);
				}
			
				//多级导航自定义
				$.sidebarMenu(menu);
			}});
		});

		function get_menu_html(json)
		{
			var html = "";
			if(json.child && json.child.length>0)
			{
				var json_ = json.child;
				for(var i=0;i<json_.length;i++){
					
					   html += '<li><a href="#" load="'+json_[i].load+'" SiteId="'+json_[i].id+'" type="'+json_[i].type+'">'
					if(json_[i].load==1||(json_[i].child && json_[i].child.length>0)){
					   html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
					 }else{
					   html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
					 }		 
					   html += '<span>'+json_[i].name+'</span></a>';
             
					if(json_[i].child && json_[i].child.length>0){
						html += '<ul class="treeview-menu">' + get_menu_html(json_[i]) + '</ul>';
					}
					html += '</li>';
				}
			}
			return html;
		 }
//========================================================================
		$.sidebarMenu = function(menu) {
			var animationSpeed = 300;
		  
			$(menu).on('click', 'li a', function(e) {
				var $this = $(this);
				var checkElement = $this.next();
				var SiteId = $this.attr("SiteId");
				var type = $this.attr("type");

				sidebarMenu_show(checkElement,animationSpeed,$this);

				if(type==1){
					changeFrameSrc( window.frames["content_frame"] , "../report/report_person2018.jsp" )
					
				}else if(type==2){
					changeFrameSrc( window.frames["content_frame"] , "../report/report_depart2018.jsp" )
					
				}else if(type==3){
					changeFrameSrc( window.frames["content_frame"] , "../report/report_column2018.jsp" )
					
				}else if(type==4){
					changeFrameSrc( window.frames["content_frame"] , "../report/report_site2018.jsp" )
					
				}else if(type==5){
					changeFrameSrc( window.frames["content_frame"] , "../report/report_data2018.jsp" )
					
				}else if(type==6){
					changeFrameSrc( window.frames["content_frame"] , "../report/report2018.jsp" )
					
				}else if(type==7){
					changeFrameSrc( window.frames["content_frame"] , "../report/report22018.jsp" )
					
				}
				
			});
		}	
    </script>
</body>
</ht
