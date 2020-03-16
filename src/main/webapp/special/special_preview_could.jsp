<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.report.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
        int	sourceid		=	getIntParameter(request,"id");
        int	cloud_id1		=	getIntParameter(request,"cloud_id");
        int	ChannelID		=	getIntParameter(request,"ChannelID");
        String ChannelName	=	getParameter(request,"ChannelName");
        String url	=	getParameter(request,"url");
%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="Shortcut Icon" href="../favicon.ico">
    <title>云专题预览</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
    <!--<link href="../lib/2018/datatables/jquery.dataTables.css" rel="stylesheet">-->
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">  
    <link rel="stylesheet" href="../style/2018/common.css">
    <style>
    	.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
    	table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
    	table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
    	border-collapse: collapse !important;}
    	.list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;position: relative;}
    	/*.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}*/
    	.list-pic-box .list-img-contanier{width: 100%;position: absolute;left: 0;top: 0;height: 100%;display: flex;justify-content: center;align-items: center;}
      .list-pic-box .list-img-contanier img{width: auto;max-height: 100%;max-width: 100%;}
      .list-pic-preview{display: flex;align-items: center;justify-content: center;}
      .list-pic-preview > button[name="use"]{margin-left: .4rem;}
      .list-pic-preview button{cursor: pointer;}
      .card-body {padding: .75rem;}
      .br-pageheader-left{border-left:1px solid #868ba1;}
      .br-pageheader-text{line-height: 20px;height:20px;display: inline-block;vertical-align: top;}
      .mg-auto{margin:0 auto;}
      #nav-header{line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}
      #nav-header a{color: #a4aab0;}
      .btn-box a {color: #fff;}
      .tx-black-force {color: #000 !important;}
      .navicon-left{border-right:none;width:150px;}
    </style>
  </head>

  <body class="collapsed-menu">
   
    <!-- <div class="br-mainpanel br-mainpanel-file" id="js-source">      
      <div class="br-pageheader   pd-md-l-20 d-flex justify-content-between">
        <nav class="breadcrumb pd-0 mg-0 tx-12 pd-y-15">
            <img class="wd-20" src="../../images/2018/logo_mob.png">
            <span class="tx-14 br-pageheader-text">Tcenter 20 | 云专题</span>
        </nav>
        <div class="d-flex justify-content-between">
            <div class="row mg-l-0 mg-r-0 mg-r-15 list-pic-preview">				                  					                  
                <button name="preview" type="button" class="btn btn-outline-info active tx-size-xs pd-y-6 pd-x-15" >预览</button>
                <button name="use" type="button" class="btn btn-outline-info active tx-size-xs pd-y-6 pd-x-15" onclick="newSpecial();">采用</button>
            </div>
            <span class="br-pageheader-left pd-y-15"><i class="fa fa-commenting pd-l-20 tx-18"></i></span>
        </div>
      </div> -->
      <!-- br-pageheader -->

      <div class="br-header">
          <!--<div class="br-logo"><img src="http://123.56.71.230:889/cms/img/2019/system_logo.png"></div>-->
          <div class="br-header-left">
              <div class="logo navicon-left"><img class="w-100" src="../img/2019/system_logo.png"></div>
              <div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
              <div id="nav-header" class="hidden-md-down flex-row align-items-center tx-18 mg-l-0-force tx-black-force">| 云专题</div>
          </div><!-- br-header-left -->
          <div class="br-header-right">
              <div class="btn-box" >                
                  <a class="btn btn-info tx-size-xs mg-r-5" href="javascript:self.close();"  id="Image1Href" >返回</a>                
                  <a class="btn btn-info tx-size-xs mg-r-10" id="Image2Href" href="javascript:;" onclick="addSpecialcould();">采用</a>               
              </div>
          </div><!-- br-header-right -->
      </div><!-- br-header -->

  

      <div class="br-pagebody pd-t-30 pd-x-0">
		<iframe src="<%=url%>" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>       
      </div><!-- br-pagebody -->
      
            
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src=".../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>
    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
      <script src="../lib/2018/highlightjs/highlight.pack.js"></script>
      <script src="../common/2018/common2018.js"></script>
      <script src="../common/2018/TideDialog2018.js"></script>
    <!--<script src="../lib/2018/datatables/jquery.dataTables.js"></script>
    <script src="../lib/2018/datatables-responsive/dataTables.responsive.js"></script>-->
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>    
    <script>
        function newSpecial(){	    	
          var url = "newspecial.html";
         
		  	var	dialog = new top.TideDialog();
				dialog.setWidth(500);
				dialog.setHeight(370);
				dialog.setUrl(url);
				dialog.setTitle('正在创建');
				dialog.setChannelName('资讯');
				dialog.show();
	    }
      $(function(){
        'use strict';

        //show only the icons and hide left menu label by default
       

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function(e){
          e.preventDefault();
          if($('body').hasClass('show-mb-left')) {
            $('body').removeClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
          } else {
            $('body').addClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
          }
        });
        
    
		    $("#checkAll,#checkAll_1").click(function(){
		    	if($("#content-table").hasClass("table-fixed")){
		    		var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
		    	}else{
		    		var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
		    	}		    	
		    	var existChecked = false ;
		    	for (var i=0;i<checkboxAll.length;i++) {
		    		if(!checkboxAll.eq(i).prop("checked")){
		    			existChecked = true ;
		    		}
		    	}
		    	if(existChecked){
		    		checkboxAll.prop("checked",true);
		    		$(this).prop("checked",true);
		    	}else{
		    		checkboxAll.removeAttr("checked");
		    		$(this).removeAttr("checked");
		    	}
		    	return;
		    })
		  
		     
		   
      });
      
        function addSpecialcould()
        {   var type=1;//预览界面新建表示
            var ChannelID=<%=ChannelID%>;
            var id=<%=sourceid%>;
            var cloud_id=<%=cloud_id1%>;
        	var url='newnode.jsp?id='+id+'&cloud_id='+cloud_id+'&ChannelID='+ChannelID+'&type='+type;
        	var	dialog = new top.TideDialog();
        		dialog.setWidth(600);
        		dialog.setHeight(500);
        		dialog.setUrl(url);
        		dialog.setTitle("新建专题频道");
        		dialog.show();
        }
    </script>
  </body>
</html>
