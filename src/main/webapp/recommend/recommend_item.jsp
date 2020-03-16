<%@ page import="tidemedia.cms.system.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		FieldID		=	getIntParameter(request,"FieldID");
int		ChannelID	=	getIntParameter(request,"ChannelID");

Channel channel = CmsCache.getChannel(ChannelID);
if(channel.getAttribute1().endsWith(".xml"))
	response.sendRedirect("../vodone/commend_item_xml.jsp?ChannelID="+ChannelID);

JSONArray arr = new JSONArray();
Tree tree = new Tree();
if(FieldID>0)
	arr = tree.listTreeByField_json(userinfo_session,FieldID);
else if(ChannelID>0)
	arr = tree.listTreeByChannelRecommend_json(userinfo_session,ChannelID);
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

<script type="text/javascript">
var dir = "";

var FieldID = <%=FieldID%>;
var ChannelID = <%=ChannelID%>;

/*调整高度*/
window.onresize = function(){	
	if(document.getElementById("right")){
		document.getElementById("right").style.height =Math.max(document.documentElement.clientHeight-5,0) + "px";				
	}
}
function changeFrameHeight(_this){
	$(_this).css("height",document.documentElement.clientHeight-5);
}


function addDocument(r_itemid,r_channelid)
{
	if(FieldID>0)
	{
		opener.recommendItemJS(r_itemid,r_channelid,0);
		top.close();
	}
	else
	{
		this.location = "document.jsp?ItemID=0&ChannelID=" + <%=ChannelID%> + "&RecommendItemID=" + r_itemid + "&RecommendChannelID=" + r_channelid;
	}
}

</script>
</head>

<body class="collapsed-menu email">

	<div class="br-subleft br-subleft-file" id="leftTd">
        <ul class="sidebar-menu">	  	  

		</ul>
    </div><!-- br-subleft -->

	<div class="br-mainpanel" id="rightTd" style="height: 100%;">      
		<iframe src="recommend_content.jsp?DestChannelID=<%=ChannelID%>" name="right" id="right" style="width: 100%;height: 100%;" onload="changeFrameHeight(this)" frameborder="0"></iframe>  
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
			            
			var menu = $('.sidebar-menu');
			var json = <%=arr%>;

			var html = '<li class="treeview"><a href="#" load="0" channelId="<%=channel%>"><i class="fa fisrtNav fa-home" have="1"></i> <span>推荐栏目</span></a><ul class="treeview-menu" style="display: block;">';

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
				var load = $this.attr("load");
				var channelid = $this.attr("channelId");

				if(load==1) 
				{		
					var url="../lib/channel_json.jsp?ChannelID="+channelid;
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
							html += '<a href="#" load="'+json[i].load+'" channelid="'+json[i].id+'">';

							if(json[i].load==1||(json[i].child && json[i].child.length>0)){
								html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
							}else{
								html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
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
				window.frames["right"].location = "recommend_content.jsp?id="+channelid;
			});
		}	
	</script>

</body>
</html>