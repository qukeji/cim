<%@ page import="tidemedia.cms.system.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
String users = getParameter(request,"users");
String contextPath=request.getContextPath();
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
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">	
<link rel="stylesheet" href="../style/2018/sidebar-menu-template.css">
<link rel="stylesheet" href="../style/2018/common.css">

<style>
	html,body{width: 100%;height: 100%; background: #E9ECEF;}
	ul,li{list-style: none;}
	.br-subleft{position: static !important;height: 100%;border: 1px solid #e9ecef; }
	.modal-body-btn .config-box .row .left-fn-title{min-width: 80px;text-align: left;}
	.modal-body .config-box label.ckbox{width: 90px;cursor: pointer;margin-right: 50px;}
	.channel-container,.power-containner{ border: 1px solid #e9ecef;}
	.channel-container ul li{justify-content: flex-start;align-items: center;
	background: #f2f2f2;border-bottom: 1px solid #ddd;cursor: pointer;}
	.channel-container ul li.active{background: #17A2B8;color: #fff;}
	.power-containner .row{margin: 0 !important;}
	label{min-width:135px;}
</style> 

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>

<script> 
	var dir = "";
	var groupName = "";

	function ok(){
		var user = getUser();
		user = JSON.parse(user);

		var userId = user.id;
		var Username = user.name;
        parent.$("#users_id").attr("value",userId);
        parent.$("#participant").attr("value",Username);
        top.TideDialogClose();
       // top.TideDialogClose({suffix:'_1',recall:true,returnValue:{users:userId,Usernames:Username}});
	}

	//全选
	function selectAll(){
		var ischecked = $("#selectAll").prop("checked");
		if(ischecked){
			$(":checkbox",$("#userList")).prop("checked",true);
		}else{
			$(":checkbox",$("#userList")).prop("checked",false);
		}
	}
	//获取选中用户
	function getUser(){
		var id = "";
		var name = "";
		jQuery("#userList input:checked").each(function(i){
			if(id!=""){
				id += ",";
				name += ",";
			}
			id +=jQuery(this).val();
			name +=jQuery(this).attr("describe");
		});
		var obj='{"id":"'+id+'","name":"'+name+'","groupName":"'+groupName+'"}';
		return obj;
	}
</script>

</head>
<body class="collapsed-menu email">
<div class="bg-white modal-box"> 

	<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
		<div class="d-flex ht-100p-force justify-content-between">
			<div class="br-subleft br-subleft-file">
				<div class="sidebar-menu-box ht-100p-force overflow-auto">
					<ul class="sidebar-menu mg-t-0-force">	  	  
					</ul>
				</div>
			</div><!-- br-subleft -->

			<div class="right-box wd-500">
				<div class="bot-power">
					<div class="block-title mg-t-20 lh-30 lh-30px">
						<label class="ckbox mg-r-20">
							<input name="selectAll" type="checkbox" id="selectAll" onclick="selectAll();"><span>全选</span>
						</label>
						<div class="power-containner pd-15" id="userList">

						</div>
					</div>

				</div>
			</div>
		</div>
	</div>

	<div class="btn-box">
      	<div class="modal-footer" >
		     <button id="submitButton" name="submitButton" type="button" class="btn btn-primary tx-size-xs" onclick="ok()">确认</button>
		     <button id="btnCancel1" name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		</div> 
    </div>
</div>
</body>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/sidebar-menu-channel.js"></script>
<script>

	$(function(){
		$('.br-mailbox-list,.br-subleft').perfectScrollbar();
		menu_init();
		showUser(-1);
	});

	//导航初始化(第一次加载)
	function menu_init(){

		var url="../user/tree2018.jsp";
		
		$.ajax({type:"GET",dataType:"json",url:url,success: function(json){

			var menu = $('.sidebar-menu');
			var html = '<li class="treeview"><a href="#" load="0" GroupID=-1><i class="fa fisrtNav fa-home" have="1"></i> <span>所有用户</span></a><ul class="treeview-menu" style="display: block;">';
			for(var i=0;i<json.length;i++){
				
				if( json[i].load==1 || (json[i].child!=null && json[i].child.length>0) ){
				  html += '<li><a href="#" load="'+json[i].load+'" GroupID="'+json[i].id+'"><i class="fa fisrtNav fa-home " have="1"></i> <span>'+json[i].name+'</span></a>';
				}else{
				  html += '<li><a href="#" load="'+json[i].load+'" GroupID="'+json[i].id+'"><i class="fa fisrtNav fa-home " have="0"></i> <span>'+json[i].name+'</span></a>';
				 }
				if(json[i].child && json[i].child.length>0)
				{
					html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
				}
				html += '</li>';
				
			}
			html += '</ul></li>';
			menu.append(html);
			$.sidebarMenu(menu);
		}});
	}
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
	 //导航点击事件
	 $.sidebarMenu = function(menu) {
		var animationSpeed = 300;
	  
		$(menu).on('click', 'li a', function(e) {
			var $this = $(this);
			var checkElement = $this.next();
			var GroupID = $this.attr("GroupID");

			showUser(GroupID);

			sidebarMenu_show(checkElement,animationSpeed,$this);
		});
	}
	
	var users = "<%=users%>";
	function showUser(id){
		$.ajax({
			type:"GET",
			dataType:"json",
			url:"http://183.58.24.156:888/jushi/report/getUser.jsp?users="+users,
			success: function(obj){

				var userList = $('#userList');
				userList.html("");
				//groupName = obj.groupName ;
				userList.append(obj.html);
				
			}
		});
	}
</script>
</html>