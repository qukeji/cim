<%@ page import="java.sql.*,tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>

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

<body class="collapsed-menu email">
	<div class="bg-white modal-box">

		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
		
			<div class="row pd-x-30-force mg-t-10">                   		  	  	
				<label class="left-fn-title"><img  src="../images/jt_pic.jpg"/></label>
				<label class="wd-230" id="ParentName">
					<h4 style="margin:2px 0 0 3px;color:red;font-size:16px;font-family:'微软雅黑';">&nbsp;&nbsp;提醒:</h4>
				</label>									            
			</div>
			<div class="row pd-x-30-force flex-wrap ">
				
					<span class="wd-100p ht-100p" style="font-size:16px;color:#666666;line-height:26px;font-family:'微软雅黑';word-break: break-all;display: block;">您好！为了保证页面浏览效果，请使用以下推荐浏览器版本：Chrome浏览器，IE11，Edge。如果是360浏览器、QQ浏览器等请切换为极速模式浏览。</span>
				
			</div>
		
		</div>
		<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
			<div class="modal-footer" style="justify-content: flex-end !important;">
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-primary tx-size-xs" data-dismiss="modal" id="btnCancel1">确定</button>
			</div> 
		</div>	

	</div>
</body>
</html>