<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				java.util.*,
				tidemedia.cms.util.*,tidemedia.cms.publish.*,java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int role = userinfo_session.getRole();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 列表</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<!--<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">-->
<link href="../style/2018/bracket.css" rel="stylesheet" >
<link href="../style/2018/common.css" rel="stylesheet">
<style>
.collapsed-menu .br-mainpanel-file {
margin-left: 0;
margin-top: 0;
}
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script language="javascript">
var role = <%=role%>;
//稿件删除
function clear(){
	if(role==1){
		var url="./system/clear_index.jsp";
		var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(300);
		dialog.setUrl(url);
		dialog.setScroll('auto');
		dialog.setTitle("稿件删除");
		dialog.show();
	}else{
		alert("对不起，你没有访问权限.");
	}
}
//URL撤稿
function deleteFile(){
	var url="./system/deleteFile_index.jsp";
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(150);
	dialog.setUrl(url);
	dialog.setScroll('auto');
	dialog.setTitle("URL撤稿");
	dialog.show();
}
</script>
</head>
<body class="collapsed-menu email">
                    <div class="br-mainpanel br-mainpanel-file" >
                        <div class="br-pageheader pd-y-15 pd-md-l-20">
                            <nav class="breadcrumb pd-0 mg-0 tx-12">
                                <span class="breadcrumb-item active">系统监控 / 数据清理</span>
                            </nav>
                        </div>
						<!-- br-pageheader -->
				  <div class="d-flex flex-wrap" id="btn-group">
        	         <a href="show_page_data.jsp" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" data-toggle="tooltip" data-placement="bottom" >
	        	      <span>页面数据</span>
	                 </a>
                      <a href="clear_channel.jsp" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" data-toggle="tooltip" data-placement="bottom" >
	        	      <span>频道数据</span>
	                 </a>
                      <a href="javascript:clear();" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" data-toggle="tooltip" data-placement="bottom" title="批量删除频道下某时间段的所有稿件">
	        	      <span>稿件批量删除</span>
	                 </a>	
                       <a href="javascript:deleteFile();" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" data-toggle="tooltip" data-placement="bottom" title="根据文章预览地址对文章进行撤稿">
	        	      <span>URL快速撤稿</span>
	                 </a>	
                      <a href="manager2018.jsp;" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" data-toggle="tooltip" data-placement="bottom" title="根据文章预览地址对文章进行撤稿">
	        	      <span>返回</span>
	                 </a>						 
				  </div>
					</div>
                    <script src="../lib/2018/popper.js/popper.js"></script>
                    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
                    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
                    <script src="../lib/2018/moment/moment.js"></script>
                    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
                    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
                    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
                    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
                    <script src="../common/2018/bracket.js"></script>
                    <script type="text/javascript">
                       $(function(){
		var tipsTimer = null ;
		$(".t_btn_txt").mouseover(function(){
			//clearTimeout(tipsTimer);
			$(this).find(".tips-box").fadeIn(50);
		}).mouseleave(function(){
			var _this = this ;
			tipsTimer = setTimeout(function(){
				$(_this).find(".tips-box").fadeOut(50);
				clearTimeout(tipsTimer);
			},50)   		
		})	
	})
                    </script>
</body>
</html>