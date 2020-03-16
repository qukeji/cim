<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				java.util.*,
				tidemedia.cms.util.*,tidemedia.cms.publish.*,java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>系统监控</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
</head>
<script>
function showfile(){
	$(".view_table").show();
	$("#startbutton").show();
}
function startclear(){
	
	if(confirm("数据删除后将无法恢复\n  确定开始清理数据？")){
		$("#tidecms_notify").show();
		tidecms.message("<font color=red>正在清理...</font>");
		jQuery.ajax({
				type : "get",
				url : "clear_page_content.jsp",
			
				success : function(msg){
					tidecms.notify("清理完成");
					document.location.reload();
				}
		});
	}else{
		return false;
	}
}
</script>
<body onload="">
<div class="content_t1">
	<div class="content_t1_nav">页面数据清理：</div>
</div>

<div class="content_2012">
	<div class="viewpane">
        <div class="viewpane_tbdoy">
			<!--<div class="content_new_post">  -->
				<div id="msg"></div>
				<div class="tidecms_btn" onclick="return startclear()" id="startbutton">
					<div class="t_btn_txt"><a href="#">开始清理</a></div>
				</div>
				 
				<div class="tidecms_btn" onClick="openSearch();">
					<div class="t_btn_txt"><a href="data_clear.jsp">返回</a></div>
				</div>
			<!-- </div> -->
			<div id="tidecms_notify" style="display:none; position: relative; margin: -26px 0px 0px 130px; height:26px;">
				<span class="tn_main" style="diplay:block;height:24px;padding:2px 0;line-height:26px;"></span>
			</div>
			
			<table width="100%" border="0" class="view_table">
				<thead>
					<tr id="oTable_th">
						<th class="v1"  width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
						<th class="v1"	align="center" valign="middle">页面名称</th>
						<th class="v8"  align="center" valign="middle">记录条数</th>
					</tr>
				</thead>
<tbody>
<%
	TableUtil tu = new TableUtil();
	String sql = "SELECT * FROM channel where Type=2";
	ResultSet rs = tu.executeQuery(sql);
	int j=0;
	while(rs.next()){
		j++;
		int id = rs.getInt("id");
		Channel pc = CmsCache.getChannel(id);
		String name = pc.getName();
		String fullpath = pc.getParentChannelPath();
		TableUtil tu2 = new TableUtil();
		String ListSql = "select count(*) count from page_content where Page="+id;
		ResultSet rs2 = tu2.executeQuery(ListSql);
		int total = 0;
		while(rs2.next()){
			total = rs2.getInt("count");
		}
		tu2.closeRs(rs2);
		%>
		  <tr No="<%=j%>" ItemID="<%=id%>" id="item_<%=id%>" class="tide_item">
			<td class="v1 checkbox" width="25" align="center" valign="middle"><input name="id" value="<%=id%>" type="checkbox"/></td>
			<td class="v1" align="center" valign="middle"><%=fullpath%></td>
			<td class="v4" align="center" valign="middle" style="color:#666666;"><%=total%></td>
		  </tr>
		<%
	}
	tu.closeRs(rs);
%>
</tbody>
</table>
		</div>
	</div>
</div>
 
</body>
</html>