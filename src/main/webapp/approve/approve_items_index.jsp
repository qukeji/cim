<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
//获取用户名
public String getUserName(String users) {
	String userName = "";
	try{
		TableUtil tu = new TableUtil("user");
		String Sql = "select * from userinfo where id in("+users+")";
		ResultSet Rs = tu.executeQuery(Sql);
		while(Rs.next())
		{
			String Name = convertNull(Rs.getString("Name"));
			if(!userName.equals("")&&!Name.equals("")){
				userName += ",";
			}
			userName += Name;
		}
		tu.closeRs(Rs);
	}catch(Exception e){
		System.out.println(e.getMessage());
	}
	return userName;
}
%>
<%
int	id		= getIntParameter(request,"id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	.collapsed-menu .br-mainpanel-file {
		margin-left: 0;
		margin-top: 0;
	}
	.modal-body-btn{bottom:10px;}
	.br-pagebody {
		margin-top: 10px;
	}

</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script> 
	var id = <%=id%> ;
	function add()
	{
		var url="../approve/approve_items_add.jsp?parent="+id;
		var	dialog = new top.TideDialog();
			dialog.setWidth(550);
			dialog.setHeight(600);
			dialog.setUrl(url);
			dialog.setTitle("添加审核环节");
			dialog.show();
	}
	function edit(itemid)
	{
		var url="../approve/approve_items_edit.jsp?parent="+id+"&id="+itemid;
		var	dialog = new top.TideDialog();
			dialog.setWidth(550);
			dialog.setHeight(600);
			dialog.setUrl(url);
			dialog.setTitle("审核环节配置");
			dialog.show();
	}
	function del(itemid)
	{
		var url="../approve/approve_items_delete.jsp?parent="+id+"&ItemID="+itemid;
		var	dialog = new top.TideDialog();
			dialog.setWidth(300);
			dialog.setHeight(260);
			dialog.setUrl(url);
			dialog.setTitle("删除审核环节");
			dialog.show();
	}
	//刷新列表
	function setReturnValue(o){
		if(o.refresh){
			var s = "../approve/approve_items_index.jsp?id="+o.id;
			document.location.href=s;
		}
	}
</script>
</head>

<body class="collapsed-menu email" onLoad="">

<div class="modal-body modal-body-btn pd-20 overflow-y-auto">       
	<!-- br-pageheader -->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30">
		<div class="btn-group mg-l-auto ">
			<a href="javascript:add();" class="btn btn-outline-info list_draft">添加</a>
		</div><!-- btn-group -->			
	</div>
	<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">

		<table class="table mg-b-0" id="oTable">
			<thead>
				<tr>
					<th class="tx-12-force tx-mont tx-medium">步骤</th>
					<th class="tx-12-force tx-mont tx-medium">名称</th>
					<th class="tx-12-force tx-mont tx-medium">方式</th>
					<th class="tx-12-force tx-mont tx-medium">用户</th>
					<th class="tx-12-force tx-mont tx-medium">操作</th>
				</tr>
			</thead>
			<tbody>
<%
	TableUtil tu = new TableUtil();
	String ListSql = "select * from approve_items where parent="+id+" order by step asc";
	ResultSet Rs = tu.executeQuery(ListSql);
	int j = 0 ;
	while(Rs.next()){
		j++;
		int tid = Rs.getInt("id");
		int step = Rs.getInt("step");
		String title = convertNull(Rs.getString("Title"));
		int Type = Rs.getInt("Type");
		String Type_ = "或签";
		if(Type==1){
			Type_ = "并签";
		}
		String users = convertNull(Rs.getString("users"));
		String users_ = "";
		if(!users.equals("")){
			users_ = getUserName(users);
		}	

%>
			<tr id="jTip<%=j%>_id" tid=<%=tid%> class="tide_item">					
				<td class="hidden-xs-down"><%=step%></td>
				<td class="hidden-xs-down"><%=title%></td>
				<td class="hidden-xs-down"><%=Type_%></td>
				<td class="hidden-xs-down"><%=users_%></td>
				<td class="hidden-xs-down">
					<a href="#" class="btn btn-info btn-sm tx-13" onclick="edit(<%=tid%>)">配置</a>
					<a href="#" class="btn btn-info btn-sm tx-13" onclick="del(<%=tid%>)">删除</a>
				</td>
			</tr>
<%	
	}
	tu.closeRs(Rs);
%>
			</tbody>
		</table>

		</div>
	</div>
</div>

</body>
</html>
