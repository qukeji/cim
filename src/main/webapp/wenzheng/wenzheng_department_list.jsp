<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String department = getParameter(request,"department");
int company = getIntParameter(request,"company");
String contextPath=request.getContextPath();
int wenzheng_channelid = CmsCache.getChannel("s66_a").getId();
%>

<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../<%=ico%>">
<title><%=title_main%></title>
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
		var department = getDepartment();
		department = JSON.parse(department);
		var departmentId = department.departmentId;
		var departmentname = department.departmentname;
		//$("#AppDepartment" , parent.document).attr("value",departmentname);
		window.parent.$("#content_frame").contents().find("#AppDepartment").val(departmentname);
		top.TideDialogClose();
	}

	//获取选中部门
	function getDepartment(){
		var departmentId = $("#departmentList input:checked").val();
		var departmentname = $("#departmentList input:checked").attr("describe");
		var obj='{"departmentId":"'+departmentId+'","departmentname":"'+departmentname+'","groupName":"'+groupName+'"}';
		return obj;
	}
</script>

</head>
<body class="collapsed-menu email">
<div class="bg-white modal-box"> 

	<div class="modal-body modal-body-btn pd-20 overflow-y-auto">

					<div class="block-title lh-30 lh-30px">

						<div class="power-containner pd-15" id="departmentList">

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
	var channelid = <%=wenzheng_channelid%>;
	var department = '<%=department%>';
	$(function(){
		$.ajax({
			type:"GET",
			dataType:"json",
			url:"../lib/channel_json.jsp?ChannelID="+channelid,
			success: function(data){
				
				
				for (var i = 0; i < data.length; i++) {
					var  html = "";
					var ischecked = "";
					if(department==data[i].name){
						ischecked = "checked";
					}
					html += "<label class=\"radio mg-r-20\">";
					html += "<input name=\"department\" type=\"radio\" value=\""+data[i].id+"\" describe=\""+data[i].name+"\" "+ischecked+"><span>"+data[i].name+"</span>";
					html += "</label>";
					$('#departmentList').append(html);
                }
				
			}
		});
	});

</script>
</html>