<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 20;
String querystring="";

String Action = getParameter(request,"Action");
if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	Parameter p = new Parameter();
	p.Delete(id);

	response.sendRedirect("parameter2018.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage);return;
}

%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="Shortcut Icon" href="../favicon.ico">
	<title>TideCMS</title>
	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
	<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
	<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
	<!--<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">-->
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	<style>
		.collapsed-menu .br-mainpanel-file {
			margin-left: 0;
			margin-top: 0;
		}
	</style>

	<script src="../lib/2018/jquery/jquery.js"></script>
	<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
	<script language="javascript">
		function ClearItems() 
{
       //页面暂无此功能
			if (confirm("确实要清空错误日志吗？")) {
				this.location = "error_log.jsp?Action=Clear";
			}
}


		function Details(id, code) {
			if (code == 'log_cleaning') {
				var href = "../content/sysconfig_clear.jsp?id=" + id;
				document.location.href = href;
			} else {
				var dialog = new top.TideDialog();
				dialog.setWidth(580);
				dialog.setHeight(520);
				dialog.setUrl("parameter_edit2018.jsp?id=" + id);
				dialog.setTitle("修改参数");
				dialog.show();
			}


		}
function del(id) 
{
	
	 var dialog = new top.TideDialog();
          dialog.setWidth(320);
          dialog.setHeight(260);         
		  //dialog.setSuffix('_3');
          dialog.setUrl("parameter_del2018.jsp?id="+id+"&currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%>");
          dialog.setTitle("删除日志");
          dialog.show();	
}

		function openSearch() {
			var SearchArea = document.getElementById("SearchArea");
			if (SearchArea.style.display == "none") {
				//document.search_form.OpenSearch.value="1";
				SearchArea.style.display = "";
			} else {
				//document.search_form.OpenSearch.value="0";
				SearchArea.style.display = "none";
			}
		}

		function addParameter() {
			var url = 'parameter_add2018.jsp';
			var dialog = new top.TideDialog();
			dialog.setWidth(580);
			dialog.setHeight(540);
			dialog.setUrl(url);
			dialog.setTitle("添加参数");
			dialog.show();
		}

		function gopage(currpage) {
			var url = "parameter2018.jsp?currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
			this.location = url;
		}

	</script>
</head>

<body class="collapsed-menu email">

	<div class="br-mainpanel br-mainpanel-file" id="js-source">

		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active">系统配置管理 / 平台系统参数</span>
			</nav>
		</div>
		<!-- br-pageheader -->

<%
	TableUtil tu = new TableUtil();
	String ListSql = "select * from parameter order by id desc";
	String CountSql = "select count(*) from parameter";

	ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
	int TotalPageNumber = tu.pagecontrol.getMaxPages();
	int TotalNumber = tu.pagecontrol.getRowsCount();
%>

		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
				<div class="btn-group hidden-xs-down mg-l-auto">
					<a href="javascript:;" class="btn btn-outline-info" onclick="addParameter()";>新建</a>
				</div>
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
		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0" id="content-table">

					<thead>
						<tr>
							<th class="tx-12-force tx-mont tx-medium">编号</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">代码</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">标题</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">日期</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">操作</th>
						</tr>
					</thead>
					<tbody>
<%

if(tu.pagecontrol.getRowsCount()>0)
{
	int j=0;

		while(Rs.next())
		{
			String Name			= convertNull(Rs.getString("Name"));
			String Code			= convertNull(Rs.getString("Code"));
			String CreateDate	= convertNull(Rs.getString("CreateDate"));
			int id				= Rs.getInt("id");
			j++;
%>
				<tr>
					<td class="valign-middle">
						<label class="ckbox mg-b-0">
						<%=j%>
					  </label>
					</td>
					<td class="hidden-xs-down">
						<a href="javascript:Details(<%=id%>,'<%=Code%>');">
							<%=Code%>
						</a>
					</td>
					<td class="hidden-xs-down">
						<%=Name%>
					</td>
					<td class="hidden-xs-down">
						<%=CreateDate%>
					</td>
				<!--	<td class="hidden-xs-down"><a href="parameter2018.jsp?Action=Del&id=<%=id%>" class="btn btn-danger btn-sm tx-13" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td> -->
					<td class="hidden-xs-down"><a href="javascript:del(<%=id%>);" class="btn btn-danger btn-sm tx-13">删除</a></td>
				</tr>
<%
	}		
}
tu.closeRs(Rs);
%>
					</tbody>
                </table>
			<%if(TotalPageNumber>0){%>
				<!--分页-->
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
								<option value="15">15</option>
								<option value="20">20</option>
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
				<%}%>
			</div>
		</div>
		<!--列表-->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
				<div class="btn-group hidden-xs-down mg-l-auto">
					<a href="javascript:;" class="btn btn-outline-info" onclick="addParameter()";>新建</a>
				</div>
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
		<script src="../lib/2018/popper.js/popper.js"></script>
		<script src="../lib/2018/bootstrap/bootstrap.js"></script>
		<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
		<script src="../lib/2018/moment/moment.js"></script>
		<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
		<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
		<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
		<!--<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>-->
		<script src="../lib/2018/select2/js/select2.min.js"></script>
		<script src="../common/2018/bracket.js"></script>
                    
		<script type="text/javascript">
			jQuery(document).ready(function() {
				jQuery("#rowsPerPage").val('<%=rowsPerPage%>');

				jQuery("#goToId").click(function() {
					var num = jQuery("#jumpNum").val();
					if (num == "") {
						var action="numberNull";
		                 alertDialog(action);	
						//alert("请输入数字!");
						jQuery("#jumpNum").focus();
						return;
					}
					var reg = /^[0-9]+$/;
					if (!reg.test(num)) {
						var action="numberNull";
		                 alertDialog(action);	
						//alert("请输入数字!");
						jQuery("#jumpNum").focus();
						return;
					}

					if (num < 1)
						num = 1;
					var href = "parameter2018.jsp?currPage=" + num + "&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
					document.location.href = href;
				});
			});
//alert改弹窗
function alertDialog(action)
{
	
		var	dialog = new top.TideDialog();
		dialog.setWidth(320);
		dialog.setHeight(240);
		dialog.setUrl("../explorer/alertDialog2018.jsp?action="+action);
		dialog.setTitle("提示");
		dialog.show();	
}
			function change(obj) {
				if (obj != null) this.location = "parameter2018.jsp?rowsPerPage=" + obj.value + "<%=querystring%>";
			}
		</script>
	</div>
</body>

</html>