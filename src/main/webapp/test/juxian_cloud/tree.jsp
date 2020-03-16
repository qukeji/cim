<%@ page contentType="text/html;charset=utf-8" %>
<div class="br-sideleft overflow-y-auto">
	<label class="sidebar-label pd-x-15 mg-t-20"></label>
	<div class="br-sideleft-menu">
	<%if(userinfo_session.getRole()==1){%>
		<a href="../main.jsp" class="br-menu-link menu-home" id="menu-home">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-home tx-20"></i>
			<span class="menu-item-label">主页</span>
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->
		<a href="../explorer/index2018.jsp" class="br-menu-link menu-explorer" id="menu-explorer">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-folder tx-20"></i>
			<span class="menu-item-label">文件管理</span>            
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->    
		<a href="../channel/index2018.jsp" class="br-menu-link menu-channel" id="menu-channel">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-sitemap tx-20"></i>
			<span class="menu-item-label">结构管理</span>
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->
		<a href="../source/index2018.jsp" class="br-menu-link menu-source" id="menu-source">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-database tx-20"></i>
			<span class="menu-item-label">资源中心</span>            
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->    
			
<!--		
		<a href="../lib/index2018.jsp" class="br-menu-link menu-lib" id="menu-lib">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-file tx-20"></i>
			<span class="menu-item-label">内容中心</span>           
		  </div>
		</a>      
	
		<a href="../content/index2018.jsp" class="br-menu-link menu-content" id="menu-content">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-desktop tx-20"></i>
			<span class="menu-item-label">界面管理</span>            
		  </div>
		</a>     
		<a href="../sns/index2018.jsp" class="br-menu-link menu-sns" id="menu-sns">
		  <div class="br-menu-item">
			<i class="menu-item-icon icon ion-person-stalker tx-20"></i>
			<span class="menu-item-label">社区管理</span>            
		  </div>
		</a>
-->   	
		<a href="../lib/appIndex2018.jsp?childGroup=1" class="br-menu-link menu-app" id="menu-app">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-tablet tx-26"></i>
				<span class="menu-item-label">APP管理</span>
			</div>
		</a>
                                  
		<a href="../lib/appIndex2018.jsp?childGroup=2" class="br-menu-link menu-userManage" id="menu-userManage">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-user tx-26"></i>
				<span class="menu-item-label">用户管理</span>
			</div>
		   
		</a>
                                   
		<a href="../lib/appIndex2018.jsp?childGroup=3" class="br-menu-link menu-standard" id="menu-standard">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-comments-o tx-20"></i>
				<span class="menu-item-label">互动管理</span>
			</div>
		</a>
		<a href="../lib/webIndex.jsp" class="br-menu-link menu-interactive" id="menu-interactive">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-desktop tx-18"></i>
				<span class="menu-item-label">内容管理</span>
			</div>                                     
		</a>        
		<a href="#" class="br-menu-link menu-system" id="menu-system">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-gear tx-20"></i>
			<span class="menu-item-label">系统管理</span>
			<i class="menu-item-arrow fa fa-angle-down"></i>
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->  

		<ul class="br-menu-sub nav flex-column" id="system-menu">
		  <li class="nav-item">
			<a href="../system/index2018.jsp" class="nav-link br-menu-item system-menu" id="system-menu-system">站点配置</a>         	
		  </li>
		  <li class="nav-item"><a href="../system/index_2018.jsp?id=1" class="nav-link system-menu" id="system-menu-license">许可证</a></li>
		  <li class="nav-item"><a href="../system/index_2018.jsp?id=2" class="nav-link system-menu" id="system-menu-parameter">系统参数</a></li>
		  <li class="nav-item"><a href="../system/index_2018.jsp?id=3" class="nav-link system-menu" id="system-menu-operate">操作日志</a></li>
		  <li class="nav-item"><a href="../system/index_2018.jsp?id=4" class="nav-link system-menu" id="system-menu-login">登录日志</a></li>
		  <li class="nav-item"><a href="../system/index_2018.jsp?id=5" class="nav-link system-menu" id="system-menu-error">错误日志</a></li>
		  <li class="nav-item"><a href="../system/index_2018.jsp?id=6" class="nav-link system-menu" id="system-menu-systemlog">系统日志</a></li>
		  <li class="nav-item"><a href="../system/index_2018.jsp?id=7" class="nav-link system-menu" id="system-menu-backup">备份中心</a></li>
		  <li class="nav-item"><a href="../system/index_2018.jsp?id=8" class="nav-link system-menu" id="system-menu-manager">系统监控</a></li>
		  <li class="nav-item"><a href="../system/index_2018.jsp?id=9" class="nav-link system-menu" id="system-menu-quartz">调度管理</a></li>
		  <li class="nav-item"><a href="../system/index_2018.jsp?id=10" class="nav-link system-menu" id="system-menu-photoscheme">图片尺寸</a></li>          
		  <li class="nav-item"><a href="../template/index2018.jsp" class="nav-link system-menu" id="system-menu-template">模板管理</a></li>
		  <li class="nav-item"><a href="../user/index2018.jsp" class="nav-link system-menu" id="system-menu-user">用户管理</a></li>
		  <li class="nav-item"><a href="../publish/index2018.jsp" class="nav-link system-menu" id="system-menu-publish">发布进程管理</a></li>
		  <li class="nav-item"><a href="../report/index2018.jsp" class="nav-link system-menu" id="system-menu-report">工作量统计</a></li>
		  <li class="nav-item"><a href="../spider/index2018.jsp" class="nav-link system-menu" id="system-menu-spider">采集系统</a></li>
		</ul>
		<%}else if(userinfo_session.getRole()==2||userinfo_session.getRole()==3){%>
		<a href="../main.jsp" class="br-menu-link menu-home" id="menu-home">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-home tx-20"></i>
			<span class="menu-item-label">主页</span>
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->
		<a href="../source/index2018.jsp" class="br-menu-link menu-source" id="menu-source">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-database tx-20"></i>
			<span class="menu-item-label">资源中心</span>            
		  </div><!-- menu-item -->
		</a><!-- br-menu-link --> 
		<a href="../lib/appIndex2018.jsp?childGroup=1" class="br-menu-link menu-app" id="menu-app">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-tablet tx-26"></i>
				<span class="menu-item-label">APP管理</span>
			</div>
		</a>
		<a href="../lib/appIndex2018.jsp?childGroup=2" class="br-menu-link menu-userManage" id="menu-userManage">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-user tx-26"></i>
				<span class="menu-item-label">用户管理</span>
			</div>
		</a>
		<a href="../lib/appIndex2018.jsp?childGroup=3" class="br-menu-link menu-standard" id="menu-standard">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-comments-o tx-20"></i>
				<span class="menu-item-label">互动管理</span>
			</div>
		</a>
	    <a href="../lib/webIndex.jsp" class="br-menu-link menu-interactive" id="menu-interactive">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-desktop tx-18"></i>
				<span class="menu-item-label">网站管理</span>
			</div>                                     
		</a>        
               								
		<%}else if(userinfo_session.getRole()==4){%>
		<a href="../content/index2018.jsp" class="br-menu-link menu-content" id="menu-content">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-desktop tx-20"></i>
			<span class="menu-item-label">界面管理</span>            
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->   
		<%}%>
      </div><!-- br-sideleft-menu -->     
    </div><!-- br-sideleft -->
