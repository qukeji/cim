<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.report.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
* 用途：工作量统计 报表
* 1,蒋泽银 20160325 创建
*/
String us = userinfo_session.getUsername();

String us_ = CmsCache.getParameterValue("report_user")+",";

if(!(userinfo_session.isAdministrator()) && !us_.contains(us+","))
{ 
	response.sendRedirect("../noperm.jsp");
	return;
}

if(!(userinfo_session.isAdministrator()))
{ 
	response.sendRedirect("../noperm.jsp");
	return;
}
String uri = request.getRequestURI();
long begin_time = System.currentTimeMillis();
String userName	= getParameter(request,"userName");
String site_data = getParameter(request,"site_data");
if("".equals(site_data))
	site_data = "-1";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>工作量统计 TideCMS</title>
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
<script src="../lib/2018/select2/js/select2.min.js"></script>

<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript">
function showDetails(way,id){
	var dialog = new top.TideDialog();
	dialog.setWidth(800);
	dialog.setHeight(400);
	dialog.setLayer(2);
	dialog.setUrl("./report/analy_tend.jsp?type=site&id="+id+"&dateWay="+way);
	dialog.setTitle("查看发稿量统计详情");
	dialog.show();
}
function downexcle(){
	location.href="./down_report.jsp?type=site&where="+$("#site_data").val();
	
}
$(function(){
	var data = $.parseJSON('<%=ReportUtil.getSiteData()%>');
	var html="";
	$.each(data,function(index,obj)
	{
		if(<%=site_data%>==obj.id)
			html +='<option value="'+obj.id+'" selected="selected">'+obj.name+'</option>';
		else 
			html +='<option value="'+obj.id+'">'+obj.name+'</option>';
	});
	$("#site_data").html(html);
});
</script>
</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
        <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">系统管理 / 工作量统计 / 站点发稿量 </span>
        </nav>
        </div><!-- br-pageheader -->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
       
        <div class="btn-group mg-l-10 hidden-xs-down">
		  <a href="#" class="btn btn-outline-info btn-search" onClick="downexcle();">导出</a>       
        </div><!-- btn-group -->
     </div>
	  <!--搜索-->
     <div class="search-box pd-x-20 pd-sm-x-30" id="SearchArea">
		<div class="search-content bg-white">
			<form name="search_form"  action="report_site2018.jsp" method="post">
      		<div class="row">
				<!--用户信息-->
				<div class="wd-80 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">站点:</div>
				<div class="mg-r-20 mg-b-40 search-item">
                        <select class="form-control select2" name="site_data" id="site_data">
						</select>                                
				</div>	
               <div class="search-item mg-b-30">
					<input name="Submit" type="Submit" value="查找" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14" />
			</div>				
			</div><!-- row -->
			
			</form>
      	</div>
     </div><!--搜索-->	
	 
<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">		
			<table class="table mg-b-0" id="content-table">
				<thead>
				  <tr>				
					<th class="tx-12-force tx-mont tx-medium">站点名称:</th>														
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">本天</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本周</th>	
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">本月</th>	
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">本年</th>				
				  </tr>		  
				</thead>
				<tbody id="content_data">
<%
//select * from channel
String ListSql ="select * from site where id="+site_data;
TableUtil tu = new TableUtil();
ResultSet Rs = tu.executeQuery(ListSql);
while(Rs.next()){
	int today = ReportUtil.getReport(Rs.getInt("id"),"today","site");
	int week = ReportUtil.getReport(Rs.getInt("id"),"week","site");
	int month = ReportUtil.getReport(Rs.getInt("id"),"month","site");
	int year = ReportUtil.getReport(Rs.getInt("id"),"year","site");
%>
      <tr id="item_<%=Rs.getString("id")%>">
			<td class="hidden-xs-down"><%=Rs.getString("Name")%></td>				
			<td class="hidden-xs-down" <%if(today>0){%> onClick="showDetails('today',<%=Rs.getString("id")%>)"<%}%>><%=today%></td>	
            <td class="hidden-xs-down" <%if(week>0){%>  onClick="showDetails('week',<%=Rs.getString("id")%>)"<%}%>><%=week%></td>		
            <td class="hidden-xs-down" <%if(month>0){%> onClick="showDetails('month',<%=Rs.getString("id")%>)"<%}%>><%=month%></td>
            <td class="hidden-xs-down" <%if(year>0){%>  onClick="showDetails('year',<%=Rs.getString("id")%>)"<%}%>><%=year%></td>
		</tr>
<%
}
tu.closeRs(Rs);
%>
 </tbody> 
</table> 
			<div id="tide_content_tfoot">	
          		<span class="mg-r-20 ">查询用时:<%=(System.currentTimeMillis()-begin_time)%>毫秒</span>         		       
			</div><!--分页-->
			</div>
	 </div><!--列表-->
	 </div>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>
    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>	
    <script src="../common/2018/bracket.js"></script> 
</body>
</html>
