<%@ page contentType="text/html;charset=utf-8" %>
<ul id="fast-nav" class="nav nav-outline align-items-center flex-row mg-l-auto mg-r-30" role="tablist">

	<%
		//	Navigation navi = new Navigation(navi_id);
//	int navi_parent = navi.getParent();//一级导航id
	int nav_role = userinfo_session.getRole();
	int nav_company = userinfo_session.getCompany();
	boolean nav_yunying = userinfo_session.hasPermission("OperateSystem");
	Navigation n = new Navigation();
	org.json.JSONArray arr_na = n.NavigationList(0);
	for(int i=0;i<arr_na.length();i++){
		org.json.JSONObject obj_na = arr_na.getJSONObject(i);
		
	%>
	<li class="nav-item dropdown">
		<a class=" nav-parent-a"  data-toggle="dropdown" href="javascript:;" role="tab" aria-expanded="false" data-url="<%=obj_na.getString("Href")%>" data-newpage="<%=obj_na.getInt("newpage")%>">
			<%=obj_na.getString("Title")%> 
			<%if(obj_na.getInt("hasNextLevel")==1){%><i class="fa fa-angle-down mg-l-5"></i><%}%>
		</a>
		<%if(obj_na.getInt("hasNextLevel")==1){%>
		<div class="dropdown-menu dropdown-menu-header">
			<nav class="nav flex-column ">
				<%
				int parent_na = obj_na.getInt("id");
				org.json.JSONArray arr_na1 = n.NavigationList(parent_na);
				for(int j=0;j<arr_na1.length();j++){
					org.json.JSONObject obj_na1 = arr_na1.getJSONObject(j);
					if("租户运营中心".equals(obj_na1.getString("Title"))||"平台管理中心".equals(obj_na1.getString("Title"))){
						if(nav_role!=1){
							continue;
						}
						if(nav_role==1&&nav_company!=0){
							continue;
						}
						if("租户运营中心".equals(obj_na1.getString("Title"))){
							if(!nav_yunying){
								continue;
							}
						}
					}

				%>
					<a href="javascript:;" class="nav-link" data-url="<%=obj_na1.getString("Href")%>" data-newpage="<%=obj_na1.getInt("newpage")%>">
						<span class="mg-r-10">●</span><%=obj_na1.getString("Title")%>
					</a>
				<%}%>
			</nav>
		</div>
		<%}%>
	</li>
	<%}%>
</ul>

<div class="br-header-right">
	<div class="navicon-right">
		<a id="workstate" href="/tcenter/work/main.jsp"  class="pos-relative" title="个人工作台">
			<i class="icon fa fa-laptop tx-28-force"></i>
		</a>
	</div>
	<div class="navicon-right">
		<a id="workflow" href="/tcenter/work/main.jsp#/workflow" class="pos-relative" title="个人工作流">
			<i class="icon fa fa-random tx-26-force"></i>
		</a>
	</div>
	<nav class="nav">
		<div class="dropdown">
			<a href="" class="nav-link nav-link-profile" data-toggle="dropdown">
				<i class="icon fa fa-user-circle-o  tx-26-force"></i>
			</a>
			<div class="dropdown-menu dropdown-menu-header wd-200">
				<span class="logged-name mg-l-15 pd-y-5">你好，<%=userinfo_session.getName()%></span>
				<ul class="list-unstyled user-profile-nav">
					<li><a href="/tcenter/person/index2018.jsp"><i class="icon ion-ios-person"></i> 个人信息</a></li>
					<li><a href="/tcenter/logout.jsp"><i class="icon ion-power"></i> 退出</a></li>
				</ul>
			</div>
			<!-- dropdown-menu -->
		</div>
		<!-- dropdown -->
	</nav>
</div>
<!-- br-header-right -->
