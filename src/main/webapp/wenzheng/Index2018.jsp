<%@ page import="tidemedia.cms.system.*,java.util.Date,tidemedia.cms.util.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);

int Flag = getIntParameter(request,"Flag");
int childGroup =  getIntParameter(request,"childGroup");
String time = CmsCache.getExpiresDateStr();  
long current = System.currentTimeMillis();
time  = time.replaceAll("-","/");
Date date = new Date(time);
long ExpiresDate = date.getTime();
long diff = (ExpiresDate - current)/1000; //秒
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");
if(CmsCache.hasValidLicense()) diff = 1000000;

String dir="";

TideJson wenzheng = CmsCache.getParameter("wenzheng").getJson();//问政信息
int channelid = wenzheng.getInt("wenzheng");//问政编号
int parent = CmsCache.getChannel(channelid).getParent();
String system_logo = CmsCache.getParameter("system_logo").getContent();

%>
<!DOCTYPE html>
<html id="pink">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>问政内容管理</title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/tcenter.css">
<!--<link href="../lib/2018/datatables/jquery.dataTables.css" rel="stylesheet">-->
<!--<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">-->

<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/sidebar-menu-channel.css">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/2018/theme.css">
<link rel="stylesheet" href="../style/2018/theme.css">

<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>

<script language=javascript>

var dir = "<%=dir%>";

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

	<%@include file="wenzheng_tree.jsp"%><!--静态包含-->

	<%@include file="header.jsp"%><!--静态包含-->

	<div class="br-subleft br-subleft-file">
        <div class="sidebar-menu-box ht-100p-force">
			<ul class="sidebar-menu">	  	  
                <li class="active"><a href="javascript:;" channelid="0" load="0" cloud="undefined"><i class="fa fisrtNav fa-home" have="1"></i> <span>问政管理</span></a><ul class="treeview-menu menu-open" style="display: block;"><li class=""><a href="javascript:;" load="0" channelid="1"><i class="fa fa-angle-right op-5" hava="0"></i><span>待办理</span></a></li><li><a href="javascript:;" load="0" channelid="2"><i class="fa fa-angle-right op-5" hava="0"></i><span>办理中</span></a></li><li><a href="javascript:;" load="0" channelid="3"><i class="fa fa-angle-right op-5" hava="0"></i><span>已办理</span></a></li></ul></li>
			</ul>
		</div>
    </div><!-- br-subleft -->

    <!-- ########## START: MAIN PANEL ########## -->
    <div class="br-mainpanel with-second-nav br-mainpanel-file " id="js-source">
        <iframe src="content2018.jsp" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
    </div><!-- br-mainpanel -->
	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
	<!--<script src="../lib/2018/select2/js/select2.min.js"></script>-->
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
//=============================================================================================================
            var  childGroup= <%=childGroup%>;
			var channelid = <%=channelid%> ;

			var  url="../lib/channel_json.jsp?ChannelID=<%=parent%>";
			$.ajax({type:"GET",dataType:"json",url:url,success: function(json){

				var menu = $('.sidebar-menu');

				for(var i=0;i<json.length;i++){

					if(json[i].id!=channelid){
						continue;
					}
					
					var html = '';
					if(json[i].child&&json[i].child.length>0)
					{					
							html = '<li class="treeview active">';
					}
					else
					{
						html = '<li class="active">';
					}
					if( json[i].load==1 || (json[i].child!=null && json[i].child.length>0) ){	
						if(json[i].type==0){  //判断是否独立表单
							html += '<a href="javascript:;" channelid="'+json[i].id+'" load="'+json[i].load+'" cloud="'+json[i].cloud+'"><i class="fa fisrtNav fa-home" have="1"></i> <span>'+json[i].name+'</span></a>';

						}else{
							html += '<a href="javascript:;" channelid="'+json[i].id+'" load="'+json[i].load+'" cloud="'+json[i].cloud+'"><i class="fa fisrtNav fa-home" have="1"></i> <span>'+json[i].name+'</span></a>';
						}					   
					}else{
						if(json[i].type==0){
							html += '<a href="javascript:;" channelid="'+json[i].id+'" load="'+json[i].load+'" cloud="'+json[i].cloud+'"><i class="fa fisrtNav fa-home" have="0"></i> <span>'+json[i].name+'</span></a>';							
						}else{
							html += '<a href="javascript:;" channelid="'+json[i].id+'" load="'+json[i].load+'" cloud="'+json[i].cloud+'"><i class="fa fisrtNav fa-home" have="0"></i> <span>'+json[i].name+'</span></a>';							
						}	
						
					}
					if(json[i].child&&json[i].child.length>0)
					{			
                        html += '<ul class="treeview-menu menu-open">' + get_menu_html(json[i]) + '</ul>';					
					}
					html += '</li>';
					activeFn();
				}			
				//多级导航自定义
				$.sidebarMenu(menu);
								
			}});

		});
        
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
        
		function get_menu_html(json)
		{
			var html = "";
			if(json.child && json.child.length>0)
			{										
				var json_ = json.child;

				for(var i=0;i<json_.length;i++)
				{	   
					html += '<li class="active"><a href="#" load="'+json_[i].load+'" channelid="'+json_[i].id+'">';

					if(json_[i].load==1||(json_[i].child && json_[i].child.length>0)){
						if(json_[i].type==0){
							html += '<i class="fa fa-angle-double-right" hava="1"></i>';
						}else{
							html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>';
						}
						
					}else{
					    if(json_[i].type==0){
							html += '<i class="fa fa-angle-right" hava="0"></i>';
						}else{
							html += '<i class="fa fa-angle-right op-5" hava="0"></i>';
						}
					} 
					html += '<span>'+json_[i].name+'</span></a>';

					if(json_[i].child && json_[i].child.length>0)
					{ 				       
						html += '<ul class="treeview-menu">' + get_menu_html(json_[i]) + '</ul>';					
					}	

					html += '</li>';
				}
				
			}
			
			return html;
		 }

