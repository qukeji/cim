<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@page import="tidemedia.cms.system.Log"%>
<%@ include file="../config.jsp"%>
<%

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 20;



%>
<!DOCTYPE html>
<html id="green">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 列表</title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/theme/theme.css">

<style>
	.collapsed-menu .br-mainpanel-file {
		margin-left: 0;
		margin-top: 0;
	}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script> 
<script src="../common/2018/content.js"></script>
<script src="../common/jquery.contextmenu.js"></script>
<script language="javascript">
	
	jQuery(document).ready(function() {
		jQuery("#rowsPerPage").val('<%=rowsPerPage%>');
	});

	var listType = 1;

	function gopage(currpage) {
		var url = "notice_list.jsp?currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%>";
		this.location = url;
	}

	function add()
	{
		var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(450);
		dialog.setUrl("notice_add.jsp");
		dialog.setTitle("新建通知");
		dialog.show();
	}
	function edit(id)
	{
		var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(450);
		dialog.setUrl("notice_edit.jsp?id="+id);
		dialog.setTitle("编辑通知");
		dialog.show();
	}
	function del(id)
	{
		var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(260);
		dialog.setUrl("notice_del.jsp?id="+id);
		dialog.setTitle("删除通知");
		dialog.show();
	}
</script>
</head>

<body class="collapsed-menu email">

	<div class="br-mainpanel br-mainpanel-file" id="js-source">
		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active">通知管理</span>
			</nav>
		</div>
		<!--操作-->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

			<div class="btn-group hidden-xs-down mg-l-auto">
				<a href="javascript:add();" class="btn btn-outline-info" >新建</a>
			</div>
<%	 
TcenterLog l = new TcenterLog();
TableUtil pt = new TableUtil("user");
String ListSql = "select * from notice  where 1=1";
String CountSql = "select count(*) from notice where 1=1";
ListSql+=" order by id desc";
ResultSet Rs = pt.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = pt.pagecontrol.getMaxPages();
int TotalNumber = pt.pagecontrol.getRowsCount();
%>
			<!-- btn-group -->
			<div class="btn-group mg-l-10 hidden-sm-down">
			  <%if(currPage>1){%>
				<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
			  <%}%>
			  <%if(currPage<TotalPageNumber){%>
				<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
			  <%}%>
			</div>
			<!-- btn-group -->
		</div>


		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0" id="content-table">
				<thead>
						<tr>
							<th class="tx-12-force tx-mont tx-medium">编号</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">通知内容</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">发布时间</th>
							<th class="tx-12-force wd-260 tx-mont tx-medium hidden-xs-down">操作</th>
						</tr>
					</thead>
					<tbody>
<%
if(pt.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				int id = Rs.getInt("id");
				String Title = convertNull(Rs.getString("Title"));
				String StartDate = convertNull(Rs.getString("StartDate")).replace(".0","");
				String EndDate = convertNull(Rs.getString("EndDate")).replace(".0","");
				String desc = StartDate+" 至 " +EndDate;
				

				j++;
%>
						<tr>
							<td class="valign-middle"><%=j%></td>
							<td class="hidden-xs-down"><%=Title%></td>
							<td class="hidden-xs-down"><%=desc%></td>
							<td class="dropdown hidden-xs-down">
								<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="edit(<%=id%>);">编辑</button>
								<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="del(<%=id%>);">删除</button>
							</td>
						</tr>
<%
			}
			pt.closeRs(Rs);
}

%>
					</tbody>
				</table>

				<div id="tide_content_tfoot">
					<span class="mg-r-20 ">共<%=TotalNumber%>条</span>
					<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

					<%if(TotalPageNumber>1){%>
					<div class="jump_page ">
						<span class="">跳至:</span>
						<label class="wd-60 mg-b-0">
							<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
						</label>
						<span class="">页</span>
						<a id="goToId" href="javascript:;" class="tx-14">Go</a>
					</div>
					<%}%>
					<div class="each-page-num mg-l-auto">
						<span class="">每页显示:</span>
						<label class="wd-80 mg-b-0">
						<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="状态" onChange="change(this);" id="rowsPerPage">
							<option value="10" >10</option>
							<option value="15" >15</option>
							<option value="20" >20</option>
							<option value="25" >25</option>
							<option value="30" >30</option>
							<option value="50" >50</option>
							<option value="80" >80</option>
							<option value="100" >100</option>						
						</select>
						</label> 条
					</div>
				</div>
				<!--分页-->
			</div>
		</div>
		<!--列表-->
	</div>      
	
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script> 
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script type="text/javascript">


	jQuery(document).ready(function() {

		jQuery("#goToId").click(function() {
			var num = jQuery("#jumpNum").val();
			if (num == "") {
				alert("请输入数字!");
				jQuery("#jumpNum").focus();
				return;
			}
			var reg = /^[0-9]+$/;
			if (!reg.test(num)) {
				alert("请输入数字!");
				jQuery("#jumpNum").focus();
				return;
			}

			if (num < 1)
				num = 1;
			var href = "notice_list.jsp?currPage=" + num + "&rowsPerPage=<%=rowsPerPage%>";
			document.location.href = href;
		});

	});

	function change(obj) {
		if (obj != null) this.location = "notice_list.jsp?rowsPerPage=" + obj.value;
	}
	$('.fc-datepicker').datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		dateFormat: "yy-mm-dd"
	});
</script>

</body>
</html>