<%@ page import="java.sql.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				tidemedia.cms.system.*"%>
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

int  Log_Action           =   getIntParameter(request,"Log_Action");
String S_startDate			=	getParameter(request,"startDate");
String S_endDate			=	getParameter(request,"endDate");
String S_User			=	getParameter(request,"User");
int S_Status			=	getIntParameter(request,"Status");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
String Log_Action_name="";
if((!S_User.equals(""))||(!S_startDate.equals(""))||(!S_endDate.equals(""))){
    S_OpenSearch=1;
}

String querystring = "";
querystring = "&User="+S_User+"&startDate="+S_startDate+"&endDate="+S_endDate;

String Action = getParameter(request,"Action");
if(Action.equals("Del"))
{
/*	int id = getIntParameter(request,"id");

	String Sql = "delete from login_log where id=" + id;

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("login_log.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage);
*/
}
else if(Action.equals("Clear"))
{
	String Sql = "TRUNCATE login_log";

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("login_log.jsp");return;
}

//当前登录用户的租户id
int companyid = userinfo_session.getCompany();
//获取同租户下的用户
String userids = "";
if(companyid!=0){
	String sql2="select * from userinfo where company="+companyid;
	TableUtil tu2 = new TableUtil("user");
	ResultSet Rs2 = tu2.executeQuery(sql2);
	while(Rs2.next()){
		if(!userids.equals("")){
			userids += ",";
		}
		userids += Rs2.getInt("id");
	}
	tu2.closeRs(Rs2);
}
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
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/theme/theme.css">
<style>
.collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/content.js"></script>

<script language="javascript">
var listType=1;
jQuery(document).ready(function(){

	$("#rowsPerPage").val('<%=rowsPerPage%>');
});
function gopage(currpage) {
	var url = "login_log.jsp?currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%>";
	this.location = url;
}

</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>

<body class="collapsed-menu email"> 

<div class="br-mainpanel br-mainpanel-file" id="js-source">

	<div class="br-pageheader pd-y-15 pd-md-l-20">
		<nav class="breadcrumb pd-0 mg-0 tx-12">
		  <span class="breadcrumb-item active">系统管理 / 登录日志</span>
		</nav>
	</div><!-- br-pageheader -->

	<!--操作-->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
		<div class="btn-group hidden-xs-down mg-l-auto">
			<a href="#" class="btn btn-outline-info btn-search">搜索</a>
		</div>
<%
TableUtil pt = new TableUtil("user");
String ListSql = "select * from login_log where 1=1";
String CountSql = "select count(*) from login_log where 1=1";

if(!S_User.equals("")){
    ListSql+=" and UserName like '%"+pt.SQLQuote(S_User)+"%'";
    CountSql+=" and UserName like '%"+pt.SQLQuote(S_User)+"%'";
}
if(!userids.equals("")){
	ListSql+=" and User in ("+userids+")";
    CountSql+=" and User in ("+userids+")";
}
if(!S_startDate.equals("")){
	ListSql += " and Date>='"+S_startDate+"'" ;
	CountSql += " and Date>='"+S_startDate+"'" ;
}
if(!S_endDate.equals("")){
	ListSql += " and Date<'"+S_endDate+"'";
	CountSql += " and Date<'"+S_endDate+"'";
}
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

	<!--搜索-->
	<div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
		<div class="search-content bg-white">
			<form name="search_form" action="login_log.jsp?rowsPerPage=<%=rowsPerPage%>" method="post">
				<div class="row">
					<!--标题-->
					<div class="mg-r-10 mg-b-30 search-item">
						<input class="form-control search-title" placeholder="用户" type="text" name="User" value="<%=S_User%>">
					</div>
					<!--日期-->
					<div class="wd-200 mg-b-30 mg-r-10 search-item">
						<div class="input-group">
							<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
							<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="startDate" value="<%=S_startDate%>" id="startDate">
						</div>
					</div>
					<div class="wd-20 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>
					<div class="wd-200 mg-b-30 mg-r-10 search-item">
						<div class="input-group">
							<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
							<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="endDate" value="<%=S_endDate%>" id="endDate">
						</div>
					</div>
					<div class="search-item mg-b-30">
						<input type="hidden" name="IsIncludeSubChannel" value="1">
						<input type="submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
						<input type="hidden" name="OpenSearch" id="OpenSearch" value="1">
					</div>
				</div>
				<!-- row -->
			</form>
		</div>
	</div>
	<!--搜索-->

	<!--列表-->
	<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">
				<thead>
				  <tr>
					<th class="wd-5p">编号</th>
					<th class="tx-12-force tx-mont tx-medium">用户</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">登录日期</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">是否成功</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">IP地址</th>
				  </tr>
				</thead>
				<tbody> 
<%
if(pt.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				int UserID = Rs.getInt("User");
				UserInfo user = null;
				
				if(UserID>0) user = (UserInfo)CmsCache.getUser(UserID);
				String UserName = convertNull(Rs.getString("UserName"));
				String LoginDate = convertNull(Rs.getString("Date"));
				String Success = "";
				String cookieDesc = "";
				if(Rs.getInt("IsCookie")==1)
					cookieDesc = "(cookie)";

				if(Rs.getInt("IsSuccess")==1)
				{
					Success = "成功" + cookieDesc;
				}
				else
					Success = "<font color=red>失败"+cookieDesc+"</font>";
				String IP = convertNull(Rs.getString("IP"));
				int id = Rs.getInt("id");

				j++;

				String UserNameDesc = UserName;
				if(user!=null) UserNameDesc = UserName + "(" + user.getName() + ")";
%>

				<tr>
					<td class="hidden-xs-down"><%=j%></td>
					<td class="hidden-xs-down"><a href="login_log.jsp?User=<%=UserName%>"><%=UserNameDesc%></a></td>
					<td class="hidden-xs-down"><%=LoginDate%></td>
					<td class="hidden-xs-down"><%=Success%></td>
					<td class="hidden-xs-down"><%=IP%></td>
				</tr>
<%
			}	
			pt.closeRs(Rs);
}
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
					<a href="#" id="goToId" class="tx-14">Go</a>
				</div>
				<%}%>
				<div class="each-page-num mg-l-auto">
					<span class="">每页显示:</span>
					<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change(this);" id="rowsPerPage">
						<option value="10">10</option>
						<option value="15">15</option>
						<option value="20">20</option>
						<option value="25">25</option>
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="80">80</option>
						<option value="100">100</option>            
					</select>
					<span class="">条</span>
				 </div>
			</div>
			<!--分页-->
			<%}%>
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
<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script type="text/javascript" src="../common/2018/jquery.contextmenu.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>

<script type="text/javascript">

$(function() {
		'use strict';

		$(".btn-search").click(function() {
			$(".search-box").toggle(100);
		})
        //表头排序
        $("#content-table").tablesorter({headers: { 0: { sorter: false}}});
		// Datepicker
		tidecms.setDatePicker(".fc-datepicker");

	});

function change(obj)
{
	if(obj!=null)		this.location="login_log.jsp?rowsPerPage="+obj.value+"<%=querystring%>";
}

jQuery(document).ready(function(){

	$("#rowsPerPage").val('<%=rowsPerPage%>');

	jQuery("#goToId").click(function(){
		var num=jQuery("#jumpNum").val();
		if(num==""){
			alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;}
		 var reg=/^[0-9]+$/;
		 if(!reg.test(num)){
			alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;
		 }

		if(num<1)
			num=1;
		var href="login_log.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		document.location.href=href;
	});

});
</script>
</body>
</html>