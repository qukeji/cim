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
<%!
	public JSONArray listChannel_JS(UserInfo user) throws JSONException,MessageException,SQLException{		
		JSONArray array = new JSONArray();
		int ChannelNumber = 0;
		ChannelNumber = Tree.getChannelNumber();
		Channel ch = CmsCache.getChannel(-1);
		ArrayList childs = ch.getAllChildChannelIDs();

		if ((childs != null) && (childs.size() > 0)){
			for (int i = 0; i < childs.size(); ++i) {
				JSONObject o = new JSONObject();
				int channelid = ((Integer)childs.get(i)).intValue();
				Channel child = CmsCache.getChannel(channelid);
				int type = child.getType();
				String channelname = child.getName();

				if (child.getIsShowDraftNumber() == 1)
				{
					int num = child.getNumber(0);
					if (num > 0)
						channelname = channelname + " (" + num + ")";
				}
				if ((type == 5) || (user.hasChannelShowRight(channelid))) {
					String varName = "lsh_" + channelid;
					String icon = new Tree().getIcon(child);

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);
					JSONArray oo = listChannel_JS(channelid, varName, user, ChannelNumber);
					o.put("child", oo);
					array.put(o);
				}
			}
		}
		return array;
   }
   public JSONArray listChannel_JS(int id, String s, UserInfo user, int channelnum) throws JSONException,MessageException,SQLException{
		
		JSONArray array = new JSONArray();

		Channel ch = CmsCache.getChannel(id);
		ArrayList childs = ch.getAllChildChannelIDs();
		if ((childs != null) && (childs.size() > 0)) {

			for (int i = 0; i < childs.size(); ++i) {

				JSONObject o = new JSONObject();

				int channelid = ((Integer)childs.get(i)).intValue();
				Channel child = CmsCache.getChannel(channelid);
				int type = child.getType();
				String channelname = child.getName();

				if (child.getIsShowDraftNumber() == 1){
				  int num = child.getNumber(0);
				  if (num > 0)
					channelname = channelname + " (" + num + ")";
				}

				if (user.hasChannelShowRight(channelid)) {
					String varName = "lsh_" + channelid;
					String icon = "";
					icon = new Tree().getIcon(child);

					if (child.getType2() == 3)
						icon = new Tree().getIconByType2(child.getType2());

					if ((channelnum > 100) && (child.hasChild(user))){
						o.put("load", 1);
					}else{
						o.put("load", 0);
					}

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);

					if (channelnum <= 100) {
						JSONArray oo = listChannel_JS(channelid, varName, user, 0);
						o.put("child", oo);
					}
					array.put(o);
				}
			}
		}
		return array;
	}

%>
<%
Tree tree = new Tree();
String channel_tree_string = "";
 JSONArray arr= listChannel_JS(userinfo_session);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS</title>
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

<script language="javascript">  
var dir = "";
function next()
{
	var channelid = "";
	jQuery("#leftTd input:checked").each(function(i){
		if(i==0)
			channelid+=jQuery(this).val();
		else
			channelid+=","+jQuery(this).val();
	});
	
	if (channelid!=""&&!channelid.includes(","))
	{
		/*
		var channelid = window.frames["treeFrame"].getChannelID();
		var channeltype = window.frames["treeFrame"].getChannelType();
		//alert(channeltype);
		if(channelid=="" || (channeltype!=1 && channeltype!=0))
		{
			alert("请选择频道.");
			return false;
		}*/
	
		window.open("../custom/channel_export_xml.jsp?channelId="+channelid);		
	}
	else
	{
		alert("请选择频道.");
		//list();
		return false;
	}
	$("#submitButton").attr("disabled",true);
}

</script>
</head>

<body class="collapsed-menu email">

	<div class="bg-white modal-box">

		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">

			<div class="br-subleft-file" id="leftTd">
				<ul class="sidebar-menu">	  	  

				</ul>
			</div><!-- br-subleft -->

		</div>

		<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
			<div class="modal-footer" >
				
				<button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton" onclick="next();">确认</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>

			</div> 
		</div>	

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

			var html = '<li class="treeview"><a href="#" load="0" ><i class="fa fisrtNav fa-home" have="1"></i></a><ul class="treeview-menu" style="display: block;">';

			for(var i=0;i<json.length;i++){

				html += '<li><a href="#" load="'+json[i].load+'" channelId="'+json[i].id+'">'
				if(json[i].load==1||(json[i].child && json[i].child.length>0)){
					html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
				}else{
					html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
				} 
				html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';

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
					html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json_[i].id+'"><span style="padding:0"></span></label><span>'+json_[i].name+'</span></a>';

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
				if(load==1) 
				{		
					var url="../channel/channel_json.jsp?ChannelID="+channelid;
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
							html += '<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';

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
				
			});
		}	
	</script>

	</div>
</body>
</html>
