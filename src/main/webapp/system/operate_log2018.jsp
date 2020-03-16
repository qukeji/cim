<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.publish.*,
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

int logaction			= getIntParameter(request,"LogAction");

int  Log_Action         =   getIntParameter(request,"Log_Action");
String S_startDate		=	getParameter(request,"startDate");
String S_endDate	=	getParameter(request,"endDate");
String S_User			=	getParameter(request,"S_User");
String S_Title			=   getParameter(request,"S_Title");
int S_Status			=	getIntParameter(request,"Status");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");

int s_userid			=   getIntParameter(request,"s_userid");
String Log_Action_name="";
if((Log_Action!=0)||(!S_startDate.equals(""))||(!S_endDate.equals("")) ){
    S_OpenSearch=1;
}

String FromType1			=	getParameter(request,"FromType");

String querystring = "";
querystring = "&S_Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&Log_Action="+Log_Action+"&startDate="+S_startDate+"&endDate="+S_endDate+"&FromType="+FromType1+"&s_userid="+s_userid+"&S_User="+S_User+"&LogAction="+logaction;

String Action = getParameter(request,"Action");
if(Action.equals("Del"))
{
/*	int id = getIntParameter(request,"id");

	String Sql = "delete from operate_log where id=" + id;

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("operate_log2018.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage);
*/
}
else if(Action.equals("Clear"))
{
	if(userinfo_session.getUsername().equals("admin"))
	{
		String Sql = "TRUNCATE tidecms_log";

		TableUtil tu = new TableUtil();
		
		tu.executeUpdate(Sql);

		response.sendRedirect("operate_log2018.jsp");return;
	}
}

