<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%!

public String getParentChannelPath(Channel channel) throws MessageException, SQLException{

    String path = "";
    ArrayList arraylist = channel.getParentTree();

    if ((arraylist != null) && (arraylist.size() > 0))
    {
      for (int i = 0; i < arraylist.size(); ++i)
      {
        Channel ch = (Channel)arraylist.get(i);

		if((i+1)==arraylist.size()){//当前频道名
			path = path + "<span class=\"breadcrumb-item active\">" + ch.getName() + "</span>";// + ((i < arraylist.size() - 1) ? "/" : "");
		}else{
			path = path + "<a class=\"breadcrumb-item\" href=\"\">" + ch.getName() + "</a>";// + ((i < arraylist.size() - 1) ? "/" : "");
		}        
      }
    }

    arraylist = null;

    return path;
}
%>
<%
/**
* 用途：社区列表页
*/
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
if(currPage<1)
	currPage = 1;

if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage = 20;

if(rows==0)
	rows = Util.parseInt(Util.getCookieValue("rows",request.getCookies()));
if(cols==0)
	cols = Util.parseInt(Util.getCookieValue("cols",request.getCookies()));

if(rows==0)
	rows = 10;
if(cols==0)
	cols = 5;

Channel channel = CmsCache.getChannel(id);

if(channel==null || channel.getId()==0)
{
	response.sendRedirect("../content/content_nochannel.jsp");
	return;
}

Channel parentchannel = null;
int ChannelID = channel.getId();
String ChannelName = channel.getName();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();
String gids = "";

int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list",request.getCookies()));
if(listType==0) listType = 1;

boolean listAll = false;

if(channel.isTableChannel() && channel.getType2()==8) listAll = true;

if(channel.getType()==2)
{
	response.sendRedirect("../page/content_page.jsp?id="+id);
	return;
}


//如果是“新建应用”；
if(channel.getType()==3)
{
	response.sendRedirect("app.jsp?id="+id);
	return;
}

String S_Title			=	getParameter(request,"Title");
//String S_Summary		=	getParameter(request,"Summary");
String S_startDate			=	getParameter(request,"startDate");
String S_endDate			=	getParameter(request,"endDate");
String S_User			=	getParameter(request,"User");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

String querystring = "";
querystring = "&Summary="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&startDate="+S_startDate+"&endDate="+S_endDate+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");return;
}

String SiteAddress = channel.getSite().getUrl();


//获取频道路径
String parentChannelPath = getParentChannelPath(channel);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 7 列表</title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	.collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
	table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
	table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
	border-collapse: collapse !important;}
	.list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;}
	.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/content.js"></script>

<script>
var listType = 1;
var rows = <%=rows%>;
var cols = <%=cols%>;
var ChannelID = <%=ChannelID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var ChannelName = "<%=ChannelName%>";
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var pageName = "<%=pageName%>";
if(pageName=="") pageName = "content.jsp";

function gopage(currpage)
{
	var url = pageName + "?currPage="+currpage+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
	this.location = url;
}

function list(str)
{
	var url = pageName + "?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
	if(typeof(str)!='undefined')
		url += "&" + str;
	this.location = url;
}

function Preview22(id)
{
	tidecms.dialog("content/video_player3.jsp?id="+id,640,510,"视频预览");
}
function deleteFile_1(){
	var obj=getCheckbox();
	var message = "确实要删除这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要删除的文件！");
	}else{
		 if(confirm(message)){
			 var url="cutv_comment_action.jsp?id=" + obj.id+"&action=1";
			  $.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.href=document.location.href;}   
			});  
		}
	}
}

function deleteFile2(){
	var obj=getCheckbox();
	var message = "确实要撤销这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要撤销的文档！");
	}else{
		 if(confirm(message)){
			 var url="cutv_comment_action.jsp?id=" + obj.id+"&action=3";
			  $.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.href=document.location.href;}   
			});  
		}
	}
}

