<%@ page contentType="text/html;charset=utf-8" %>
<div class="br-sideleft overflow-y-auto">
	<label class="sidebar-label pd-x-15 mg-t-20"></label>
	<div class="br-sideleft-menu">
	<%if(userinfo_session.getRole()==1){%>
		<a href="main.jsp" class="br-menu-link menu-home" id="menu-home">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-home tx-20"></i>
			<span class="menu-item-label">主页</span>
		  </div>
		</a>
		<a href="source_index2018.jsp" class="br-menu-link menu-source" id="menu-source">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-database tx-20"></i>
			<span class="menu-item-label">资源中心</span>            
		  </div>
		</a>
		<a href="appIndex2018.jsp?childGroup=1" class="br-menu-link menu-app" id="menu-app">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-tablet tx-26"></i>
				<span class="menu-item-label">APP管理</span>
			</div>
		</a>
       	<a href="appIndex2018.jsp?childGroup=4" class="br-menu-link menu-app_setting" id="menu-app_setting">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-cogs tx-16"></i>
				<span class="menu-item-label">配置管理</span>
			</div>
		</a>
    	<a href="appIndex2018.jsp?childGroup=5" class="br-menu-link menu-app_auto_package" id="menu-app_auto_package">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-suitcase tx-16"></i>
				<span class="menu-item-label">App打包</span>
			</div>
		</a>
                                
		<a href="appIndex2018.jsp?childGroup=2" class="br-menu-link menu-userManage" id="menu-userManage">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-user tx-26"></i>
				<span class="menu-item-label">用户管理</span>
			</div>
		   
		</a>
                                   
		<a href="appIndex2018.jsp?childGroup=3" class="br-menu-link menu-standard" id="menu-standard">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-comments-o tx-20"></i>
				<span class="menu-item-label">互动管理</span>
			</div>
		</a>
		
		<%if(userinfo_session.hasPermission("ManageSystem")){%>
		<a href="#" class="br-menu-link menu-system" id="menu-system" hidden="hidden">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-gear tx-20"></i>
			<span class="menu-item-label">系统管理</span>
			<i class="menu-item-arrow fa fa-angle-down"></i>
		  </div>
		</a>
		<ul class="br-menu-sub nav flex-column" id="system-menu" hidden="hidden">
		 
		 
		  <li class="nav-item"><a href="system_index_2018.jsp?id=3" class="nav-link system-menu3" id="system-menu-operate">操作日志</a></li>
		  <li class="nav-item"><a href="system_index_2018.jsp?id=4" class="nav-link system-menu4" id="system-menu-login">登录日志</a></li>
		  <li class="nav-item"><a href="system_index_2018.jsp?id=5" class="nav-link system-menu5" id="system-menu-error">错误日志</a></li>
		  <li class="nav-item"><a href="system_index_2018.jsp?id=6" class="nav-link system-menu6" id="system-menu-systemlog">系统日志</a></li>
		  
		   
		  <li class="nav-item"><a href="template_index2018.jsp" class="nav-link system-menu" id="system-menu-template">模板管理</a></li>
		  <li class="nav-item"><a href="user_index2018.jsp" class="nav-link system-menu" id="system-menu-user">用户管理</a></li>
		  <li class="nav-item"><a href="report_index2018.jsp" class="nav-link system-menu" id="system-menu-report">工作量统计</a></li>
		  <%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="spider_index2018.jsp" class="nav-link system-menu" id="system-menu-spider">采集系统</a></li><%}%>
		</ul>
		<%}%>

		<%}else if(userinfo_session.getRole()==3){%>
		<a href="main.jsp" class="br-menu-link menu-home" id="menu-home">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-home tx-20"></i>
			<span class="menu-item-label">主页</span>
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->
		<a href="source_index2018.jsp" class="br-menu-link menu-source" id="menu-source">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-database tx-20"></i>
			<span class="menu-item-label">资源中心</span>            
		  </div><!-- menu-item -->
		</a><!-- br-menu-link --> 
		<a href="appIndex2018.jsp?childGroup=1" class="br-menu-link menu-app" id="menu-app">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-tablet tx-26"></i>
				<span class="menu-item-label">APP管理</span>
			</div>
		</a>
		<a href="appIndex2018.jsp?childGroup=4" class="br-menu-link menu-app_setting" id="menu-app_setting">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-eye tx-16"></i>
				<span class="menu-item-label">配置管理</span>
			</div>
		</a>
           
		<a href="appIndex2018.jsp?childGroup=2" class="br-menu-link menu-userManage" id="menu-userManage">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-user tx-26"></i>
				<span class="menu-item-label">用户管理</span>
			</div>
		</a>
		<a href="appIndex2018.jsp?childGroup=3" class="br-menu-link menu-standard" id="menu-standard">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-comments-o tx-20"></i>
				<span class="menu-item-label">互动管理</span>
			</div>
		</a>
	           
               								
		<%}else if(userinfo_session.getRole()==4){%>
		<a href="content_index2018.jsp" class="br-menu-link menu-content" id="menu-content">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-desktop tx-20"></i>
			<span class="menu-item-label">界面管理</span>            
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->   
		<%}%>
      </div><!-- br-sideleft-menu -->     
    </div><!-- br-sideleft -->
