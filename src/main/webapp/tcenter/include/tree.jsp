<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%
	String url11 = "/vms/system/pingtai_index.jsp?id=15&flag=6";//
	String encodeUrl11 = URLEncoder.encode(url11, "UTF-8");
	String url22 = "/vms/system/pingtai_index.jsp?id=13&flag=6";//
	String encodeUrl22 = URLEncoder.encode(url22, "UTF-8");
%>
<div class="br-sideleft overflow-y-auto">
	<label class="sidebar-label pd-x-15 mg-t-20"></label>

	<div class="br-sideleft-menu">
		<a href="/tcenter/tcenter/main_system2018.jsp" class="br-menu-link menu-home">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-home tx-22"></i>
				<span class="menu-item-label">概览</span>
			</div>
			<!-- menu-item -->
		</a>

		<!-- 结构管理-->
		<a href="#" class="br-menu-link menu-channel">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-sitemap tx-20"></i>
				<span class="menu-item-label">结构管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>

		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-channel">
			<li class="nav-item"><a href="/tcenter/channel/pingtai_channel.jsp" class="nav-link system-menu3" id="system-menu-cms-channel">内容结构管理</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/channel/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-vms-channel">媒资结构管理</a></li>
		</ul>

		<!-- 系统配置管理-->
		<a href="#" class="br-menu-link menu-system-pingtai" id="menu-system">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-gears  tx-20"></i>
				<span class="menu-item-label">配置管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<ul class="br-menu-sub nav flex-column" id="system-menu-pingtai">

			<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=1" class="nav-link system-menu1" id="system-menu-license">平台许可证</a></li><%}%>
			<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=1" class="nav-link system-menu1" id="system-menu-license-vms">媒资许可证</a></li><%}%>
			<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=2" class="nav-link system-menu2" id="system-menu-parameter">平台系统参数</a></li><%}%>
			<li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=11" class="nav-link system-menu11" id="system-menu-approve">工作流管理</a></li>
			<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=10" class="nav-link system-menu10" id="system-menu-photoscheme">内容图片尺寸</a></li>   <%}%>
			<li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=12" class="nav-link system-menu12" id="system-menu-watermark">内容水印方案</a></li>

			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=2" class="nav-link system-menu" id="system-menu-vms-parameter">媒资系统参数</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=16" class="nav-link system-menu" id="system-menu-naly">AI功能配置</a></li>

			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=10" class="nav-link system-menu" id="system-menu-vms-photoscheme">转码服务器配置</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=11" class="nav-link system-menu" id="system-menu-photoscheme2">视频转码方案</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=12" class="nav-link system-menu" id="system-menu-vms-watermark">视频水印方案</a></li>

			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=<%=encodeUrl22%>" class="nav-link system-menu" id="system-menu-photoscheme3">视频全局配置</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=14" class="nav-link system-menu" id="system-menu-photoscheme4">视频目录配置</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=<%=encodeUrl11%>" class="nav-link system-menu" id="system-menu-chatiao">视频拆条配置</a></li>
			<li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=13" class="nav-link system-menu12" id="system-menu-loginverify">登陆验证</a></li>

		</ul>

		<!-- 站点管理-->
		<a href="#" class="br-menu-link menu-site">
			<div class="br-menu-item ">
				<i class="menu-item-icon fa fa-gear tx-22"></i>
				<span class="menu-item-label">站点管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
	
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-site" >
			<li class="nav-item"><a href="/tcenter/system/pingtaiindex.jsp" class="nav-link system-menu3" id="system-menu-cms-site">内容站点管理</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtaiindex.jsp" class="nav-link system-menu3" id="system-menu-vms-site">媒资站点管理</a></li>
		</ul>
	
		<!-- 文件管理-->
		<a href="#" class="br-menu-link menu-exploer">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-folder tx-20"></i>
				<span class="menu-item-label">文件管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
	
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-exploer">
			<li class="nav-item"><a href="/tcenter/explorer/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-cms-exploer">内容文件管理</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/explorer/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-vms-exploer">媒资文件管理</a></li>
		</ul>
		<!-- 模板管理-->
		<a href="#" class="br-menu-link menu-template" >
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-calendar-o tx-20"></i>
				<span class="menu-item-label">模板管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-template">
			<li class="nav-item"><a href="/tcenter/template/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-cms-template">内容模板管理</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/template/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-vms-template">媒资模板管理</a></li>
		</ul>

		<!-- 备份管理-->
		<a href="#" class="br-menu-link menu-backup">
			<div class="br-menu-item">
				<i class="menu-item-icon  fa fa-clone tx-20"></i>
				<span class="menu-item-label">备份管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-backup">
			<li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=7" class="nav-link system-menu3" id="system-menu-cms-backup">内容管理备份</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=7" class="nav-link system-menu3" id="system-menu-vms-backup">媒资管理备份</a></li>
		</ul>
		<!-- 备份管理-->
		<a href="#" class="br-menu-link menu-publish">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-share  tx-20"></i>
				<span class="menu-item-label">分发管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-publish">
			<li class="nav-item"><a href="/tcenter/publish/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-cms-publish">内容分发管理</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/publish/pingtai_index.jsp" class="nav-link system-menu3" id="system-menu-vms-publish">媒资分发管理</a></li>
		</ul>
		<!-- 备份管理-->
		<a href="#" class="br-menu-link menu-manager">
			<div class="br-menu-item">
				<i class="menu-item-icon  fa fa-desktop tx-20"></i>
				<span class="menu-item-label">系统监控</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-manager">
			<li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=8" class="nav-link system-menu3" id="system-menu-cms-manager">内容系统监控</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=8" class="nav-link system-menu3"id="system-menu-vms-manager">媒资系统监控</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/check/pingtai_index.jsp" class="nav-link system-menu3"	id="system-menu-vms-manager1">转码任务监测</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/check/pingtai_kuaibian_index.jsp" class="nav-link system-menu3" id="system-menu-vms-manager2">快编任务检测</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/check/pingtai_chatiao_index.jsp" class="nav-link system-menu3" id="system-menu-vms-manager3">拆条任务检测</a></li>
		</ul>
		<!-- 系统调度管理-->
		<a href="#" class="br-menu-link menu-quartz">
			<div class="br-menu-item">
				<i class="menu-item-icon  fa fa-joomla  tx-20"></i>
				<span class="menu-item-label">调度管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-quartz">
			<li class="nav-item"><a href="/tcenter/system/pingtai_index.jsp?id=9" class="nav-link system-menu3" id="system-menu-cms-quartz">内容调度管理</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/pingtai_index.jsp?id=9" class="nav-link system-menu3" id="system-menu-vms-quartz">媒资调度管理</a></li>
		</ul>

		<!-- 采集系统 -->
		<a href="/tcenter/spider/pingtai_index.jsp" class="br-menu-link  menu-spider">
			<div class="br-menu-item">
				<i class="menu-item-icon  fa fa-cloud-download tx-20"></i>
				<span class="menu-item-label">采集系统</span>
			</div>
			<!-- menu-item -->
		</a>

	</div><!-- br-sideleft-menu -->
</div><!-- br-sideleft -->
