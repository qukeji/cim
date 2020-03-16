<%@ page import="tidemedia.cms.system.*,
				java.text.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
		int id = getIntParameter(request,"id");//根据请求的id去tide_products 获取产品名称和简介
		Product productInfo = new Product(id);
		String	Summary = productInfo.getSummary(); //产品简介

	    int companyId = userinfo_session.getCompany();//租户编号
		Company company=new Company(companyId);
		String companyName = company.getName();//租户名
		int productId		= getIntParameter(request,"id");//产品编码
		Product product=new Product(productId);
		String productName = product.getName();//产品名称
		int status=0;//状态
		Date date = new Date();//请求时间
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String requestDate=sdf.format(date);
%>
<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<link rel="stylesheet" href="../style/2018/bracket.css">
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/theme/theme.css">
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
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
</head>

<body class="" >
    <div class="bg-white modal-box">
	  
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	  <!--基本信息-->
	       		  <li class="block">
				 
					<div class="row">                   		  	  	
						<label class="left-fn-title">产品名称：</label>
						<label class="wd-300">
							<%=productName%>
						</label>									            
					</div>
					  <div class="row">
						  <label class="left-fn-title">产品简介：</label>
						  <label class="wd-300">
							  <%=Summary%>
						  </label>
					  </div>

				  </li>      	    
	       	  </ul>             	
	        </div>	                   
		</div><!-- modal-body -->
		<div class="btn-box">
      		<div class="modal-footer" >
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
				<button name="startButton" type="button" class="btn btn-primary tx-size-xs" id="startButton" onclick="saveButton()">申请开通</button>
				<input type="hidden" name="Submit" value="Submit">
			  <input type="hidden" name="id" value="<%=id%>">
			</div> 
		</div>
		<div id="ajax_script" style="display:none;"></div>
	 	     
	</div><!-- br-mainpanel -->
</body>

<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
    <script type="text/javascript">
        function saveButton() {
            var companyRequestEntity={"companyId":<%=companyId%>,"companyName":"<%=companyName%>",
                "productId":<%=productId%>,"productName":"<%=productName%>","status":<%=status%>,"requestDate":"<%=requestDate%>"}
            $.ajax({
                type : "post",
                url : '<%=request.getContextPath()%>/company/request/add',
                data :companyRequestEntity,
				dataType:"json",
                success:function(data){
					var	dialog = new top.TideDialog();
					dialog.showAlert(data.message);
                    top.TideDialogClose({refresh:'right'});
                }
            });
        }
</script>
</html>
