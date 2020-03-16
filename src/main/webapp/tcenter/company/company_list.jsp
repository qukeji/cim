<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

if(userinfo_session.getRole()!=1){
	response.sendRedirect("../noperm.jsp");
	return;
}

long begin_time = System.currentTimeMillis();

//String cms_api = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/tcenter";
String url = "http://127.0.0.1:888/tcenter/api/company/site_list.jsp";

%>
<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>TideCMS 7 列表</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">

<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/common.css">
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">

<link rel="stylesheet" href="../style/theme/theme.css">
<style>
	.collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
	table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
	table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
	border-collapse: collapse !important;}
	.list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;}
	.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}
	@media (max-width: 575px){
		#content-table .hidden-xs-down {word-break: normal;	}
	}
	/*tooltip相关样式*/
    .bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
	.tooltip.bs-tooltip-right .arrow::before,
	.tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {			
		border-right-color: #00b297;			
	}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>

<script>

function module(id)
{
	var url = "module_list.jsp?id="+id;
	var	dialog = new top.TideDialog();
		dialog.setWidth(750);
		dialog.setHeight(600);
		dialog.setUrl(url);
		dialog.setTitle('模块管理');
		dialog.show();
}
function edit(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(650);
	dialog.setHeight(550);
	dialog.setUrl("company_edit.jsp?id="+id);
	dialog.setTitle("编辑租户");
	dialog.show();
}
function del(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(300);
	dialog.setHeight(260);
	dialog.setUrl("company_del.jsp?id="+id);
	dialog.setTitle("删除租户");
	dialog.show();
}
function admin(id){
	parent.$(".company_"+id).click()
}
function toolList(id){
	var url = "company_tool.jsp?companyid="+id;
	var	dialog = new top.TideDialog();
		dialog.setWidth(600);
		dialog.setHeight(480);
		dialog.setUrl(url);
		dialog.setTitle('移动工具管理');
		dialog.show();
}
</script>
</head>
<body class="collapsed-menu email">
	<div class="br-mainpanel br-mainpanel-file" id="js-source">
		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active">租户管理 / 所有租户</span>
			</nav>
			<%if(userinfo_session.getRole()==1&&userinfo_session.getCompany()==0){%>
    		<!--操作-->
			<div class="btn-group mg-l-auto ">
				<a href="javascript:;" id="openComps" class="btn btn-outline-info btn-sm">开通租户</a>
			</div>
    		<!--操作-->
    		<%}%>
		</div>
		<!-- br-pageheader -->
<%

String ListSql = "select  * from company ";
String CountSql = "select count(*) from company";
ListSql += " order by id asc";

TableUtil tu = new TableUtil("user");
ResultSet Rs = tu.List(ListSql,CountSql,1,1000);

int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
%>
		
		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0 " id="content-table">
					<thead>
						<tr>
							<th class="wd-5p wd-50">编号</th>
							<th class="tx-12-force tx-mont tx-medium">租户名称</th>
							<th class="tx-12-force tx-mont tx-medium">关联管理站点</th>
							<th class="tx-12-force tx-mont tx-medium">租户管理员</th>
							<th class="tx-12-force tx-mont tx-medium">聚融业务</th>
							<th class="tx-12-force tx-mont tx-medium">云平台企业编号</th>
							<th class="tx-12-force tx-mont tx-medium">授权到期时间</th>
							<th class="tx-12-force tx-mont tx-medium">是否启用</th>
							<th class="tx-12-force wd-260 tx-mont tx-medium hidden-xs-down">操作</th>
						</tr>
					</thead>
					<tbody>
