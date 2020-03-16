<%@ page import="tidemedia.cms.system.*,
				java.util.ArrayList"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
    <title>图标选择</title>

    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">    
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
    
  </head>
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
  <body class="" >
 
    <div class="bg-white modal-box">
      <!--<div class="ht-50 pd-x-20  rounded d-flex align-items-center justify-content-start bd-b">
        <label class="mg-b-0-force">操作：</label>
				<button class="btn btn-info btn-sm mg-r-8 tx-13" onclick="">上传</button>
				<button class="btn btn-danger btn-sm mg-r-8 tx-13" onclick="">删除</button>
      </div>-->
	    <div class="modal-body pd-20 overflow-y-auto" id="content-table">
	        <div class="config-box">
	       	   	  <ul class="row icon-list list-unstyled tx-20 mg-b-0">

				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10"><i class="fa fa-edit"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='<i class="fa fa-edit"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-anchor"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-anchor"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-area-chart"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-area-chart"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-arrows"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-arrows"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-automobile"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-automobile"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-balance-scale"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-balance-scale"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-ban"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-ban"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-bank"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-bank"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-bar-chart"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-bar-chart"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-bars"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-bars"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-bath"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-bath"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-battery"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-battery"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-battery-empty"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-battery-empty"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-bed"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-bed"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-bell-o"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-bell-o"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-bicycle"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-bicycle"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-binoculars"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-binoculars"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-birthday-cake"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-birthday-cake"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-bluetooth"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-bluetooth"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-book"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-book"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-briefcase"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-briefcase"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-bug"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-bug"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-calendar"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-calendar"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-calendar-o"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-calendar-o"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-camera"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-camera"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-camera-retro"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-camera-retro"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-clock-o"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-clock-o"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-clone"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-clone"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-close"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-close"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-coffee"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-coffee"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-cog"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-cog"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-comment"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-comment"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-comment-o"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-comment-o"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-compass"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-compass"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-credit-card"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-credit-card"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-crop"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-crop"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-crosshairs"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-crosshairs"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-cube"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-cube"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-cutlery"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-cutlery"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-database"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-database"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-desktop"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-desktop"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-diamond"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-diamond"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-download"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-download"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-envelope-o"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-envelope-o"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-eraser"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-eraser"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-exchange"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-exchange"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-eye"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-eye"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-eye-slash"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-eye-slash"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-eyedropper"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-eyedropper"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-fax"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-fax"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-feed"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-feed"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-female"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-female"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-film"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-film"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-filter"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-filter"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-fire"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-fire"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-flag"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-flag"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-folder"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-folder"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-gavel"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-gavel"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-gear"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-gear"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-gift"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-gift"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-glass"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-glass"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-globe"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-globe"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-headphones"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-headphones"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-heart"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-heart"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-home"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-home"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-hourglass"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-hourglass"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-image"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-image"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-inbox"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-inbox"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-key"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-key"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-laptop"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-laptop"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-leaf"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-leaf"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-lock"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-lock"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-magic"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-magic"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-magnet"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-magnet"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-map"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-map"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-microphone"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-microphone"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-mobile"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-mobile"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-money"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-money"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-music"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-music"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-navicon"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-navicon"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-paw"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-paw"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-pencil"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-pencil"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-phone"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-phone"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-plane"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-plane"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-plug"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-plug"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-plus"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-plus"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-print"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-print"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-random"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-random"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-recycle"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-recycle"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-refresh"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-refresh"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-reply"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-reply"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-road"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-road"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-rocket"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-rocket"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-rss"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-rss"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-search"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-search"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-send"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-send"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-server"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-server"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-share"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-share"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-shield"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-shield"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-ship"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-ship"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-shower"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-shower"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-signal"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-signal"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-signing"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-signing"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-sitemap"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-sitemap"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-sliders"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-sliders"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-spinner"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-spinner"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-spoon"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-spoon"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-star"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-star"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-suitcase"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-suitcase"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-tablet"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-tablet"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-tags"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-tags"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-tasks"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-tasks"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-television"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-television"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-ticket"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-ticket"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-trash"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-trash"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-tree"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-tree"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-trophy"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-trophy"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-truck"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-truck"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-umbrella"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-umbrella"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-wifi"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-wifi"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-newspaper-o"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-newspaper-o"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-html5"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-html5"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-file-text"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-file-text"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-scissors"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-scissors"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-play-circle-o"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-play-circle-o"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-youtube-play"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-youtube-play"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-users"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-users"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-street-view"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-street-view"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-tags"></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-tags"></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-check-square-o "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-check-square-o "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-history "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-history "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-address-card "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-address-card "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-commenting "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-commenting "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-address-book "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-address-book "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-cloud-upload "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-cloud-upload "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-jsfiddle "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-jsfiddle "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-cloud-download "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-cloud-download "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-comments-o "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-comments-o "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-sign-in "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-sign-in "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-pencil-square-o "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-pencil-square-o "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-sign-out "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-sign-out "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-folder-open "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-folder-open "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-weixin "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-weixin "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-tv "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-tv "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-podcast "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-podcast "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-paper-plane "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-paper-plane "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-comments "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-comments "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-weibo "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-weibo "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


				<li class="col-3 col-sm-2 col-lg-1 tx-center mg-t-10">
<i class="fa fa-line-chart "></i>
					<label class="rdiobox mg-b-10-force">
						<input id="" type="radio" name="iconselect" value='
<i class="fa fa-line-chart "></i>'><span class="d-inline-block"></span>
					</label>
				</li>


			  </ul><!-- icon-list -->
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box" >
      	<div class="modal-footer" >
		      <button type="button" class="btn btn-primary tx-size-xs" onclick="submit()">确认</button>
		      <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		    </div> 
      </div>
	    
	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>
    
	  <script src="../lib/2018/highlightjs/highlight.pack.js"></script>
    
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>    
    
    <script>
        function submit(){
          var html=  $("#content-table input:checked").val();
            console.log(html);
            
          top.TideDialogClose({suffix:'_3',recall:true,returnValue:{icon_list2018:html}});

        }
        
    
      
      
    </script>
  </body>
</html>