function approve(){
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要审核的评论！");
		return;
	}

	var message = "确实要审核这"+obj.length+"项吗？";
	
	if(!confirm(message)){
			return;
	}

	approve_(obj.id);
}


function approve2(id){
	var message = "确实要审核这1项吗？";
	
	if(!confirm(message)){
			return;
	}


	 approve_(id);	
}

function approve_(id)
{
	 var url= "cutv_comment_action.jsp?id=" + id +"&action=2";
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.reload();}   
		}); 
}
function delfile2(id){
	var message = "确实要撤销这1项吗？";
	
	if(!confirm(message)){
			return;
	}


	 delfile(id);	
}
function delfile(id){
	var url= "cutv_comment_action.jsp?id=" + id +"&action=3";
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.reload();}   
	}); 
}
function resume22(id){
	var message = "确实要恢复这1项吗？";
	
	if(!confirm(message)){
			return;
	}


	 resume1(id);	
}
function resume1(id){
	var url= "cutv_comment_action.jsp?id=" + id +"&action=4";
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.reload();}   
	}); 
}

</script>
</head>
<body class="collapsed-menu email" id="channel-manage">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
	
	<div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active"><%=channel.getParentChannelPath().replace(">"," / ")%></span>
        </nav>
    </div><!-- br-pageheader -->

<%
int S_UserID = 0;
long weightTime = 0;
int IsActive = 1;
if(IsDelete==1) IsActive=0;

if(!S_User.equals("")){
	String sql2="select * from uchome_comment where author='"+S_User+"'";
	TableUtil tu2 = new TableUtil("sns");
	ResultSet Rs2 = tu2.executeQuery(sql2);
	if(Rs2.next()){
		S_UserID=Rs2.getInt("authorid");
	}else{
		S_UserID=0;
	}
}

//System.out.println("time:"+weightTime);
String Table = channel.getTableName();
String ListSql = "select active,title,cid,id,ip,message,FROM_UNIXTIME(dateline) as dateline,url,authorid,status,author from uchome_comment";
String CountSql = "select count(*) from uchome_comment";

//if(!S_User.equals(""))
	//CountSql = "select count(*) from "+Table+" ";

ListSql += " where idtype in ('news','kn2012','cw2012','movie')";
CountSql += " where  idtype in ('news','kn2012','cw2012','movie')";

String WhereSql = "";

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and message like '%" + channel.SQLQuote(tempTitle) + "%'";
}
if(!S_startDate.equals("")){
	long startTime=Util.getFromTime(S_startDate,"");
	WhereSql += " and CreateDate>="+startTime ;
}
if(!S_endDate.equals("")){
	long endTime=Util.getFromTime(S_endDate,"");
	WhereSql += " and CreateDate<"+(endTime+86400);
}

if(S_UserID>0)
{
	WhereSql += " and authorid ="+S_UserID;
}

if(S_Status!=0)
	WhereSql += " and status=" + (S_Status-1);

if(Status1!=0)
{
	if(Status1==-1)
		WhereSql += " and status=0";
	else
		WhereSql += " and status=" + Status1;
}

WhereSql += " and Active="+IsActive;

ListSql += WhereSql;
CountSql += WhereSql;


ListSql += " order by dateline desc";

//out.println(ListSql);

int listnum = rowsPerPage;
if(listType==2) listnum = cols*rows;

TableUtil tu = new TableUtil("sns");
ResultSet Rs = null;

