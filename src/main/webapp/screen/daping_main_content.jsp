<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.util.Date,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<!DOCTYPE html>
<html id="blue">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../<%=ico%>">
    <title>结构管理</title>
    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
   
    <link rel="stylesheet" href="../style/2018/bracket.css">  
    <link rel="stylesheet" href="../style/2018/common.css">
    <link rel="stylesheet" href="../style/2018/tcenter.css">
    <link rel="stylesheet" href="../style/2018/theme.css">
    <style>
	.height{
        height:200px !important;
        width:100% !important;
    }
    </style>
    <script src="../lib/2018/jquery/jquery.js"></script>
   
  </head>
 
  <body class="collapsed-menu email content_pages">
   
    <div class="br-mainpanel br-mainpanel-file" id="">      
      
      	<div class="d-flex pd-30">
			<div class="td-logo theme-bg mg-r-10"><i class="tx-white fa fa-desktop tx-36"></i></div>
			<div class="">
				<h4 class="tx-gray-800 mg-b-5">大数据展示管理系统</h4>
				<p class="mg-b-0">本系统用于构建全局多租户用户管理、接入产品的管理以及用户登录日志查看。</p>
			</div>
			
		</div>				
		
		<!-- d-flex -->
		<div class="br-pagebody mg-t-5 pd-x-30">
			<div class="row row-sm">
				<div class="col-sm-12 col-xl-12">
					<div class="theme-bg rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-clock-o tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">运行时间</p>
								<p class="tx-36 tx-white tx-lato tx-bold mg-b-2 lh-1">
									125天23小时32分45秒
								</p>
								
							</div>
						</div>
					</div>
				</div>
				
			</div>
			<!-- row -->

			<div class="row row-sm mg-t-20">
				<div class="col-sm-12 col-xl-8">
					<div class="card pd-0 bd-0 shadow-base">
						<div class="pd-x-30 pd-t-30 pd-b-15">
							<div class="d-flex align-items-center justify-content-between">
								<div>
									<p class="tx-13 tx-uppercase tx-inverse tx-spacing-1 tx-18">
										<i class="fa fa-th-large theme-tx-color mg-r-5"></i>大屏幕展示方案
									</p>										
								</div>									
							</div>
						</div>
						<div class="pd-x-30 pd-b-40 pd-l-20 tide_ite">
							
						</div>
					</div>
					<!-- card -->
				</div>
				<!-- col-9 -->
				<div class="col-sm-12 col-xl-4">
				 <iframe  src="include/usehelp.html" class="height"  frameborder="0" onload="changeFrameHeight(this)" ></iframe>
				</div>
				<!-- col-3 -->
			</div>
			<!-- row -->
		</div>
     


    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>
    
	<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
    
    
    <script src="../common/2018/bracket.js"></script>  
 
    <script>
      $(function(){
        'use strict';

        //show only the icons and hide left menu label by default
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
        
        $(document).on('mouseover', function(e){
          e.stopPropagation();
          if($('body').hasClass('collapsed-menu')) {
            var targ = $(e.target).closest('.br-sideleft').length;
            if(targ) {
              $('body').addClass('expand-menu');

              // show current shown sub menu that was hidden from collapsed
              $('.show-sub + .br-menu-sub').slideDown();

              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.removeClass('d-lg-none');
              menuText.removeClass('op-lg-0-force');

            } else {
              $('body').removeClass('expand-menu');

              // hide current shown menu
              $('.show-sub + .br-menu-sub').slideUp();

              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.addClass('op-lg-0-force');
              menuText.addClass('d-lg-none');
            }
          }
        });

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
         
      });
      
    </script>
    <script type="text/javascript">
    $(function()
    {
       	var url="daping_channel_list.jsp";
        $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            success: function(res){
                console.log(res);
                 res1=res.result;
                var html = "";
                html += '<ul class="screen-case">' ;
                for(var i in res1)
                {
                       html += '<li>' +
                        '<div class="screen-tl">'+
                        '<i class="tx-grey-3 fa fa-arrows-alt"></i>'+
                       res1[i].name+
                        '</div>'+
                        '<div class="screen-num">'+
                        '屏幕数量：'+
                        '<span>'+res1[i].num+
                        '</span>'+
                        "</div>"+
                        '<a href="#" class="screen-scan">'+
                        '浏览'+
                        '</a>'+
                        '</li>'
                        
                }
                html += '</ul>';
                var oContent = $('.tide_ite');
                oContent.html(html);
                

            }
        });
    });

</script>
    
    	
      
    
   </body>
</html>
