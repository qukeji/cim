<%@ page import="tidemedia.cms.system.*,
				java.text.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
		int id = getIntParameter(request,"id");//根据请求的id去tide_products 获取产品名称和简介
%>
<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<link rel="stylesheet" href="../../style/2018/bracket.css">
<link href="../../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<link rel="stylesheet" href="../../style/2018/common.css">
<link rel="stylesheet" href="../../style/theme/theme.css">
<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
	/*tooltip相关样式*/
    .bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
	.tooltip.bs-tooltip-right .arrow::before,
	.tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {			
		border-right-color: #00b297;			
	}
	.left-fn-title{min-width:80px !important}
</style>  
<script src="../../lib/2018/jquery/jquery.js"></script>
<script src="../../common/2018/common2018.js"></script>
</head>
<script >
	$(function () {
		var data={"id":<%=id%>};
		$.ajax({
			type : "post",
			url : '<%=request.getContextPath()%>/company/request/details',
			data :data,
			dataType:"json",
			success:function(data){
				var status = data.status;
				if(status==0){
					$("#status").text("未开通");
					$("#open").css("display","none");
					$("#footer").append("<button name=\"startButton\" type=\"button\" class=\"btn btn-primary tx-size-xs\" id=\"startButton\" onclick=\"saveButton()\">开通</button>");
					$("#footer").append("<button name=\"btnCancel1\" id=\"btnCancel1\" type=\"button\" onclick=\"top.TideDialogClose();\" class=\"btn btn-secondary tx-size-xs\" data-dismiss=\"modal\" id=\"btnCancel1\">取消</button>");
				}else if(status==1){
					$("#openDate").text(data.openDate.replace(".0",""));
					$("#sta").css("display","none");
					$("#footer").append("<button name=\"startButton\" type=\"button\" class=\"btn btn-primary tx-size-xs\" id=\"startButton\" onclick=\"top.TideDialogClose();\">确定</button>");
				}
				$("#requestDate").text(data.requestDate.replace(".0",""));
				$("#companyName").text(data.companyName);
				$("#productName").text(data.productName);
			}
		});

	})
	var data={"ids":<%=id%>};
	function saveButton() {
		$.ajax({
			type : "post",
			url : '<%=request.getContextPath()%>/company/request/update',
			data :data,
			dataType:"json",
			success:function(data){
				var	dialog = new top.TideDialog();
				if(data.code==200){
					dialog.showAlert("开通成功");
					top.TideDialogClose({refresh:'right'});
				}
			}
		});
	}
</script>
<body class="" >
    <div class="bg-white modal-box">
	  
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	  <!--基本信息-->
	       		  <li class="block">
				 
					<div class="row">                   		  	  	
						<label class="left-fn-title">租户名称：</label>
						<label class="wd-300" id="companyName">
						</label>
					</div>
					  <div class="row">
						  <label class="left-fn-title">产品：</label>
						  <label class="wd-300" id="productName">
						  </label>
					  </div>
					  <div class="row" id="sta">
						  <label class="left-fn-title">状态：</label>
						  <label class="wd-300" id="status">
						  </label>
					  </div>
					  <div class="row">
						  <label class="left-fn-title">申请日期：</label>
						  <label class="wd-300" id="requestDate">
						  </label>
					  </div>
					  <div class="row" id="open">
						  <label class="left-fn-title">开通日期：</label>
						  <label class="wd-300" id="openDate">
						  </label>
					  </div>
				  </li>      	    
	       	  </ul>             	
	        </div>	                   
		</div><!-- modal-body -->
		<div class="btn-box">
      		<div class="modal-footer" id="footer">

			</div> 
		</div>
		<div id="ajax_script" style="display:none;"></div>
	 	     
	</div><!-- br-mainpanel -->
</body>

<script type="text/javascript" src="../../common/2018/common2018.js"></script>
<script src="../../lib/2018/popper.js/popper.js"></script>
<script src="../../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../../lib/2018/moment/moment.js"></script>
<script src="../../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../../lib/2018/select2/js/select2.min.js"></script>
<script src="../../lib/2018/jquery-toggles/toggles.min.js"></script>

</html>
