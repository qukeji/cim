<%@ page contentType="text/html;charset=utf-8" %>
<div class="br-sideleft overflow-y-auto">
	<label class="sidebar-label pd-x-15 mg-t-20"></label>
	<div class="br-sideleft-menu">
			<a href="wenzheng_main_.jsp" class="br-menu-link menu-home " id="menu-home">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-home tx-22"></i>
						<span class="menu-item-label">概览</span>
					</div>
				</a>
				<a href="wenzhengIndex2018.jsp" class="br-menu-link menu-userManage active" id="menu-userManage">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-list tx-20"></i>
						<span class="menu-item-label">问政管理系统</span>
					</div>
				</a>
		    	<a href="../wenzheng_reason.jsp" class="br-menu-link menu-channel">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-question-circle tx-22"></i>
						<span class="menu-item-label" >问题汇总</span>
					</div>
				</a>				
				<!-- br-menu-link -->
				<a href="javascript:content(channelid=16211);" class="br-menu-link menu-source">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-bar-chart tx-20"></i>
						<span class="menu-item-label">各部门统计</span>
					</div>
					<!-- menu-item -->
				</a>
				
      </div><!-- br-sideleft-menu -->     
    </div><!-- br-sideleft -->
	<script>
	function content(channelid){
	    
	 changeFrameSrc( window.frames["content_frame"] , "../../content/content2018.jsp?id="+channelid );
	}
	</script>