int S_UserID=0;
if(s_userid==0 && S_User.length()>0)
{
	TableUtil tu = new TableUtil("user");
	ResultSet rs = tu.executeQuery("select id from userinfo where Username='" + tu.SQLQuote(S_User) + "' or Name='" + tu.SQLQuote(S_User) + "'");
	if(rs.next())
		S_UserID = rs.getInt("id");
	tu.closeRs(rs);
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
<html>

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
<script src="../common/2018/common2018.js"></script> 
<!--  <script type="text/javascript" src="../common/ui.core.js"></script>	 -->					
<!--  <script type="text/javascript" src="../common/jquery.tablesorter.js"></script> -->
<!--  <script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script> -->                                          
<script src="../common/2018/content.js"></script>
<script language="javascript">
var listType = 1;

function ClearItems() {
	if (confirm("确实要清空操作日志吗？")) {
		this.location = "operate_log2018.jsp?Action=Clear";
	}
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

	function selectdate(fieldname) {
		var args = "font-size:10px;dialogWidth:286px;dialogHeight:290px;center:yes;status:no;help:no";
		var Feature = new Array();
		var selectdate = window.showModalDialog("../content/selectdate.htm", Feature, args);
		//alert(document.all(fieldname));
		if (selectdate != null) {
			if (document.all(fieldname).value != "") {
				arrayOfStrings = document.all(fieldname).value.split(" ");
				if (arrayOfStrings.length == 1)
					document.all(fieldname).value = selectdate;
				else
					document.all(fieldname).value = selectdate + " " + arrayOfStrings[1];
			} else
				document.all(fieldname).value = selectdate;
		}
	}

	function check() {
		//var CreateDate=document.getElementById("CreateDate").value;
		return true;
	}

	function openSearch(obj) {
		var SearchArea = document.getElementById("SearchArea");
		if (SearchArea.style.display == "none") {
			SearchArea.style.display = "";
		} else {
			SearchArea.style.display = "none";
		}
	}
	function gopage(currpage) {
		var url = "operate_log2018.jsp?currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		this.location = url;
	   }
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>

<body class="collapsed-menu email">

	<div class="br-mainpanel br-mainpanel-file" id="js-source">
		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active">日志管理 / 内容操作日志</span>
			</nav>
		</div>
		<!-- br-pageheader -->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
			<div class="btn-group hidden-xs-down">
				<a href="operate_log2018.jsp" class="btn btn-outline-info list_all">全部</a>
				<a href="operate_log2018.jsp?LogAction=1" class="btn btn-outline-info list_archive">文档</a>
				<a href="operate_log2018.jsp?LogAction=2" class="btn btn-outline-info list_channel">频道</a>
				<a href="operate_log2018.jsp?LogAction=3" class="btn btn-outline-info list_page">页面</a>
				<a href="operate_log2018.jsp?LogAction=4" class="btn btn-outline-info list_template">模板</a>
				<a href="operate_log2018.jsp?LogAction=5" class="btn btn-outline-info list_site">站点</a>
				<a href="operate_log2018.jsp?LogAction=7" class="btn btn-outline-info list_file">文件</a>
				<a href="operate_log2018.jsp?LogAction=8" class="btn btn-outline-info list_user">用户</a>
				<a href="#" class="btn btn-outline-info btn-search" onClick="openSearch();">检索</a>
			</div>
<%	 
Log l = new Log();
tidemedia.cms.publish.PublishScheme pt = new tidemedia.cms.publish.PublishScheme();	

String ListSql = "select * from tidecms_log  where 1=1";
String CountSql = "select count(*) from tidecms_log where 1=1";

String whereSql = "";

switch(logaction)
{
	case 0://全部
		break;
	case 1://文档
		whereSql +=" and LogAction >=100 and LogAction <200 ";
		break;
	case 2://频道
		whereSql +=" and LogAction >=200 and LogAction <300 ";
		break;
	case 3://页面
		whereSql +=" and LogAction >=300 and LogAction <400 ";
		break;
	case 4://模板
		whereSql +=" and LogAction >=400 and LogAction <500 ";
		break;
	case 5://站点
		whereSql +=" and LogAction >=500 and LogAction <600 ";
		break;
	case 6://发布进程
		whereSql +=" and LogAction >=600 and LogAction <700 ";
		break;
	case 7://文件
		whereSql +=" and LogAction >=700 and LogAction <800 ";
		break;
	case 8://用户
		whereSql +=" and LogAction >=800 and LogAction <900 ";
		break;
	case 9://参数
		whereSql +=" and LogAction >=900 and LogAction <1000 ";
		break;
	case 10://其他
		whereSql +=" and LogAction >=1000 and LogAction <1100 ";
		break;


}
 
if(S_Title.length()>0)
{
	whereSql += " and Title like '%" + pt.SQLQuote(S_Title) + "%'";
}

if(S_UserID>0)
{
    whereSql +=" and User="+S_UserID+"";
}

if(s_userid>0)
	whereSql += " and User="+s_userid;

if(!userids.equals("")){
	whereSql += " and User in ("+userids+")";
}

if(Log_Action!=0){ 
	 
 switch(Log_Action){
	 case 1:
	    ListSql+=" and LogAction ="+LogAction.document_publish;
	    CountSql+=" and LogAction ="+LogAction.document_publish;
	  break;
	  case 2:  
		  ListSql+=" and LogAction ="+LogAction.document_edit;
	      CountSql+=" and LogAction ="+LogAction.channel_edit;
	     break;
     case 3:  
		  ListSql+=" and LogAction ="+LogAction.document_add;
	      CountSql+=" and  LogAction ="+LogAction.document_add;
	   break;
	 case 4:  
	      ListSql+=" and  LogAction ="+LogAction.document_delete;
          CountSql+=" and  LogAction ="+LogAction.document_delete;;
     break;
     case 5:  
		  ListSql+=" and LogAction ="+LogAction.channel_add;
	      CountSql+=" and LogAction ="+LogAction.channel_add;
	    break;
     case 6:  
		  ListSql+=" and LogAction ="+LogAction.channel_edit;
	      CountSql+=" and LogAction ="+LogAction.channel_edit;
	    break;
 }
  
}
if(!S_startDate.equals("")){
	ListSql += " and CreateDate >= "+"'"+S_startDate+"'";
	CountSql += " and CreateDate >= "+"'"+S_startDate+"'";
}
if(!S_endDate.equals("")){
	ListSql += " and CreateDate < "+"'"+S_endDate+"'";
	CountSql += " and CreateDate < "+"'"+S_endDate+"'";
}	
	
//if(!S_CreateDate.equals("")){
//	 ListSql+=" and  CreateDate "+S_CreateDate1+" '"+S_CreateDate+"'";
//     CountSql+=" and  CreateDate "+S_CreateDate1+" '"+S_CreateDate+"'";
//}

ListSql += whereSql;
CountSql += whereSql;

ListSql+=" order by id desc";
ResultSet Rs = pt.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = pt.pagecontrol.getMaxPages();
int TotalNumber = pt.pagecontrol.getRowsCount();
%>
								<!-- btn-group -->
								<div class="btn-group mg-l-auto hidden-sm-down">
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
                            <div class="search-box pd-x-20 pd-sm-x-30" id="SearchArea" style="display:<%=(S_OpenSearch==1?" ":"none ")%>">
                                <div class="search-content bg-white">
                                    <form name="search_form" action="operate_log2018.jsp?rowsPerPage=<%=rowsPerPage%>" method="post" onsubmit="return check()">
                                        <div class="row">
                                            <!--标题与用户条件-->
                                            <div class="mg-r-20 mg-b-40 search-item">
                                                <input class="form-control search-title" placeholder="标题" type="text" name="S_Title" size="10" value="<%=S_Title%>">
                                            </div>
                                            <div class="mg-r-20 mg-b-40 search-item">
                                                <input class="form-control search-title" placeholder="用户" type="text" name="S_User" size="15" value="<%=S_User%>">
                                            </div>
                                            <!--选择动作-->
                                            <div class=" mg-lg-t-0 mg-r-10 mg-b-50 search-item">
                                                <select class="form-control select2" name="Log_Action" id="Log_Action">
													<option value="0" >请选择动作</option>
													<option value="1" >审核通过</option>
													<option value="2">编辑文档</option>
													<option value="3">添加文档</option>
													<option value="4">删除文档</option>
													<option value="5">新建频道</option>
													<option value="6">编辑频道</option>						
												</select>
                                            </div>
                                            <div class="wd-80 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">创建日期:</div>


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
                                                <input type="submit" name="Submit" value="查找" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
                                                <input type="hidden" name="OpenSearch" value="0"></td>
                                            </div>
                                        </div>
                                        <!-- row -->
                                    </form>
                                </div>
                            </div>
                            <!--搜索-->
                            <div class="br-pagebody pd-x-20 pd-sm-x-30">
                                <div class="card bd-0 shadow-base">
                                    <table class="table mg-b-0" id="content-table">
									<thead>
                                            <tr>
                                                <th class="tx-12-force tx-mont tx-medium">编号</th>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down">用户</th>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down">动作</th>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down">对象</th>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down">标题</th>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down">日期</th>
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
				UserInfo user = (UserInfo)CmsCache.getUser(UserID);
				String CreateDate = convertNull(Rs.getString("CreateDate"));
				String Title = convertNull(Rs.getString("Title"));
				String LogType = convertNull(Rs.getString("LogType"));
				int logAction_ = Rs.getInt("LogAction");
				String action = LogAction.getActionDesc(logAction_);
			    String FromType = convertNull(Rs.getString("FromType"));
			    String FromTypeDesc = l.getFromDesc(FromType);
				String FromKey = convertNull(Rs.getString("FromKey"));
               
				if(FromType.equals("channel"))
				{//out.println(FromType);
					int cid = Util.parseInt(FromKey);//out.println(FromKey);
					if(cid>0)
					{
						Channel c_ = CmsCache.getChannel(cid);
						if(c_!=null)
						{
							FromTypeDesc = c_.getParentChannelPath();
						}
					}
				} 
				int id = Rs.getInt("id");

				j++;
%>
                                                <tr>
                                                    <td class="valign-middle"><label class="ckbox mg-b-0"><%=j%></label></td>
                                                    <td class="hidden-xs-down"><a href="operate_log2018.jsp?s_userid=<%=UserID%>"><%=user.getName()%>(<%=user.getUsername()%>)</a></td>
                                                    <td class="hidden-xs-down"><%=action%></td>
                                                    <td class="hidden-xs-down"><%=FromTypeDesc%></td>
                                                    <td class="hidden-xs-down"><%=Title%></td>
                                                    <td class="hidden-xs-down"><%=CreateDate%></td>
                                                </tr>
<%
			}		
}
pt.closeRs(Rs);
%>
</tbody>
</table>
                                    <div id="tide_content_tfoot">
                                        <span class="mg-r-20 ">共<%=TotalNumber%>条</span>
                                        <span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

                                        <%if(TotalPageNumber>1){%>
                                            <%}%>
                                                <div class="jump_page ">
                                                    <span class="">跳至:</span>
                                                    <label class="wd-60 mg-b-0">
						<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
					</label>
                                                    <span class="">页</span>
                                                    <a id="goToId" href="javascript:;" class="tx-14">Go</a>
                                                </div>
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
                               <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
                                <div class="btn-group hidden-xs-down">
                                    <a href="operate_log2018.jsp" class="btn btn-outline-info list_all">全部</a>
                                    <a href="operate_log2018.jsp?LogAction=1" class="btn btn-outline-info list_archive">文档</a>
                                    <a href="operate_log2018.jsp?LogAction=2" class="btn btn-outline-info list_channel">频道</a>
                                    <a href="operate_log2018.jsp?LogAction=3" class="btn btn-outline-info list_page">页面</a>
                                    <a href="operate_log2018.jsp?LogAction=4" class="btn btn-outline-info list_template">模板</a>
                                    <a href="operate_log2018.jsp?LogAction=5" class="btn btn-outline-info list_site">站点</a>
                                    <a href="operate_log2018.jsp?LogAction=7" class="btn btn-outline-info list_file">文件</a>
									<a href="operate_log2018.jsp?LogAction=8" class="btn btn-outline-info list_user">用户</a>
									<a href="#" class="btn btn-outline-info btn-search" onClick="openSearch();">检索</a>
                                </div>
								<!-- btn-group -->
								<div class="btn-group mg-l-auto hidden-sm-down">
							      <%if(currPage>1){%>
					                <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
					              <%}%>
								  <%if(currPage<TotalPageNumber){%>
									<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
							      <%}%>
								</div>
                                <!-- btn-group -->
                            </div>
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
				//设置高亮
						var logaction = <%=logaction%>;
					
						$(function() {

							if (logaction == 1) {

								$(".list_archive").addClass("active");

							} else if (logaction== 2) {

								$(".list_channel").addClass("active");

							} else if (logaction == 3) {

								$(".list_page").addClass("active");
                            } else if (logaction == 4) {
 
								$(".list_template").addClass("active");
                            } else if (logaction == 5) {
 
								$(".list_site").addClass("active");
							} else if (logaction == 7) {
 
								$(".list_file").addClass("active");
							} else if (logaction == 8) {
 
							    $(".list_user").addClass("active");
								
							} else {
								$(".list_all").addClass("active");
							}
						});
	
                            jQuery(document).ready(function() {
                                jQuery("#rowsPerPage").val('<%=rowsPerPage%>');
                                //日期弹窗		     
                                // Datepicker
                                $('.fc-datepicker').datepicker({
                                    showOtherMonths: true,
                                    selectOtherMonths: true
                                });
                                //鼠标移入弹出日期框
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
                                    var href = "operate_log2018.jsp?currPage=" + num + "&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
                                    document.location.href = href;
                                });

                            });

                            function change(obj) {
                                if (obj != null) this.location = "operate_log2018.jsp?rowsPerPage=" + obj.value + "<%=querystring%>";
                            }
                            $('.fc-datepicker').datepicker({
                                showOtherMonths: true,
                                selectOtherMonths: true,
                                dateFormat: "yy-mm-dd"
                            });
                        </script>
                    </body>

                    </html>