<%



	JSONArray array = new JSONArray();
	while(Rs.next()) {
		int id_ = Rs.getInt("id");
		String Name = convertNull(Rs.getString("Name"));
		int Status = Rs.getInt("Status");
		String ExpireDate = convertNull(Rs.getString("ExpireDate")).replace(".0", "");
		int jurong = Rs.getInt("jurong");
		int JuxianID = Rs.getInt("JuxianID");

		JSONObject object = new JSONObject();
		object.put("id_",id_);
		object.put("Name",Name);
		object.put("Status",Status);
		object.put("ExpireDate",ExpireDate);
		object.put("jurong",jurong);
		object.put("JuxianID",JuxianID);
		array.put(object);
	}
	tu.closeRs(Rs);

	int j = 0;
	for(int n = 0;n<array.length();n++){
		JSONObject object = array.getJSONObject(n);
		String Name = object.getString("Name");
		int JuxianID = object.getInt("JuxianID");
		String ExpireDate = object.getString("ExpireDate");

		int id_ = object.getInt("id_");
		if(userinfo_session.getCompany()!=0&&userinfo_session.getCompany()!=id_){
			continue;
		}

		int Status = object.getInt("Status");
		String flag = "false";
		if(Status==1){//开启
			flag = "true";
		}

		int jurong = object.getInt("jurong");
		String jurong_ = "false";
		if(jurong==1){
			jurong_ = "true";
		}

		String userName = "";
		ArrayList<UserInfo> userList = new Company().getUserList(id_);//租户管理员
		for(int i=0;i<userList.size();i++){
			UserInfo userinfo = userList.get(i);
			if(!userName.equals("")){userName += "<br>";}
			userName += userinfo.getName();
		}

		//获取关联站点
		String siteNames = Util.connectHttpUrl(url + "?company="+id_+"&type=1");

		j++;

%>
					<tr No="<%=j%>" id="<%=id_%>" status="<%=Status%>" id="item_<%=id_%>" class="tide_item">
						<td class="hidden-xs-down"><%=j%></td>
						<td class="hidden-xs-down"><%=Name%></td>
						<td class="hidden-xs-down"><%=siteNames%></td>
						<td class="hidden-xs-down"><%=userName%></td>
						<td class="hidden-xs-down">
							<div class='toggle-wrapper'>
								<div class='toggle toggle-light primary' data-toggle-on='<%=jurong_%>' company='<%=id_%>' field='jurong'></div>
							</div>
						</td>
						<td class="hidden-xs-down"><%=JuxianID%></td>
						<td class="hidden-xs-down"><%=ExpireDate%></td>
						<td class="hidden-xs-down">
							<div class='toggle-wrapper'>
								<div class='toggle toggle-light primary' data-toggle-on='<%=flag%>' company='<%=id_%>' field='Status'></div>
							</div>
						</td>
						<td class="dropdown hidden-xs-down">
							<!--<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="admin(<%=id_%>);">用户管理</button>-->
							<button class="btn btn-info btn-sm mg-b-2 mg-r-8 tx-13 " onclick="toolList(<%=id_%>);">移动工具管理</button>
							<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="module(<%=id_%>);">模块管理</button>
							<%if(userinfo_session.getCompany()==0){%>
							<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="edit(<%=id_%>);">编辑</button>
							<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="del(<%=id_%>);">删除</button>
							<%}%>
						</td>
					</tr>
<%
	}
%>
					</tbody> 
				</table>

			</div>
		</div>
		<!--列表-->

	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/peity/jquery.peity.js"></script>
	<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
	<script src="../lib/2018/medium-editor/medium-editor.js"></script>
	<script src="../lib/2018/select2/js/select2.min.js"></script>
	<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
	<script>
	//开关相关
	//初始化
	$('.toggle').toggles({        
	  height: 25
	});
	//获取是否开或关
	$(".toggle").click(function(){
		var myToggle = $(this).data('toggle-active');
		var id = $(this).attr('company');	
		var field = $(this).attr('field');

		var url = "company_action.jsp?Action="+myToggle+"&id="+id+"&field="+field;
		$.ajax({
			type:"GET",
			url:url, 
			success: function(msg){
				//if(msg.trim()=="true"){
				//	alert("设置成功");
				//}
			}
		});
	})
	
	//开通租户
	$("#openComps").click(function(){
	    window.parent.frames["content_frame"].src ="company_add.jsp" ;
	    return false ;
	})
	
	</script>
</body>
</html>
