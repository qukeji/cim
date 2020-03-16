<%@ page import="tidemedia.cms.system.*,
				org.json.*,
				tidemedia.cms.util.TideJson,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
TideJson tj= CmsCache.getParameter("sys_vote_channel").getJson();
if(tj==null){out.println("error:插入投票参数未配置，请联系系统管理员。");return;}
int channelid =tj.getInt("subject_channelid");

Tree tree		= new Tree();
JSONArray arr = tree.listChannel_content_json(channelid, "tree", userinfo_session,20);
%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/sidebar-menu-template.css">
<link rel="stylesheet" href="../style/2018/common.css">

<style>
	html,body{height:100%;}
	.br-mainpanel{margin-top: 0px;margin-left: 230px;}
	.br-subleft{left: 0 !important;top: 0 !important;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>

<script> 
	var dir = "";

	function toggle_left(){
		$("#leftTd").toggle();
	}

	function getRadio()
	{
		var html = window.frames["right"].getRadio();
		return html;
	}
 
</script>
</head>

<body class="collapsed-menu email" onLoad="">
	<div class="br-subleft br-subleft-file" id="leftTd">
        <ul class="sidebar-menu">	  	  

		</ul>
    </div><!-- br-subleft -->
	<div class="br-mainpanel" id="rightTd" style="height: 100%;">      
		<iframe src="editor_vote_content.jsp" name="right" id="right" style="width: 100%;height: 100%;" scrolling="auto" frameborder="0"></iframe>  
    </div><!-- br-mainpanel -->

	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<script src="../lib/2018/peity/jquery.peity.js"></script>

	<script src="../lib/2018/datatables/jquery.dataTables.js"></script>
	<script src="../lib/2018/datatables-responsive/dataTables.responsive.js"></script>
	<script src="../lib/2018/select2/js/select2.min.js"></script>
    
    
	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/sidebar-menu-channel.js"></script>

	<script>
        $(function(){
			$('.br-mailbox-list,.br-subleft').perfectScrollbar();	
			
		//============  模板管理=============================================================================
            
			var menu = $('.sidebar-menu');
			var json = <%=arr%>;

			var html = '<li class="treeview"><a href="#" load="0" channelId="<%=channelid%>"><i class="fa fisrtNav fa-home" have="1"></i> <span>投票</span></a><ul class="treeview-menu" style="display: block;">';

			for(var i=0;i<json.length;i++){

				html += '<li><a href="#" load="'+json[i].load+'" channelId="'+json[i].id+'">'
				if(json[i].load==1||(json[i].child && json[i].child.length>0)){
					html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
				}else{
					html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
				} 
				html +='<span>'+json[i].name+'</span></a>';

				if(json[i].child && json[i].child.length>0){
					html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
				}
				html += '</li>';
			}

			html += '</ul></li>';

			menu.append(html);

			//多级导航自定义
			$.sidebarMenu(menu);
		});

		function get_menu_html(json)
		{
			var html = "";
			if(json.child && json.child.length>0)
			{
				var json_ = json.child;
				for(var i=0;i<json_.length;i++){
					html += '<li><a href="#" load="'+json_[i].load+'" channelId="'+json_[i].id+'">'
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
				var channelid = $this.attr("channelId");

				sidebarMenu_show(checkElement,animationSpeed,$this);
				
				window.frames["right"].location = "editor_vote_content.jsp?id="+channelid;
			});
		}	
	</script>
</body>
</html>