//===================================================================

		$.sidebarMenu = function(menu) {
		  var animationSpeed = 300;
		  
		  $(menu).on('click', 'li a', function(e) {
//			  if($(this).hasClass("clicked")){
//					return;
//				}
//				$(this).addClass("clicked");//设置不可重复点击
			var $this = $(this);
			var checkElement = $this.next();
			var load = $this.attr("load");
			var channelid = $this.attr("channelid");
            var haveChild = $this.find("i").attr("have");
			if(load==1) 
			{
				var url="../lib/channel_json.jsp?ChannelID="+channelid;
				$.ajax({
					type:"GET",
					dataType:"json",
					url:url,
					beforeSend:function(){ 
						if(haveChild==1){
							var loadingHtml = '<ul class="treeview-menu nav-loading" style="display: block;"><li><a class="tx-white tx-13-force" href="javascript:;"><i class="fa tx-13-force fa-spinner" aria-hidden="true"></i>loading</a></li></ul>'
							$this.after(loadingHtml)
						}
					}, 
					success: function(json){
					var html = '<ul class="treeview-menu">';
					for(var i=0;i<json.length;i++){
                        console.log(json[i].id);
						if(json[i].child && json[i].child.length>0)
						{
							html += '<li class="treeview">';
						}
						else
						{
							html += '<li>';
						}
						html += '<a href="javascript:;" load="'+json[i].load+'" channelid="'+json[i].id+'">';

						if(json[i].load==1||(json[i].child && json[i].child.length>0)){
							if(json[i].type==0){   //判断是独立非独立表单
								html += '<i class="fa fa-angle-double-right" hava="1"></i>';
							}else{
								html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>';
							}
							//html += '<i class="fa fa-television"></i>';
						}else{								
							if(json[i].type==0){
								html += '<i class="fa fa-angle-right" hava="0"></i>';
							}else{
								html += '<i class="fa fa-angle-right op-5" hava="0"></i>';
							}
						} 
						html += '<span>'+json[i].name+'</span></a>';

						if(json[i].child && json[i].child.length>0)
						{
							html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
						}
						html += '</li>';
					}
					html += '</ul>';
					$(".nav-loading").remove();
					$this.nextAll().remove();
					$this.after($(html));
					$this.attr("load",0);//加载完毕改变load属性
					
					checkElement = $this.next();
					sidebarMenu_show(checkElement,animationSpeed,$this);
				}});
			}
			else
			{
				sidebarMenu_show(checkElement,animationSpeed,$this);
			}
			if(channelid==16199){
			
            changeFrameSrc( window.frames["content_frame"] , "new_content2018.jsp?id="+channelid )
			//window.frames["content_frame"].src = "../content/content2018.jsp?id="+channelid;
            }else{
               changeFrameSrc( window.frames["content_frame"] , "content2018.jsp?id="+channelid ) 
            }
			if (checkElement.is('.treeview-menu')) {
			  e.preventDefault();
			}
		  });
		}
  
			
    </script>
   
</body>
</html>
