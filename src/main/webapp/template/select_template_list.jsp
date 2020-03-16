<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>内容列表</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <!--<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">-->
    
    <!--<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">-->
    <!--<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">-->
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">  
    <link rel="stylesheet" href="../style/2018/common.css">
    <style>
    	.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
    	.pd-14{padding: 14px 14px 20px 14px;background: #fff;border-radius:4px ;border:1px solid rgba(0, 0, 0, 0.15)}
    	table{border-collapse: collapse !important;border:1px solid rgba(0, 0, 0, 0.15);border-radius:5px ;}
    	table th,table td{border:1px solid rgba(0, 0, 0, 0.15);border-collapse: collapse;}
    	table td{border-left: none;border-right: none;}    	
    	.search-box {display: none;}
    	.border-radius-5{border-radius: 5px;}
    </style>
  </head>

  <body class="collapsed-menu">
   
    <div class="br-mainpanel br-mainpanel-file" id="js-source">      
      
      <div class="d-flex align-items-center justify-content-start pd-x-20  pd-t-8 mg-b-5 mg-b-10">
        <!-- <button id="showSubLeft" class="btn btn-secondary mg-r-10 hidden-lg-up"><i class="fa fa-navicon"></i></button> -->
        <div class="current-position">
        	<p class=" tx-black">当前位置：</p>
        </div>

        <div class="mg-l-auto">
          <a href="#" class="btn btn-info mg-r-10 pd-x-10-force pd-y-5-force btn-search"><i class="fa fa-search mg-r-3"></i><span>检索</span></a>
          <a href="#" class="btn btn-info pd-x-10-force pd-y-5-force"><i class="fa fa-plus mg-r-3"></i><span>新建</span></a>              
        </div><!-- btn-group -->

      </div><!-- d-flex -->
      <!--搜索-->
      <div class="search-box pd-x-20">
      	<div class="bd bg-white border-radius-5">
      		<div class="row d-flex align-items-center mg-x-10-force">
      			<!--标题-->
      			<span class="tx-black vertical mg-r-5">检索：文件名</span>
	            <div class="mg-r-10 mg-y-20 search-item">	              
	              <input class="form-control wd-200 pd-x-5 pd-y-7-force" placeholder="" type="text" >
	            </div>
	            <a href="" class="btn btn-sm btn-info pd-x-10 pd-y-5">查找</a>
	            <!--日期-->
            
          </div><!-- row -->
      	</div>
      </div>
      <div class="br-pagebody pd-x-20 mg-t-15">
      	<div class="pd-14">
      		<div class="card bd-0 shadow-base">
	          <table class="table mg-b-0" id="content-table">
	            <thead>
	              <tr>                
	                <th class="tx-12-force tx-mont tx-medium">名称</th>
	                <th class="tx-12-force tx-mont tx-medium">文件名</th>
	                <th class="tx-12-force tx-mont tx-medium">最后修改时间</th>                
	              </tr>
	            </thead>
	            <tbody>
	              <tr>
	                
	                <td>
	                  <i class="fa fa-file-text" aria-hidden="true"></i>
	                  <span class="pd-l-5 tx-black">Camera Uploads</span>
	                </td>
	                <td class="">666</td>
	                <td class="">未审核</td>
	                
	              </tr>
	          
	            </tbody>
	          </table>
	        
	          
	        </div>
	      
      	</div>
     </div><!-- br-pagebody -->
 
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <!--<script src="../lib/2018/moment/moment.js"></script>-->
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <!--<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>-->
    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
    <!--<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>-->
	
    <!--<script src="../lib/2018/select2/js/select2.min.js"></script>-->
    <!--<script src="../common/2018/bracket.js"></script>-->    
    <script>
	    $(function(){
	        'use strict';
	
	        $("#content-table tr:gt(0)").click(function () {     
		        console.log($(this).find(":checkbox").prop("checked"))    
		        if ($(this).find(":checkbox").prop("checked"))// 此处要用prop不能用attr，至于为什么你测试一下就知道了。    
		        {    
		            $(this).find(":checkbox").removeAttr("checked");    
		            // $(this).find(":checkbox").attr("checked", 'false');     
		        }else{    
		            $(this).find(":checkbox").prop("checked", true);    
		        }     
		    }); 
			    
		    $(".btn-search").click(function(){
		    	$(".search-box").toggle(100);
		    })
			     
			
	    });
    </script>
  </body>
</html>
