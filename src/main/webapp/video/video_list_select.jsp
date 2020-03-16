<%@ page import="tidemedia.cms.system.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

//type=2 选择视频编码视频
int		type	= getIntParameter(request,"type");
String right="../video/video_content_right3.jsp?type="+type;
//String video_url = CmsCache.getParameterValue("video_url");

Tree tree		= new Tree();
int channel = CmsCache.getParameter("sys_editor_video").getIntValue();
JSONArray arr = tree.listChannel_content_json(channel, "tree", userinfo_session,20);

int video_type = CmsCache.getParameter("sys_editor_video_type").getIntValue();
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
<script src="../common/2018/TideDialog2018.js"></script>

<script> 
	var dir = "";
	var video_type = <%=video_type%>;

	function getRadio()
	{
		var video = window.frames["right"].getRadio();
		video = JSON.parse(video);
		var mp4 = video.video_url;
		var video_phone = video.photo;
		
		if(mp4!=""){
			var html = '<script>tide_player.showPlayer({video:"'+mp4+'",cover:"'+video_phone+'",width:"100%",height:"100%"});<\/script>';
			if(video_type==1){
				html = '<video src="'+mp4+'" controls="controls" poster="'+video_phone+'" width="100%" height="100%"></video>';
			}
			var obj={html:html,length:1,coverhref:"",type:'1',video_type:video_type};			
			return obj;
		}else{
			alert("没有生成转码后视频");
			return false;
		}
	}
</script>

</head>
<body class="collapsed-menu email" onLoad="">
	<div class="br-subleft br-subleft-file" id="leftTd">
        <ul class="sidebar-menu">	  	  

		</ul>
    </div><!-- br-subleft -->
	<div class="br-mainpanel" id="rightTd" style="height: 100%;">      
		<iframe src="<%=right%>" name="right" id="right" style="width: 100%;height: 100%;" scrolling="auto" frameborder="0"></iframe>  
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

			var html = '<li class="treeview"><a href="#" load="0" channelId="<%=channel%>"><i class="fa fisrtNav fa-home" have="1"></i> <span>视频库</span></a><ul class="treeview-menu" style="display: block;">';

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

				window.frames["right"].location = "<%=right%>&id="+channelid;
			});
		}	
	</script>
</body>
</html>
