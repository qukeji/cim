<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.util.Date,org.json.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="/tcenter/config.jsp"%>
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

String dir="doc";

String system_logo = CmsCache.getParameter("system_logo").getContent();
%>
<!DOCTYPE html>
<html id="pgcMnanage">
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
<link rel="stylesheet" href="../style/2018/theme.css">
<style>
	@media (min-width: 992px) {

		.collapsed-menu .br-mainpanel-file {
			margin-left:60px
		}
	}
	.expand-menu .br-mainpanel-file{
		margin-left: 230px;
	}
</style>
<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>

<script language=javascript>

var dir = "<%=dir%>";
//新建
function newGroup()
{
	var	GroupID = 0;
	var company = 0 ;
	var type = 0 ;
	var GroupName = "";
	if (getActiveNav()){ 
		var this_ = getActiveNav();
		GroupID = $(this_).attr("id");
		company = $(this_).attr("company");
		type = $(this_).attr("type");
		GroupName = $(this_).text();
	}
	if(type==0){
		alert("\"" + GroupName + "\"不可新建！");
		return;
	}
	var dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(300);
		dialog.setUrl("../user/group_add2018.jsp?GroupID="+GroupID+"&company="+company);
		dialog.setTitle("新建用户组");
		dialog.show();
}
function editGroup()
{
	var	GroupID = 0;
	var GroupName = "";
	if (getActiveNav()){ 
		var this_ = getActiveNav();
		GroupID = $(this_).attr("id");
		GroupName = $(this_).text();
	}
	if(GroupID<2){
		alert("\"" + GroupName + "\"不可编辑！");
		return;
	}
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(300);
		dialog.setUrl("../user/group_edit2018.jsp?GroupID="+GroupID);
		dialog.setTitle("编辑用户组");
		dialog.show();
}
function deleteGroup()
{
	if (getActiveNav()){ 
		var this_ = getActiveNav();
		var	GroupID = $(this_).attr("id");
		var GroupName = $(this_).text();
		
		if(GroupID<2)
		{
			alert("\"" + GroupName + "\"不能删除!");
			return false;
		}
		

		if(confirm("确实要删除\"" + GroupName + "\"吗?\r\n")) 
		{
//			this.location = "../user/group_delete2018.jsp?Action=Delete&id="+GroupID;

			$.ajax({
				type:"GET",
				dataType:"json",
				url:"../user/group_delete2018.jsp?Action=Delete&id="+GroupID,
				success: function(json){
					if(json.msg==""){
						reLoadNav(json);
					}else{
						alert(json.msg.trim());
					}
				}
			});

		}
	}else{
		return false;
	}
}

</script>
</head>

<body class="collapsed-menu email" id="withSecondNav">
	<div class="br-logo">
		<a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
		   <img class="ht-100p" src="../img/2019/<%=system_logo%>">
		</a>
	</div>

	<%@include file="company_tree.jsp"%><!--静态包含-->

	<%@include file="header.jsp"%><!--静态包含-->

    <!-- ########## START: MAIN PANEL ########## -->
    <div class="br-mainpanel with-second-nav br-mainpanel-file " id="js-source">
        <iframe src="articlesContent.jsp" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
    </div><!-- br-mainpanel -->
	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/sidebar-menu-channel.js"></script>
	<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
	<script>	
		
		var userrole = <%=userinfo_session.getRole()%> ;

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

			if(userrole==1){
				//导航初始化
				menu_init(1,null);
			}
			
			$('.br-mailbox-list,.br-subleft').perfectScrollbar();
		});
//=============================================================================================================

        //导航初始化(第一次加载)
		function menu_init(type,obj){

		}

		function get_menu_html(json)
		{
			var html = "";
			if(json.child && json.child.length>0)
			{
				var json_ = json.child;
				for(var i=0;i<json_.length;i++){
   					
					html += '<li><a href="#" load="0" id="'+json_[i].id+'" company="'+json_[i].company+'"><i class="fa fa-users"></i>' 
					html +='<span>'+json_[i].name+'</span></a>';

					if(json_[i].child && json_[i].child.length>0){
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
			var $this = $(this);
			var checkElement = $this.next();
			var load = $this.attr("load");//是否已加载
			var type = $this.attr("type");//1:租户 2:用户组  3:所有用户
			var id = $this.attr("id");//分组编号
			var company = $this.attr("company");//租户编号
			if(load==1) 
			{
				var url="../tcenter/company/company_tree.jsp?id="+id+"&type="+type;
				if(type==1){
					var url="../tcenter/company/company_tree.jsp?id="+company+"&type="+type;
				}
				$.ajax({
					type:"GET",
					dataType:"json",
					url:url, 
					success: function(json){

						var html = '<ul class="treeview-menu">';
						for(var i=0;i<json.length;i++){
							if(json[i].child && json[i].child.length>0)
							{
								html += '<li class="treeview">';
							}
							else
							{
								html += '<li>';
							}
							html += '<a href="#" id="'+json[i].id+'" company="'+json[i].company+'" type="'+type+'" load="0">';
							html += '<i class="fa fa-users"></i>';
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
					}
				});
			}
			else
			{
				sidebarMenu_show(checkElement,animationSpeed,$this);
			}

	//		if(id==0 && company==0){//所有租户
	//			changeFrameSrc( window.frames["content_frame"] , "company_list.jsp" );
	//		}else{
				if(id==1){id=-1}
				changeFrameSrc( window.frames["content_frame"] , "/tcenter/user/company_user_list2018.jsp?GroupID="+id+"&type="+type+"&company="+company );
	//		}

			if (checkElement.is('.treeview-menu')) {
			  e.preventDefault();
			}
		  });
		}


		$(function(){
    		var beforeShowFunc = function() {
    		};
			var menu = [
			    {'<i class="fa fa-pencil mg-r-5"></i>新建':function(menuItem,menu){newGroup();}},
			    {'<i class="fa fa-edit mg-r-5"></i>编辑':function(menuItem,menu) {editGroup();}},	
			    {'<i class="fa fa-trash mg-r-5"></i>删除</font>':function(menuItem,menu) {deleteGroup();} }
			];
			$('.br-subleft').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});	
    	})
		
    </script>
   
</body>
</html>
