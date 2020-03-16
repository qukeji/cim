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
int user_id	= getIntParameter(request,"user_id");
TableUtil tu = new TableUtil("user");
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
	<div class="content_t1_nav">当前位置：工作量统计 > 个人发稿量 </div>
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
    <td><form name="search_form"  action="report_person.jsp" method="post">
		发稿人：
		<select name="user_id" id="user_id">
			<%
				String sql ="select id,name from userinfo";
				ResultSet rs = tu.executeQuery(sql);
				while(rs.next()){
					if(user_id==0)
						user_id = rs.getInt("id");
					out.println("<option value=\""+rs.getInt("id")+"\">"+rs.getString("name")+"</option>");
				}
				tu.closeRs(rs);
			%>
		</select>
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
			<th class="v3" style="padding-left:10px;text-align:left;">发稿人</th>
			<th class="v1" valign="middle" align="center">所属部门</th>
			<th class="v8" valign="middle" align="center">本天</th>
			<th class="v8" valign="middle" align="center">本周</th>
			<th class="v8" valign="middle" align="center">本月</th>
			<th class="v8" valign="middle" align="center">本年</th>
  	    </tr>
</thead>
 <tbody id="content_data"> 
 
<%
String ListSql ="select * from userinfo where id="+user_id;
ResultSet Rs = tu.executeQuery(ListSql);
String name="";
while(Rs.next()){
	int today = ReportUtil.getReport(Rs.getInt("id"),"today","person");
	int week = ReportUtil.getReport(Rs.getInt("id"),"week","person");
	int month = ReportUtil.getReport(Rs.getInt("id"),"month","person");
	int year = ReportUtil.getReport(Rs.getInt("id"),"year","person");
	name = Rs.getString("Name");
%>
	<tr id="item_<%=Rs.getString("id")%>">
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png"><%=name%></td>
	<td class="v1" valign="middle" align="center">
	<%
	  try{
		  int gid = Rs.getInt("GroupID");
		  if(gid!=-1){
			 UserGroup u = new UserGroup(gid);
			 out.print(u.getName());
		  }else{
			out.print("");
		  }
	  }catch(Exception e){
		  out.print("");
	  }
	%>
	</td>
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
	dialog.setUrl("./report/analy_tend.jsp?type=person&id="+id+"&dateWay="+way);
	dialog.setTitle("查看发稿量统计详情");
	dialog.show();
}
function downexcle(){
	location.href="./down_report.jsp?type=person&where=";
}
$("#user_id").find("option[value='<%=user_id%>']").attr("selected",true);
</script>
</html>
