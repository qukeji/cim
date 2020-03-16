<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				java.util.*,
				tidemedia.cms.util.*,tidemedia.cms.publish.*,java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}
%>


<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int flag = getIntParameter(request,"flag");

int num1 = 0;
int num2 = 0;
int num22 = 0;
int num3 = 0;
int num4 = 0;
int num4_prepaer=0;
int num4_approved=0;
int num4_approving=0;
int num4_approvefaild=0;
int channel_num = 0;

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();
%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>系统监控</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
    <!--<link href="../../lib/2018/datatables/jquery.dataTables.css" rel="stylesheet">-->
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">  
	<script src="../lib/2018/jquery/jquery.js"></script>
    <style>
    	.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
    	.tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #23BF08;opacity: 1;}
    	.tooltip.bs-tooltip-bottom .arrow::before,
			.tooltip.bs-tooltip-auto[x-placement^="bottom"] .arrow::before {border-bottom-color: #23BF08;	}
			#tide_content_tfoot{min-height: 42px;}
			a{color: #868ba1;}
			a:hover{color: #0866C6;}
    </style>
	<script>
function moveChannel(){
	//alert("test");
	var url= "channel_tools2018.jsp";
	var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(280);
		dialog.setUrl(url);
		dialog.setTitle("频道迁移");
		dialog.show();
	//alert("teset2");
}

function exportChannel(){
	var url= "../system/channel_export_index2018.jsp";
	var	dialog = new top.TideDialog();
		dialog.setWidth(550);
		dialog.setHeight(550);
		dialog.setUrl(url);
		dialog.setTitle("频道导出");
		dialog.show();
}
function importChannel(){
	var url= "../system/channel_import_index2018.jsp";
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(400);
		dialog.setUrl(url);
		dialog.setTitle("频道导入");
		dialog.show();
}

</script>
  </head>

  <body class="collapsed-menu" onload="load()">

    <div class="br-mainpanel br-mainpanel-file" > 	
      <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">系统监控 / 内容系统监控</span>
        </nav>
      </div><!-- br-pageheader -->
 
      <div class="br-pagebody pd-x-20 pd-sm-x-30">
<%
if(flag==1)
{
	Sql = "delete from publish_task where Status=1";
	tu.executeUpdate(Sql);
	//out.println("清空发布任务.");

	Sql = "delete from publish_item where Status=1";
	tu.executeUpdate(Sql);
	//out.println("清空发布过的文件.");

	response.sendRedirect("manager2018.jsp");return;
}
else if(flag==2)
{
	PublishManager.getInstance().clearCopyingFile();
	PublishManager.getInstance().StartFilePublishAgent();
	PublishManager.getInstance().getCopying_files_2016().clear();
	FilePublishAgent.clearCopyingFiles2();
	if(RedisUtil.getInstance().isRedis()){//开启Redis
		RedisUtil.getInstance().ResetQueue(1);//重置全部文件发布任务
	}
	response.sendRedirect("manager2018.jsp");return;
}
else if(flag==3)
{
	PublishManager.getInstance().StartTemplatePublishAgent();
	TemplatePublishAgent.clearPublishingNumber();
	if(RedisUtil.getInstance().isRedis()){//开启Redis
		RedisUtil.getInstance().ResetQueue(2);//重置全部模板发布任务
	}
	//正在发布线程归0
	response.sendRedirect("manager2018.jsp");return;
}
else if(flag==4)
{
	ConcurrentHashMap channels = CmsCache.getChannels();
	channels.clear();
	response.sendRedirect("manager2018.jsp");return;
}
else if(flag==5)
{
	System.gc();
	response.sendRedirect("manager2018.jsp");return;
}

else if(flag==6)
{

	Sql = "select count(*) from publish_task where Status=1";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num1 = Rs.getInt(1);
	}
	tu.closeRs(Rs);

	Sql = "select count(*) from publish_task where Status=0 and CanPublishTime<=UNIX_TIMESTAMP()";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num2 = Rs.getInt(1);
	}
	tu.closeRs(Rs);

	num22 = tu.getNumber("select count(*) from publish_task where Status=0 and CanPublishTime>UNIX_TIMESTAMP()");

	Sql = "select count(*) from publish_item where Status=1";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num3 = Rs.getInt(1);
	}
	tu.closeRs(Rs);

	Sql = "select count(*) from publish_item where Status!=1";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num4 = Rs.getInt(1);
	}
	tu.closeRs(Rs);
	//待发布
	Sql="select count(*) from publish_item where Status=0 or Status=2 ";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num4_prepaer = Rs.getInt(1);
	}
	tu.closeRs(Rs);
	//发布完成
	Sql="select count(*) from publish_item where Status=1 ";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num4_approved = Rs.getInt(1);
	}
	tu.closeRs(Rs);
	//正在发布
	Sql="select count(*) from publish_item where Status=3 ";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num4_approving = Rs.getInt(1);
	}
	tu.closeRs(Rs);
	//发布失败
	Sql="select count(*) from publish_item where Status=4 ";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num4_approvefaild = Rs.getInt(1);
	}
	tu.closeRs(Rs);
	
	ConcurrentHashMap channels = CmsCache.getChannels();
	channel_num = channels.size();

	int mb = 1024*1024;

	String file = "";
	HashMap h = PublishManager.getInstance().publishingFiles;
	file = (String)h.get("1");
	int thread_count= 0;
	int thread_max_count=0;
        ArrayList ftps = FtpManager.getFtps();//数据库连接池
        int ftp_size=ftps.size();//数据库连接池数量

	%>      	
        <div class="card bd  shadow-base">
          <table class="table mg-b-0" id="content-table">
            <thead>
              <tr>                
                <th class="tx-12-force tx-mont tx-medium">&nbsp;</th>                             
              </tr>
            </thead>
            <tbody>
			  <tr>   
                <td> 
                	<span class="mg-r-10">完成的任务数量：<a class="mg-r-3" href="../publish/publish_task.jsp?Status=1"><%=num1%></a></span> 
                	
                </td>               
              </tr>
			   <tr>   
                <td> 
                	<span class="mg-r-10">未完成的任务数量：<a class="mg-r-3" href="../publish/publish_task.jsp?Status=0"><%=num2%></a>(<a href="../publish/publish_task_custom.jsp?Status=0"><%=num2%></a>)</span> 
                	
                </td>               
              </tr>
              <tr>   
                <td> 
                	<span class="mg-r-10">待发布模板任务：<a class="mg-r-3" href="../publish/publish_task_custom.jsp?Status=0"><%=num4_prepaer%></a>(<a href="../publish/publish_task_custom.jsp?Status=0"><%=num4_prepaer%></a>)</span> 
                	<span class="mg-r-10">已发布模板任务：<a class="mg-r-3" href="../publish/publish_task_custom.jsp?Status=1"><%=num4_approved%></a></span> 
                	<span class="">正在发布模板任务：<a class="mg-r-3" href="../publish/publish_task_custom.jsp?Status=2"><%=num4_approving%></a></span> 
                </td>               
              </tr>
              <tr>   
                <td>               
                	<span class="mg-r-10">待分发文件：<a class="mg-r-3" href="../publish/publish_task_custom.jsp?Status=0"><%=num4_prepaer%></a></span> 
                	<span class="mg-r-10">已分发文件：<a class="mg-r-3" href="../publish/publish_task_custom.jsp?Status=1"><%=num4_approved%></a></span>
                	<span class="mg-r-10">正在分发：<a class="mg-r-3" href="../publish/publish_task_custom.jsp?Status=2"><%=num4_approving%></a></span>
                	<span class="mg-r-10">分发失败：<a class="mg-r-3" href="../publish/publish_task_custom.jsp?Status=3"><%=num4_approvefaild%></a></span>                	
                </td>               
              </tr>
              <tr>   
                <td> 
                	<span class="mg-r-10">模板发布线程总数量：<%=thread_max_count%> </span> 
                	<span class="mg-r-10">当前模板发布线程数量：<%=thread_count%></span>
                <!--	<span class="mg-r-10">当前信息：06-08 17:06:15  线程休眠</span>    -->           	
                </td>               
              </tr>
              <tr>                	
                <td> 
                	<span class="mg-r-10">文件分发线程总数量：<%=thread_max_count%></span> 
                	<span class="mg-r-10">当前文件分发线程数量：<%=thread_count%> </span>
                	<span class="mg-r-10">FTP连接池：<%=ftp_size%></span>
                 <!--	<span class="mg-r-10">当前信息：06-08 17:06:15 线程休眠</span>  --> 
                 <!--	<span class="mg-r-10">本次0个分发，0个已经在发，最后一个：</span>       -->           	
                </td>               
              </tr>
              <tr>                	
                <td> 
                	<span class="mg-r-10">总内存：<%=Runtime.getRuntime().totalMemory()/mb%>M</span> 
                	<span class="mg-r-10">空闲内存：<%=Runtime.getRuntime().freeMemory()/mb%>M</span>
                	<span class="mg-r-10">缓存频道数量：<%=channel_num%></span>               	
                </td>               
              </tr>
              <tr>                	
                <td> 
                	<span class="mg-r-10">模板正在生成文件：</span>                 	          	
                </td>               
              </tr>
              <tr>                	
                <td> 
                	<span class="mg-r-10">正在分发文件1：</span>                 	          	
                </td>               
              </tr>
              <tr>                	
                <td> 
                	<span class="mg-r-10">正在分发文件2：</span>                 	          	
                </td>               
              </tr>
          
            </tbody>
          </table>
          <div id="tide_content_tfoot" style="">
          	
          </div>
          
        </div>