try{

	Rs = tu.List(ListSql,CountSql,currPage,listnum);

	int TotalPageNumber = tu.pagecontrol.getMaxPages();
	int TotalNumber = tu.pagecontrol.getRowsCount();

%>
	<!--操作-->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

		<!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
          <div class="dropdown-menu pd-10">
            <nav class="nav nav-style-1 flex-column">
              <a href="javascript:list();" class="nav-link list_all">全部</a>
			  <a href="javascript:list('Status1=-1');" class="nav-link list_draft">未审核</a>
			  <a href="javascript:list('Status1=1');" class="nav-link list_publish">已审核</a>
			  <a href="javascript:list('IsDelete=1');" class="nav-link list_delete">已删除</a>
			  <a href="#" class="nav-link">搜索</a>
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
        <!-- END: 只显示在移动端 -->

        <div class="btn-group mg-l-10 hidden-xs-down">
          <a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
          <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">未审核</a>
          <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已审核</a>
          <a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
          <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div><!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
			<a href="javascript:approve();" class="btn btn-outline-info">审核通过</a>
			<a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
			<a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
			<a href="javascript:deleteFile2();" class="btn btn-outline-info">撤销审核</a>
		<%if(!channel.getRecommendOut().equals("")){%>
			<a href="javascript:recommendOut()" class="btn btn-outline-info">推荐</a>
		<%}%>
		<%if(!channel.getAttribute1().equals("")){%>
			<a href="javascript:recommendIn();" class="btn btn-outline-info">引用</a>
		<%}%>
			<a href="javascript:deleteFile_1();" class="btn btn-outline-info">删除</a>  
        </div><!-- btn-group -->
        
        <div class="btn-group mg-l-10 hidden-sm-down">
          <%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a><%}%>
          <%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a><%}%>
        </div><!-- btn-group -->

		<!-- START: 只显示在移动端 -->
        <div class="dropdown mg-l-auto hidden-md-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
          <div class="dropdown-menu dropdown-menu-right pd-10">
            <nav class="nav nav-style-1 flex-column">
				<a href="javascript:approve();" class="nav-link">审核通过</a>
				<a href="javascript:Preview();" class="nav-link">预览</a>
				<a href="javascript:editDocument1();" class="nav-link">编辑</a>
				<a href="javascript:deleteFile2();" class="nav-link">撤销审核</a>
			<%if(!channel.getRecommendOut().equals("")){%>
				<a href="javascript:recommendOut()" class="nav-link">推荐</a>
			<%}%>
			<%if(!channel.getAttribute1().equals("")){%>
				<a href="javascript:recommendIn();" class="nav-link">引用</a>
			<%}%>
				<a href="javascript:deleteFile_1();" class="nav-link">删除</a> 
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
        <!-- END: 只显示在移动端 -->

     </div><!--操作-->

	 <!--搜索-->
     <div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
		<div class="search-content bg-white">
			<form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">
      		<div class="row">
				<!--标题-->
				<div class="mg-r-10 mg-b-30 search-item">
				  <input class="form-control search-title" placeholder="评论内容" type="text" name="Title" value="<%=S_Title%>">
				</div>
				<!--日期-->
				<div class="wd-200 mg-b-30 mg-r-10 search-item">
					<div class="input-group">
						<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
						<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="startDate">
					</div>
				</div>
				<div class="wd-20 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>
				<div class="wd-200 mg-b-30 mg-r-10 search-item">
					<div class="input-group">
						<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
						<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="endDate">
					</div>
				</div>
				<!-- wd-200 -->
				<!--作者-->
				<div class="mg-r-10 mg-b-30 search-item">
					<div class="input-group">
						<span class="input-group-addon"><i class="icon ion-person tx-16 lh-0 op-6"></i></span>
						<input type="text" class="form-control search-author" placeholder="作者" name="User" value="<%=S_User%>">
					</div>
				</div>
				<!--状态-->
				<div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
					<select class="form-control select2" data-placeholder="状态" name="Status">
						<option label="Choose one"></option>
					    <option value="0">全部</option>
						<option value="2" <%=(S_Status==2?"selected":"")%>>已审核</option>
						<option value="1" <%=(S_Status==1?"selected":"")%>>未审核</option>
					</select>
				</div>
				<div class="search-item mg-b-30">
					<input type="submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
					<input type="hidden" name="OpenSearch" id="OpenSearch" value="0">
				</div>
			</div><!-- row -->
			</form>
      	</div>
     </div><!--搜索-->

