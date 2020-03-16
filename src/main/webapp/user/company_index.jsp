<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
  *
  *用途：用户选择租户
  *
  */

int id = getIntParameter(request,"id");

int companyid = userinfo_session.getCompany();
JSONArray arr = new Company().getGroup(companyid);

%>
<!DOCTYPE html>
<html id="green">
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
function next(){

	var len = $("#leftTd input:checked").length;
	if(len!=1)
	{
		alert("请选择一个租户！");
		return false;	
	}

	var id = $("#leftTd input:checked").val();
	var url = "user_company_action.jsp?company="+id+"&userid=<%=id%>&type=1";
	$.ajax({
		type:"GET",
		url:url, 
		success: function(msg){
			top.TideDialogClose({refresh:'right'});
		}
	});
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

			var html = '<li class="treeview"><a href="#" load="0" id="0"><i class="fa fisrtNav fa-home" have="1"></i> <span>所有租户</span></a><ul class="treeview-menu" style="display: block;">';

			for(var i=0;i<json.length;i++){
				if(json[i].type==1){

					html += '<li><a href="#" id="'+json[i].company+'">';
					html += '<i class="fa fa-angle-right op-5" hava="0"></i>';

					html +='<label class="rdiobox mg-b-0 mg-r-10"><input type="radio" name="id" value="'+json[i].company+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';

					html += '</li>';
				}
			}

			html += '</ul></li>';

			menu.append(html);
			$(".sidebar-menu>li:first").addClass("active");
			//多级导航自定义
			$.sidebarMenu(menu);
		});

	</script>

	</div>
</body>
</html>
