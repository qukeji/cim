<%
    TideJson politics = CmsCache.getParameter("sys_tcenter_system").getJson();
    int cms_site=politics.getInt("tcenter_pingtai_site");
    int cms_channel=politics.getInt("tcenter_pingtai_channel");
    int cms_explore=politics.getInt("tcenter_pingtai_explore");
%>
<%@ page contentType="text/html;charset=utf-8" %>
<div class="br-sideleft overflow-y-auto">
	<label class="sidebar-label pd-x-15 mg-t-20"></label>

	<div class="br-sideleft-menu">
		<a href="/tcenter/operate/operate_main.jsp" class="br-menu-link menu-home">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-home tx-22"></i>
				<span class="menu-item-label">概览</span>
			</div>
			<!-- menu-item -->
		</a>
		<a href="" class="br-menu-link menu-company">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-user-plus tx-20"></i>
				<span class="menu-item-label">租户管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<ul class="br-menu-sub nav flex-column" id="system-menu-company">
			<li class="nav-item"><a href="/tcenter/tcenter/company/operate_index.jsp"  class="nav-link system-menu3" id="system-menu-cms-company">所有租户</a></li>
			<li class="nav-item"><a href="/tcenter/operate/request/request_index.jsp"  class="nav-link system-menu3" id="system-menu-cms-request">开通申请</a></li>
		</ul>
		<a href="/tcenter/operate/storage/storage_index.jsp"  class="br-menu-link menu-storage">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-hdd-o tx-20"></i>
				<span class="menu-item-label">存储管理</span>
			</div>
		</a>


		<a href="/tcenter/user/operate_index.jsp" class="br-menu-link menu-users">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-users tx-20"></i>
				<span class="menu-item-label">用户管理</span>
			</div>
		</a>
		<a href="/tcenter/tcenter/notice/operate_index.jsp" class="br-menu-link  menu-notice">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-bell tx-22-force"></i>
				<span class="menu-item-label">通知管理</span>
			</div>
			<!-- menu-item -->
		</a>


		<a href="#" class="br-menu-link  menu-product">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-cubes tx-20"></i>
				<span class="menu-item-label">产品管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-product">
			<li class="nav-item"><a href="/tcenter/tcenter/product/operate_index.jsp" class="nav-link system-menu3" id="system-menu-cms-product">所有产品</a></li>
			<li class="nav-item"><a href="/tcenter/tcenter/navigation/operate_index.jsp" class="nav-link system-menu3" id="system-menu-navigation-product">快捷导航管理</a></li>
		</ul>
		<a href="/tcenter/operate/job/job_index.jsp" class="br-menu-link  menu-job">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-list-ol tx-22-force"></i>
				<span class="menu-item-label">工单管理</span>
			</div>
			<!-- menu-item -->
		</a>

		<!-- 工作量统计-->
		<a href="#" class="br-menu-link menu-report">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-calculator tx-20"></i>
				<span class="menu-item-label">工作量统计</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-report">
			<li class="nav-item"><a href="/tcenter/report/operate_index.jsp" class="nav-link system-menu3" id="system-menu-cms-report">内容工作量统计</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/report/operate_index.jsp" class="nav-link system-menu3" id="system-menu-vms-report">媒资工作量统计</a></li>
		</ul>
		<!-- 日志管理-->
		<a href="#" class="br-menu-link menu-log" id="system-manage">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-wpforms tx-20"></i>
				<span class="menu-item-label">日志管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link
		<ul class="br-menu-sub nav flex-column" id="system-menu-log">
			<li class="nav-item"><a href="/tcenter/system/pingtai_log_index.jsp" class="nav-link system-menu3" id="system-menu-cms-log">内容日志管理</a></li>
			<li class="nav-item"><a href="/vms/system/pingtai_log_index.jsp" class="nav-link system-menu3" id="system-menu-vms-log">媒资日志管理</a></li>
		</ul>-->
		<ul class="br-menu-sub nav flex-column" id="system-manager-menu">
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/tcenter/system/operate_index.jsp?id=1" class="nav-link system-menu3" id="system-menu-operate">内容操作日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/tcenter/system/operate_index.jsp?id=2" class="nav-link system-menu3" id="system-menu-login">内容登陆日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/tcenter/system/operate_index.jsp?id=3" class="nav-link system-menu3"	id="system-menu-error">内容错误日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/tcenter/system/operate_index.jsp?id=4" class="nav-link system-menu3" id="system-menu-system">内容系统日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/operate_index.jsp?id=5" class="nav-link system-menu3" id="system-menu-vms-operate">媒资操作日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/operate_index.jsp?id=6" class="nav-link system-menu3" id="system-menu-vms-login">媒资登陆日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/operate_index.jsp?id=7" class="nav-link system-menu3"	id="system-menu-vms-error">媒资错误日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/operate_index.jsp?id=8" class="nav-link system-menu3" id="system-menu-vms-system">媒资系统日志</a></li>
		</ul>
	</div><!-- br-sideleft-menu -->
</div><!-- br-sideleft -->
