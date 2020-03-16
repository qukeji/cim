<%@ page import="tidemedia.cms.system.*,
                 org.json.*,
				 tidemedia.cms.base.*,
				 tidemedia.cms.util.*,
				 java.util.*,
				 java.sql.*,
				 tidemedia.cms.user.UserInfo,
				 java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String Action = getParameter(request,"Action");
int		ChannelID		=	getIntParameter(request,"ChannelID");
int		LinkChannelID	=	getIntParameter(request,"LinkChannelID");
int		LinkChannelID1	=	getIntParameter(request,"LinkChannelID1");
int		parent			=	getIntParameter(request,"parent");
int		GlobalID		=	getIntParameter(request,"GlobalID");
int		fieldgroup		=	getIntParameter(request,"fieldgroup");

Tree tree = new Tree();
JSONArray arr = tree.listChannel_json(parent,"",userinfo_session,0);

Channel channel = CmsCache.getChannel(parent);
String channelName = channel.getName();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 9.0 <%=CmsCache.getCompany()%></title>

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
var dir = "";
window.onresize = function(){	
	if(document.getElementById("right")){
		document.getElementById("right").style.height =Math.max(document.documentElement.clientHeight-8,0) + "px";				
	}
}
function changeFrameHeight(_this){
	$(_this).css("height",document.documentElement.clientHeight-8);
}

</script>
<style>
	.br-mainpanel{margin-top: 0px;margin-left: 230px;}
</style>
<script>
	
</script>
</head>

<body class="collapsed-menu email" onLoad="">   
	<div class="br-subleft br-subleft-file">
        <ul class="sidebar-menu">	  	  

		</ul>
    </div><!-- br-subleft -->
	<div class="br-mainpanel">      
      <iframe src="../content/select_button_child_content2018.jsp?ChannelID=<%=ChannelID%>&LinkChannelID=<%=LinkChannelID%>&GlobalID=<%=GlobalID%>&fieldgroup=<%=fieldgroup%>" id="template_frame" style="width: 100%;height: 100%;"  scrolling="auto" frameborder="0" onload="changeFrameHeight(this)"></iframe>  
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
	var ChannelID = "<%=ChannelID%>";
	var LinkChannelID = "<%=LinkChannelID%>";
	var LinkChannelID1 = "<%=LinkChannelID1%>";
	var parent = "<%=parent%>";
	var GlobalID = "<%=GlobalID%>";
	var fieldgroup = "<%=fieldgroup%>";

    $(function(){
		$('.br-mailbox-list,.br-subleft').perfectScrollbar();				
		//============ =============================================================================

		var menu = $('.sidebar-menu');
		var json = <%=arr%>;

		var html = '<li class="treeview"><a href="#" load="0" channelId="0"><i class="fa fisrtNav fa-home" have="1"></i> <span><%=channelName%></span></a><ul class="treeview-menu" style="display: block;">';

		for(var i=0;i<json.length;i++){

			if(json[i].id!=LinkChannelID&&json[i].id!=LinkChannelID1){
				continue;
			}

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
				html += '<li><a href="#" load="'+json_[i].load+'" channelid="'+json_[i].id+'">'
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
					}
				});
			}
			else
			{
				sidebarMenu_show(checkElement,animationSpeed,$this);
			}
			changeFrameSrc( window.frames["template_frame"] , "../content/select_button_child_content2018.jsp?ChannelID="+ChannelID+"&LinkChannelID="+LinkChannelID+"&GlobalID="+GlobalID+"&fieldgroup="+fieldgroup+"&LinkChannelID2="+channelid+"&parent="+parent+"&LinkChannelID1="+LinkChannelID1);					
			if (checkElement.is('.treeview-menu')) {
			  e.preventDefault();
			}
		});
	}
</script>
</body>
</html>
