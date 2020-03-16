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
String grop_data = getParameter(request,"grop_data");
if("".equals(grop_data))
	grop_data = "-1";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>工作量统计 TideCMS</title>
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：工作量统计 > 部门发稿量 </div>
    <div class="content_new_post">
		<div class="tidecms_btn" onClick="downexcle();">
			<div class="t_btn_pic"><img src="../images/icon/43.png" /></div>
			<div class="t_btn_txt">导出</div>
		</div>
    </div>
</div>
<div class="viewpane_c1" id="SearchArea">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
    <table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20"> </td>
    <td><form name="search_form"  action="report_depart.jsp" method="post">
	部门：<select name="grop_data" id="grop_data"></select>
	<input name="Submit" type="Submit" class="tidecms_btn2" value="查找" />
	</form></td>
    <td width="20"> </td>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content_2012">
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table id="oTable" class="view_table" width="100%" border="0">
<thead>
		<tr>
			<th class="v3" style="padding-left:10px;text-align:left;">部门名称</th>
			<th class="v1" valign="middle" align="center">部门人数</th>
			<th class="v8" valign="middle" align="center">本天</th>
			<th class="v8" valign="middle" align="center">本周</th>
			<th class="v8" valign="middle" align="center">本月</th>
			<th class="v8" valign="middle" align="center">本年</th>
  	    </tr>
</thead>
 <tbody id="content_data"> 
 
<%
//select * from user_group where id
String ListSql ="select * from user_group where id="+grop_data;
TableUtil tu = new TableUtil("user");
ResultSet Rs = tu.executeQuery(ListSql);
while(Rs.next()){
	int today = ReportUtil.getReport(Rs.getInt("id"),"today","depart");
	int week = ReportUtil.getReport(Rs.getInt("id"),"week","depart");
	int month = ReportUtil.getReport(Rs.getInt("id"),"month","depart");
	int year = ReportUtil.getReport(Rs.getInt("id"),"year","depart");
%>
	<tr id="item_<%=Rs.getString("id")%>">
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png"><%=Rs.getString("Name")%></td>
	<td class="v1" valign="middle" align="center"><%=ReportUtil.getDepartUserCount(Rs.getInt("id"))%></td>
    <td class="v8" valign="middle" align="center" <%if(today>0){%> onClick="showDetails('today',<%=Rs.getString("id")%>)"<%}%>><%=today%></td>
	<td class="v8" valign="middle" align="center" <%if(week>0){%>  onClick="showDetails('week',<%=Rs.getString("id")%>)"<%}%>><%=week%></td>
	<td class="v8" valign="middle" align="center" <%if(month>0){%> onClick="showDetails('month',<%=Rs.getString("id")%>)"<%}%>><%=month%></td>
	<td class="v8" valign="middle" align="center" <%if(year>0){%>  onClick="showDetails('year',<%=Rs.getString("id")%>)"<%}%>><%=year%></td>
  </tr>
<%
}
tu.closeRs(Rs);
%>
 
 </tbody> 
</table> 
        </div>
        <div class="viewpane_pages">
		    <div class="left" style="left:10px;">查询用时：<%=(System.currentTimeMillis()-begin_time)%>毫秒</div>
        </div>
  </div>
</div>
</body>
<script>
function showDetails(way,id){
	var dialog = new top.TideDialog();
	dialog.setWidth(800);
	dialog.setHeight(400);
	dialog.setLayer(2);
	dialog.setUrl("./report/analy_tend.jsp?type=depart&id="+id+"&dateWay="+way);
	dialog.setTitle("查看发稿量统计详情");
	dialog.show();
}
function downexcle(){
	var data = $("#grop_data").val();
	if(data=="")
		data = "-1";
	location.href="./down_report.jsp?type=depart&where="+data;
	
}

$(function(){
	$.ajax({
		url:"user_data.jsp",
		type:"post",
		dataType:"json",
		data:"",
		success:function(data)
		{	var html = "";
			$.each(data,function(index,obj)
			{
				if(<%=grop_data%>==obj.id)
					html +='<option value="'+obj.id+'" selected="selected">'+obj.name+'</option>';
				else 
					html +='<option value="'+obj.id+'">'+obj.name+'</option>';
			});
			$("#grop_data").html(html);
		}
	});
})
</script>
</html>
