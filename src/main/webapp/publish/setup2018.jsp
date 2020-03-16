<%@ page import="java.io.*,tidemedia.cms.util.*,
				java.util.*,
				java.net.URL,
				tidemedia.cms.publish.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
	if(!userinfo_session.isAdministrator())
	{out.close();return;}

	String Action = getParameter(request,"Action");
	int SiteId=Util.getIntParameter(request,"SiteId");

	if(SiteId!=0){

		tidemedia.cms.system.Site site=tidemedia.cms.system.CmsCache.getSite(SiteId);
		String siteName=site.getName();
		ArrayList publishSchemes=site.getPublishSchemes();

		if(Action.equals("Del"))
		{
			int id = getIntParameter(request,"id");

			PublishScheme pt = new PublishScheme();

			pt.setUserId(userinfo_session.getId());
			pt.Delete(id);
			response.sendRedirect("setup2018.jsp?SiteId="+SiteId);return;
		}

		String Publish = getParameter(request,"Publish");

		if(!Publish.equals("")  && !userinfo_session.hasPermission("DisableChangePublish"))
		{
			URL path=this.getClass().getClassLoader().getResource("cms.config.xml");
			FileOutputStream os = new FileOutputStream(path.getFile());
			os.close();
			response.sendRedirect("setup2018.jsp");return;
		}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="Shortcut Icon" href="../favicon.ico">
	<title>TideCMS 7 列表</title>

	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
	<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
	<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
	<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	<style>
		.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
	</style>

	<script src="../lib/2018/jquery/jquery.js"></script>

	<script>
		var myObject = new Object();
		myObject.title = "";

		function del(id)
		{

			var url="setup_del2018.jsp?id="+id;
			var	dialog = new top.TideDialog();
			dialog.setWidth(320);
			dialog.setHeight(260);
			dialog.setUrl(url);
			dialog.setTitle("删除发布方案");
			dialog.show();

		}
		function Change(i)
		{
			this.location.href = "setup.jsp?Publish="+i;
		}

		function addTask()
		{
			var url="publish_add2018.jsp?SiteId=<%=SiteId%>";
			var	dialog = new top.TideDialog();
			dialog.setWidth(780);
			dialog.setHeight(450);
			dialog.setUrl(url);
			dialog.setTitle("添加发布方案");
			dialog.show();
		}

		function editTask(id)
		{
			var url="publish_edit2018.jsp?id="+id;
			var	dialog = new top.TideDialog();
			dialog.setWidth(780);
			dialog.setHeight(450);
			dialog.setUrl(url);
			dialog.setTitle("编辑发布方案");
			dialog.show();
		}

		function testTask(id)
		{
			var url="publish_test2018.jsp?id="+id;
			var	dialog = new top.TideDialog();
			dialog.setWidth(450);
			dialog.setHeight(450);
			dialog.setUrl(url);
			dialog.setTitle("测试发布方案");
			dialog.show();
		}

		function Publish_Enable(id)
		{
			var url = "change_status.jsp?Action=Enable&id="+id+"&SiteId=<%=SiteId%>";
			this.location.href = url;
		}

		function Publish_Disable(id,o)
		{
			var url = "change_status.jsp?Action=Disable&id="+id+"&SiteId=<%=SiteId%>";
			this.location.href = url;
		}

	</script>
</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">

	<div class="br-pageheader pd-y-15 pd-md-l-20">
		<nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active"> 内容分发管理 / <%=siteName%>
		  <%if("".equals(siteName) && siteName==null) {
			  out.println(" 发布设置");
		  }else{
			  out.println(" / 发布设置");
		  }%>

		  </span>
		</nav>
	</div><!-- br-pageheader -->

	<!--列表-->
	<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">
				<thead>
				<tr>
					<th class="wd-5p">编号</th>
					<th class="tx-12-force tx-mont tx-medium">发布方案名</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">文件复制方式</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">目标</th>
					<th class="tx-12-force wd-350 tx-mont tx-medium hidden-xs-down">操作</th>
				</tr>
				</thead>
				<tbody>
				<%
					if(publishSchemes!=null && publishSchemes.size()>0)
					{
						for(int j=0;j<publishSchemes.size();j++)
						{
							PublishScheme publishScheme=(PublishScheme)publishSchemes.get(j);
							String DestDesc = "";
							String CopyModeDesc = "";
							String Name = convertNull(publishScheme.getName());
							int Status =publishScheme.getStatus();
							int CopyMode =publishScheme.getCopyMode();
							if(CopyMode==1)
							{
								CopyModeDesc = "FTP上传";
								DestDesc = convertNull(publishScheme.getServer());
							}
							else if(CopyMode==2)
							{
								CopyModeDesc = "文件拷贝";
								DestDesc = convertNull(publishScheme.getDestFolder());
							}
							else if(CopyMode==3)
							{
								CopyModeDesc = "S3云存储";
							}
							else if(CopyMode==4)
							{
								CopyModeDesc = "OpenStack云存储";
							}
							else if(CopyMode==5)
							{
								CopyModeDesc = "阿里云存储";
							}
							else if(CopyMode==6)
							{
								CopyModeDesc = "百度云存储";
							}

							int id =publishScheme.getId();

				%>
				<tr>
					<td class="hidden-xs-down"><%=id%></td>
					<td class="hidden-xs-down"><%=Name%></td>
					<td class="hidden-xs-down"><%=CopyModeDesc%></td>
					<td class="hidden-xs-down"><%=DestDesc%></td>
					<td class="dropdown hidden-xs-down">
						<button class="btn btn-info btn-sm mg-r-8 tx-13 <%=Status==0?"":"disabled"%>" onclick="Publish_Enable(<%=id%>);">启动</button>
						<button class="btn btn-info btn-sm mg-r-8 tx-13 <%=Status==1?"":"disabled"%>" onclick="Publish_Disable(<%=id%>,this);">禁止</button>
						<%if(!userinfo_session.hasPermission("DisableEditPublishScheme")){%>
						<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="editTask(<%=id%>);">编辑</button>
						<%}%>
						<!--	<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="if(confirm('你确认要删除吗?')) location='setup2018.jsp?Action=Del&id=<%=id%>&SiteId=<%=SiteId%>'; else return false;">删除</button> -->
						<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="if(confirm('你确认要删除吗?')) location='setup2018.jsp?Action=Del&id=<%=id%>&SiteId=<%=SiteId%>'; else return false;">删除</button>
						<%if(CopyMode==1){%>
						<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="testTask(<%=id%>);">测试</button>
						<%}%>
					</td>
				</tr>
				<%  }
				}
				%>
				<tr>
					<td class="hidden-xs-down">……</td>
					<td class="hidden-xs-down">……</td>
					<td class="hidden-xs-down">……</td>
					<td class="hidden-xs-down">……</td>
					<td class="dropdown hidden-xs-down">
						<%if(!userinfo_session.hasPermission("DisableAddPublishScheme")){%>
						<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="addTask();">添加新发布方案</button>
						<%}%>
					</td>
				</tr>

				</tbody>
			</table>
		</div>
	</div><!--列表-->

	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

	<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
	<script src="../lib/2018/select2/js/select2.min.js"></script>
	<script src="../common/2018/bracket.js"></script>

	<script>

		//==========================================

		//===========================================
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


			$("#content-table tr:gt(0)").click(function () {
				if ($(this).find(":checkbox").prop("checked"))// 此处要用prop不能用attr，至于为什么你测试一下就知道了。
				{
					$(this).find(":checkbox").removeAttr("checked");
				}else{
					$(this).find(":checkbox").prop("checked", true);
				}
			});
			$("#checkAll,#checkAll_1").click(function(){
				var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
				var existChecked = false ;
				for (var i=0;i<checkboxAll.length;i++) {
					if(!checkboxAll.eq(i).prop("checked")){
						existChecked = true ;
					}
				}
				if(existChecked){
					checkboxAll.prop("checked",true);
				}else{
					checkboxAll.removeAttr("checked");
				}
				return;
			})
			$(".btn-search").click(function(){
				$(".search-box").toggle(100);
			})

			// Datepicker
			$('.fc-datepicker').datepicker({
				showOtherMonths: true,
				selectOtherMonths: true
			});

		});
	</script>
</div>
</body>
</html>
<%}%>
