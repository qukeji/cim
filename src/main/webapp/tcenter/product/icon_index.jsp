<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
  *
  *用途：选择图标
  *
  */
%>
<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>图标选择</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/theme/theme.css">
<style>
html,body{width: 100%;height: 100%;}
.modal-body{top: 0px;}
.config-box ul li{display:block;text-align: center;display: flex;flex-direction: column;justify-content: center;align-items: center;}
.modal-body .config-box .row{flex-wrap: wrap;}
.config-box ul li .rdiobox{margin-right: 0 !important;margin-top: 5px;}
.config-box ul li .rdiobox input{margin-right: 0;}
@media (min-width: 576px){
	.config-box .col-sm-2 {flex: 0 0 12%;max-width: 12%;}  	
}

</style>

<script src="../lib/2018/jquery/jquery.js"></script>

<script language="javascript">  
var dir = "";
function next(){

	var icon = $('input:radio[name="iconselect"]:checked').val();

	top.TideDialogClose({suffix:'_2',recall:true,returnValue:{icon:icon}});
}



</script>
</head>

<body class="collapsed-menu email">

	<div class="bg-white modal-box">

		<div class="modal-body pd-20 overflow-y-auto">
	        <div class="config-box">
	       	  <ul class="row icon-list list-unstyled tx-20 mg-b-0">
<%
//获取系统参数
String icon_ = CmsCache.getParameter("icons").getContent();
if(!icon_.equals("")){

	String[] icons = icon_.split(",");
	int n = 0 ;
	for(int i=0;i<icons.length;i++){
		String icon = icons[i] ;
		n++ ;
%>
				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10"><%=icon%>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='<%=icon%>'><span class="d-inline-block"></span>
					</label>
				</li>

<%
	}
}
%>
			  </ul><!-- icon-list -->
	        </div>
	    </div><!-- modal-body -->

		<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
			<div class="modal-footer" >
				<button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton" onclick="next();">确认</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
			</div> 
		</div>	

	</div><!-- br-mainpanel -->
</body>
</html>
