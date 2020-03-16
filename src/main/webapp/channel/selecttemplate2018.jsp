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

%>
<!DOCTYPE html>
<html>
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
<link rel="stylesheet" href="../style/2018/sidebar-menu-template.css">
<link rel="stylesheet" href="../style/2018/common.css">

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script language=javascript>

var dir = "<%=dir%>";

</script>
<style>
	.br-mainpanel{margin-top: 0px;margin-left: 230px;}
</style>
<script>
	function changeFrameHeights(_this){
		$(_this).css("height",document.documentElement.clientHeight-2);
	}
</script>
</head>

<body class="collapsed-menu email" onLoad="">
   
	<div class="br-subleft br-subleft-file">
        <ul class="sidebar-menu">	  	  

		</ul>
    </div><!-- br-subleft -->
	<div class="br-mainpanel">      
      <iframe src="../channel/template_add_list2018.jsp" id="template_frame" style="width: 100%;height: 100%;"  scrolling="auto" frameborder="0" onload="changeFrameHeights(this)"></iframe>  
    </div><!-- br-mainpanel -->
	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

	<!--<script src="../lib/2018/datatables/jquery.dataTables.js"></script>-->
	<!--<script src="../lib/2018/datatables-responsive/dataTables.responsive.js"></script>-->
	<script src="../lib/2018/select2/js/select2.min.js"></script>
    
    
	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/sidebar-menu-channel.js"></script>
	<script>
        $(function(){
		$('.br-mailbox-list,.br-subleft').perfectScrollbar();				
		//============  模板管理=============================================================================
		
			var url="../template/tree2018.jsp";
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
					html += '<a href="#" load="'+json[i].load+'" GroupID="'+json[i].id+'"><i class="fa fisrtNav fa-home " have="1"></i> <span>'+json[i].name+'</span></a>';
                    }else{
						html += '<a href="#" load="'+json[i].load+'" GroupID="'+json[i].id+'"><i class="fa fisrtNav fa-home " have="0"></i> <span>'+json[i].name+'</span></a>';
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
					html += '<li><a href="#" load="'+json_[i].load+'" GroupID="'+json_[i].id+'">'
				 if(json_[i].load==1||(json_[i].child && json_[i].child.length>0)){
					html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
				}else{
					html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
					} 
					html +='<span>'+json_[i].name+'</span></a>';

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
				var GroupID = $this.attr("GroupID");

				sidebarMenu_show(checkElement,animationSpeed,$this);
                changeFrameSrc( window.frames["template_frame"] , "../channel/template_add_list2018.jsp?GroupID="+GroupID ) ;
				//window.frames["template_frame"].src = "../channel/template_add_list2018.jsp?GroupID="+GroupID;
			});
		}	
    </script>
</body>
</html>