<%if(channel.hasRight(userinfo_session,1)){%>
	<!--列表-->
	 <div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0 <%=listType==2?"table-fixed":""%>" id="content-table">
<%if(listType==1){%>
				<thead>
				  <tr>
					<th class="wd-5p">
					  <label class="ckbox mg-b-0">
						<input type="checkbox" id="checkAll"><span></span>
					  </label>
					</th>
					<th class="tx-12-force tx-mont tx-medium">评论</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">状态</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">用户</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">文章</th>
					<th class="tx-12-force wd-150 tx-mont tx-medium hidden-xs-down">操作</th>
				  </tr>
				</thead>
<%}%>
				<tbody>
<%

int j = 0;
int m = 0;
while(Rs!=null && Rs.next())
{
	int id_ = Rs.getInt("cid");
	int Status = Rs.getInt("status");
	int authorid = Rs.getInt("authorid");
	String message	= convertNull(Rs.getString("message"));
	String title	= convertNull(Rs.getString("title"));
	String url	= convertNull(Rs.getString("url"));
	String IP	= convertNull(Rs.getString("ip"));

	String ModifiedDate	= convertNull(Rs.getString("dateline"));
	ModifiedDate=Util.FormatDate("yyyy-MM-dd HH:mm",ModifiedDate);


	String author	= convertNull(Rs.getString("author"));	
	String StatusDesc = "";
	if(IsDelete!=1){
		if(Status==0)
			StatusDesc = "<font color=red>未审核</font>";
		else if(Status==1)
			StatusDesc = "<font color=green>已审核</font>";
	}else{
		StatusDesc = "<font color=red>已删除</font>";
	}


	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;

	if(listType==1)
	{
%>
		<tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  status="<%=Status%>" id="item_<%=id_%>" class="tide_item">
			<td class="valign-middle">
			  <label class="ckbox mg-b-0">
				<input type="checkbox" name="id" value="<%=id_%>"><span></span>
			  </label>
			</td>
			<td ondragstart="OnDragStart (event)">
			  <div class="comment_date">提交于 <%=ModifiedDate%></div>
			  <span class="pd-l-5 tx-black"><%=message%></span>
			</td>
			<td class="hidden-xs-down"><%=StatusDesc%></td>
			<td class="hidden-xs-down"><a href="http://sns.cutv.com/space.php?uid=<%=authorid%>" target="_blank"><%=author%></a><br/><%=IP%></td>
			<td class="hidden-xs-down"><a href="<%=url%>" target="_blank"><%=title%></a></td>
			<td class="dropdown hidden-xs-down">
				<% if(IsDelete!=1){
					if(Status==0){%>
						<a href="javascript:approve2(<%=id_%>);" class="btn pd-0 mg-r-5" title="审核通过"><i class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>
					<%}else if(Status==1){%>
						<a href="javascript:delfile2(<%=id_%>);" class="btn pd-0 mg-r-5" title="撤销审核"><i class="fa fa-reply tx-18 handle-icon" aria-hidden="true"></i></a>
					<%}%>
					
						<a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info"><i class="icon ion-more"></i></a>
						<div class="dropdown-menu dropdown-menu-right pd-10">
							<nav class="nav nav-style-1 flex-column">
								<a href="javascript:approve2(<%=id_%>);" class="nav-link">审核通过</a>
								<a href="javascript:Preview3(<%=id_%>);" class="nav-link">预览</a>
								<a href="javascript:editDocument(<%=id_%>);" class="nav-link">编辑</a>
								<a href="javascript:deleteFile3(<%=id_%>);" class="nav-link">撤销审核</a>
							<%if(!channel.getRecommendOut().equals("")){%>
								<a href="javascript:recommendOut1(<%=id_%>);" class="nav-link">推荐</a>
							<%}%>
								<a href="javascript:deleteFile1(<%=id_%>);" class="nav-link">删除</a>
							</nav>
						</div><!-- dropdown-menu -->

				<%}else{%>
					<a href="javascript:resume22(<%=id_%>);" class="btn pd-0 mg-r-5" title="恢复"><i class="fa fa-reply tx-18 handle-icon" aria-hidden="true"></i></a>
				<%}%>
				
			</td>
		</tr>
<%  }	
}

if(listType==2 && m<cols) out.println("</tr>");

tu.closeRs(Rs);
%>
				</tbody>
			</table>

		<script>
			var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
		</script> 
		<%if(TotalPageNumber>0){%> 
			<!--分页-->
			<div id="tide_content_tfoot">
				<label class="ckbox mg-b-0 mg-r-30 ">
					<input type="checkbox" id="checkAll_1"><span></span>
				</label> 
          		<span class="mg-r-20 ">共<%=TotalNumber%>条</span>
          		<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

				<%if(TotalPageNumber>1){%><%}%>
				<div class="jump_page ">
          			<span class="">跳至:</span>
          			<label class="wd-60 mg-b-0">
						<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
					</label>
					<span class="">页</span>
					<a href="javascript:jumpPage();" class="tx-14">Go</a>
				</div>
          		<%if(listType==1){%>
          		<div class="each-page-num mg-l-20 ">
          			<span class="">每页显示:</span>
          			<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="状态" onChange="change('#rowsPerPage','<%=id%>');" id="rowsPerPage">
						<option value="10">10</option>
						<option value="15">15</option>
						<option value="20">20</option>
						<option value="25">25</option>
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="80">80</option>
						<option value="100">100</option>
						<option value="500">500</option>
						<option value="1000">1000</option>
						<option value="5000">5000</option>               
					</select>
					<span class="">条</span>
          		</div>

				<%}
				if(listType==2){%>
				<%}%>

			</div><!--分页-->
          <%}%>
			<div class="table-page-info" style="display: none;">
          		<div class="ckbox-parent">
          			<label class="ckbox mg-b-0">
						<input type="checkbox" id="checkAll"><span></span>
					</label>
          		</div>
			</div>

		</div>
	 </div><!--列表-->

	   
	 <!--操作-->
	 <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

        <!--<button id="showSubLeft" class="btn btn-secondary mg-r-10 hidden-lg-up"><i class="fa fa-navicon"></i></button>-->

		<!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
          <div class="dropdown-menu pd-10">
            <nav class="nav nav-style-1 flex-column">
              <a href="javascript:list();" class="nav-link list_all">全部</a>
			  <a href="javascript:list('Status1=-1');" class="nav-link list_draft">未审核</a>
			  <a href="javascript:list('Status1=1');" class="nav-link list_publish">已审核</a>
			  <a href="javascript:list('IsDelete=1');" class="nav-link list_delete">已删除</a>
			  <a href="#" class="nav-link">搜索</a>
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
        <!-- END: 只显示在移动端 -->


        <div class="btn-group mg-l-10 hidden-xs-down">
          <a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
          <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">未审核</a>
          <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已审核</a>
          <a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
          <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div><!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
			<a href="javascript:approve();" class="btn btn-outline-info">审核通过</a>
			<a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
			<a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
			<a href="javascript:deleteFile2();" class="btn btn-outline-info">撤销审核</a>
		<%if(!channel.getRecommendOut().equals("")){%>
			<a href="javascript:recommendOut()" class="btn btn-outline-info">推荐</a>
		<%}%>
		<%if(!channel.getAttribute1().equals("")){%>
			<a href="javascript:recommendIn();" class="btn btn-outline-info">引用</a>
		<%}%>
			<a href="javascript:deleteFile_1();" class="btn btn-outline-info">删除</a>  
        </div><!-- btn-group -->

        <div class="btn-group mg-l-10 hidden-sm-down">
          <%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a><%}%>
          <%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a><%}%>
        </div><!-- btn-group -->

		<!-- START: 只显示在移动端 -->
        <div class="dropdown mg-l-auto hidden-md-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
          <div class="dropdown-menu dropdown-menu-right pd-10">
            <nav class="nav nav-style-1 flex-column">
				<a href="javascript:approve();" class="nav-link">审核通过</a>
				<a href="javascript:Preview();" class="nav-link">预览</a>
				<a href="javascript:editDocument1();" class="nav-link">编辑</a>
				<a href="javascript:deleteFile2();" class="nav-link">撤销审核</a>
			<%if(!channel.getRecommendOut().equals("")){%>
				<a href="javascript:recommendOut()" class="nav-link">推荐</a>
			<%}%>
			<%if(!channel.getAttribute1().equals("")){%>
				<a href="javascript:recommendIn();" class="nav-link">引用</a>
			<%}%>
				<a href="javascript:deleteFile_1();" class="nav-link">删除</a> 
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
        <!-- END: 只显示在移动端 -->

    </div><!--操作-->