<%
	}else{%>		
		<div class="card bd  shadow-base" id="msg"></div>
<script>
	function load()
	{
		$.ajax({
			type: "get",
			url: "manager_data2018.jsp?flag=6",
			success: function(msg){
				$("#msg").html(msg);
				window.setTimeout(load,3000);
			} 
		});
	}
	
</script>
<%}%>		
        <div class="d-flex flex-wrap" id="btn-group">
        	<a href="manager2018.jsp?flag=1" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" data-toggle="tooltip" data-placement="bottom" title="清空已发布模板任务队列，已分发文件队列，当数据量超过20w时，建议及时清空，提高系统性能">
	        	<span>清空</span>
	        </a>
	        <a href="manager2018.jsp?flag=2" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" data-toggle="tooltip" data-placement="bottom" title="当文件上传进程停止工作的时候可以把文件上传进程重新初始化，初始化后自动开始文件上传">
	        	<span>重置文件上传进程</span>
	        </a>
	        <a href="manager2018.jsp?flag=3" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" data-toggle="tooltip" data-placement="bottom" title="当模板发布进程停止工作的时候可以把模板发布进程重新初始化，初始化后自动开始模板发布">
	        	<span>重置模板发布进程</span>
	        </a>
	        <a href="manager2018.jsp?flag=4" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" data-toggle="tooltip" data-placement="bottom" title="重新初始化频道缓存，站点缓存等数据">
	        	<span>初始化缓存</span>
	        </a>
	        <a href="manager2018.jsp?flag=5" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" >
	        	<span>强制GC</span>
	        </a>
	        <a href="show_ehcache.jsp" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" >
	        	<span>查询统计</span>
	        </a>
	        <a href="show_lucene.jsp" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" >
	        	<span>lucene查询</span>
	        </a>
	        <a href="show_catalina.jsp" target="_blank" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" >
	        	<span>查看tomcat日志</span>
	        </a>
	        <a href="data_clear2018.jsp" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" >
	        	<span>数据清理</span>
	        </a>
	        <a href="#" onClick="moveChannel();" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" >
	        	<span>频道迁移</span>
	        </a>
	        <a href="#" onClick="exportChannel();" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" >
	        	<span>频道导出</span>
	        </a>
	        <a href="#" onClick="importChannel();" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" >
	        	<span>频道导入</span>
	        </a>
	        <a href="/tcenter/update/xiangmu.jsp" class="btn btn-primary mg-t-20  mg-r-10 pd-x-15-force pd-y-10-force mg-r-10" >
	        	<span>在线升级</span>
	        </a>
        </div>
       
        
      </div><!-- br-pagebody -->
      
	</div>
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
        
    
       $('[data-toggle="tooltip"]').tooltip({
       	shadowColor:"#ffffff",
       	textColor:"000000"
       });
      });
	  
	  $(function(){
		var tipsTimer = null ;
		$(".t_btn_txt").mouseover(function(){
			clearTimeout(tipsTimer);
			$(this).find(".tips-box").fadeIn(50);
		}).mouseleave(function(){
			var _this = this ;
			popTimer = setTimeout(function(){
				$(_this).find(".tips-box").fadeOut(50);
				clearTimeout(tipsTimer);
			},50)   		
		})	
	});
    </script>
  </body>
</html>