<%}else{%>
	<script>
		var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:0};
	</script> 
<%}%>

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

	<script>

//==========================================
//设置高亮
var Status1_ = <%=Status1%>;
var IsDelete_ = <%=IsDelete%>;
$(function(){

	if(Status1_==-1){

		$(".list_draft").addClass("active");

	}else if(Status1_==1){

		$(".list_publish").addClass("active");
	
	}else if(IsDelete_==1){

		$(".list_delete").addClass("active");

	}else{
		$(".list_all").addClass("active");
	}
});



//===========================================
      $(function(){
        'use strict';

        //show only the icons and hide left menu label by default
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
        
        $(document).on('mouseover', function(e){
          e.stopPropagation();
          if($('body').hasClass('collapsed-menu')) {
            var targ = $(e.target).closest('.br-sideleft').length;
            if(targ) {
              $('body').addClass('expand-menu');

              // show current shown sub menu that was hidden from collapsed
              $('.show-sub + .br-menu-sub').slideDown();

              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.removeClass('d-lg-none');
              menuText.removeClass('op-lg-0-force');

            } else {
              $('body').removeClass('expand-menu');

              // hide current shown menu
              $('.show-sub + .br-menu-sub').slideUp();

              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.addClass('op-lg-0-force');
              menuText.addClass('d-lg-none');
            }
          }
        });

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function(e){
          e.preventDefault();
          if($('body').hasClass('show-mb-left')) {
            $('body').removeClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
          } else {
            $('body').addClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
          }
        });
        
    
		$("#content-table tr:gt(0)").click(function () {     
			if ($(this).find(":checkbox").prop("checked"))// 此处要用prop不能用attr，至于为什么你测试一下就知道了。    
			{    
				$(this).find(":checkbox").removeAttr("checked");    
			}else{    
				$(this).find(":checkbox").prop("checked", true);    
			}     
		}); 
		$("#checkAll,#checkAll_1").click(function(){
			var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
			var existChecked = false ;
			for (var i=0;i<checkboxAll.length;i++) {
				if(!checkboxAll.eq(i).prop("checked")){
					existChecked = true ;
				}
			}
			if(existChecked){
				checkboxAll.prop("checked",true);
			}else{
				checkboxAll.removeAttr("checked");
			}
			return;
		})
		$(".btn-search").click(function(){
			$(".search-box").toggle(100);
		})
		     
		    // Datepicker
        $('.fc-datepicker').datepicker({
          showOtherMonths: true,
          selectOtherMonths: true,
		  dateFormat: "yy-mm-dd"
        });
  
      });
    </script>

<%}catch(Exception e){
	//System.out.println("::"+e.getMessage());
	if(e.getMessage().contains("连接数据库失败"))
	{
		
		out.println("<div class=\"channel-name mg-l-30 mg-r-30\"><div class=\"channel-name-box\"><div class=\"set-img-box\"><i class=\"fa fa-exclamation-triangle tx-50 lh-72\" aria-hidden=\"true\"></i></div><div class=\"right-info\"><h5 class=\"tx-22\">不能获取数据</h5><p class=\"tx-12\">请联系系统管理员确定配置是否正确，或拨打400-0873-128寻求技术支持。</p></div></div></div>");
	}
}%>

</div>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
