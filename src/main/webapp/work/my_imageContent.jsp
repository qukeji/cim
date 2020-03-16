<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="jdk.nashorn.internal.objects.annotations.Where" %>
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
			path = path + ch.getName() ;// + ((i < arraylist.size() - 1) ? " / " : "");
		}else{
			path = path + ch.getName() +" / ";// javascript:jumpContent("+ch.getId()+")
		}        
      }
    }

    arraylist = null;

    return path;
}
%>
<%
/**
* 用途：文档列表页
* 1,李永海 20140101 创建
* 2,王海龙 20150408  修改	 定制列表页无需再删除重定向代码
* 3,王海龙 20150609 修改     261行使用user数据源，解决按用户搜索bug
*/
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
String globalids="";
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
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();
String gids = "";
 

//if(channel.getListProgram().length()>0 && uri.endsWith("/content/content2018.jsp"))
//{response.sendRedirect(channel.getListProgram()+"?id="+id);return;}

String S_Title				=	getParameter(request,"Title");
String S_startDate			=	getParameter(request,"startDate");
String S_endDate			=	getParameter(request,"endDate");
String S_User				=	getParameter(request,"User");
int S_IsIncludeSubChannel	=	getIntParameter(request,"IsIncludeSubChannel");
int S_Status				=	getIntParameter(request,"Status");
int S_IsPhotoNews			=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch			=	getIntParameter(request,"OpenSearch");
int IsDelete				=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list_new",request.getCookies()));
if(listType==0) listType = 1;

boolean listAll = false;

if(channel.getParent()==-1){//说明是站点
	S_IsIncludeSubChannel = 0;
}

if(channel.isTableChannel() && channel.getType2()==8) listAll = true;
if(channel.getIsListAll()==1) listAll = true;
if(S_IsIncludeSubChannel==1) listAll = true;

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

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&startDate="+S_startDate+"&endDate="+S_endDate+"&User="+S_User+"&Status="+S_Status+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");return;
}

boolean canApprove = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);
boolean canDelete = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanDelete);
boolean canAdd = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanAdd);
int canExcel=channel.getIsExportExcel();//是否导出Excel
int canWord=channel.getIsImportWord();//是否导出world
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
<title>TideCMS 列表</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">
<link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />
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
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/content.js"></script>
<script>
	var listType = <%=listType%>;
	var rows = <%=rows%>;
	var cols = <%=cols%>;
	var ChannelID = <%=ChannelID%>;
	var currRowsPerPage = <%=rowsPerPage%>;
	var currPage = <%=currPage%>;
	var Parameter = "&ChannelID=" + ChannelID + "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
	var pageName = "<%=pageName%>";
	if (pageName == "") pageName = "content.jsp";

	function gopage(currpage) {
		var url = pageName + "?currPage=" + currpage + "&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		this.location = url;
	}

	function list(str) {
		var url = pageName + "?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
		if (typeof(str) != 'undefined')
			url += "&" + str;
		this.location = url;
	}
/*function SortDoc(){
	var myObject = new Object();
	var size = $(".cur").length;
	if(size>1||size<=0){
		alert("请选择一个待排序的选项");
	}else{
    myObject.title="排序";
	myObject.ChannelID =ChannelID;
	myObject.ItemId =$(".cur").attr("ItemID");
	myObject.OrderNumber = $(".cur").attr("OrderNumber");		
 
	var url= "content/document_sort.jsp?ChannelID="+ChannelID+"&ItemID="+myObject.ItemId+"&OrderNumber="+myObject.OrderNumber;
	var	dialog = new top.TideDialog();
		dialog.setWidth(250);
		dialog.setHeight(162);
		dialog.setUrl(url);
		dialog.setTitle(myObject.title);
		dialog.show();
	}
}*/
//批量上传图片
function uploadImages(){
	var url= "../photo/upload_images_photochannel.jsp?ChannelID="+ChannelID;
	var	dialog = new top.TideDialog();
		dialog.setWidth(700);
		dialog.setHeight(550);
		dialog.setLayer(2);
		dialog.setUrl(url);
		dialog.setTitle("批量上传图片");
		dialog.show();

	
}	
</script>
</head>

<body class="collapsed-menu email">
	<div class="br-mainpanel br-mainpanel-file" id="js-source">
		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active"><%=parentChannelPath%></span>
			</nav>
		</div>
		<!-- br-pageheader -->
<%
int S_UserID = 0;
long weightTime = 0;
int IsActive = 1;
if(IsDelete==1) IsActive=0;

if(!S_User.equals("")){
	TableUtil tu2 = new TableUtil();
	String sql2="select * from userinfo where Name='"+tu2.SQLQuote(S_User)+"'";	
	ResultSet Rs2 = tu2.executeQuery(sql2);
	if(Rs2.next()){
		S_UserID=Rs2.getInt("id");
	}else{
		S_UserID=0;
	}
}

if(channel.getIsWeight()==1)
{
	//权重排序
	java.util.Calendar nowDate = new java.util.GregorianCalendar();
	nowDate.set(Calendar.HOUR_OF_DAY,0);
	nowDate.set(Calendar.MINUTE,0);
	nowDate.set(Calendar.SECOND,0);
	nowDate.set(Calendar.MILLISECOND,0);
	weightTime = nowDate.getTimeInMillis()/1000;
}

//System.out.println("time:"+weightTime);
String Table = channel.getTableName();
String ListSql = "select id,Title,Photo,companyid,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,Parent,Filesize";

if(listType==2)
{
	ListSql += ",Summary,Content,Keyword";
}
if(channel.getIsWeight()==1)
	ListSql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
ListSql += " from " + Table;
String CountSql = "select count(*) from "+Table;

//if(!S_User.equals(""))
	//CountSql = "select count(*) from "+Table+" ";

if(!listAll)
{
	if(channel.getType()==Channel.Category_Type)
	{
		ListSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
		CountSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
	}
	else if(channel.getType()==Channel.MirrorChannel_Type)
	{
		Channel linkChannel = channel.getLinkChannel();
		if(linkChannel.getType()==Channel.Category_Type)
		{
			ListSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
			CountSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
		}
		else
		{
			ListSql += " where Category=0 and Active=" + IsActive;
			CountSql += " where Category=0 and Active=" + IsActive;
		}
	}
	else
	{
		ListSql += " where Active=" + IsActive;
		CountSql += " where Active=" + IsActive;
	}
}
else
{
	ListSql += " where ChannelCode like '"+channel.getChannelCode()+"%' and Active=" + IsActive;
	CountSql += " where ChannelCode like '"+channel.getChannelCode()+"%' and Active=" + IsActive;
}

String WhereSql = "";

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
}
if(!S_startDate.equals("")){
	long startTime=Util.getFromTime(S_startDate,"");
	WhereSql += " and CreateDate>="+startTime ;
}
if(!S_endDate.equals("")){
	long endTime=Util.getFromTime(S_endDate,"");
	WhereSql += " and CreateDate<"+(endTime+86400);
}

/*
if(S_IsIncludeSubChannel==1)
{
	WhereSql += " and ChannelCode like '"+channel.getChannelCode() + "%'";
}*/

/*if(S_UserID>0)
{
	WhereSql += " and User="+S_UserID;
}*/

 //if(S_IsPhotoNews==1)
 //	WhereSql += " and IsPhotoNews=1";
if(S_Status!=0)
	WhereSql += " and Status=" + (S_Status-1);

if(Status1!=0)
{
	if(Status1==-1)
		WhereSql += " and Status=0";
	else
		WhereSql += " and Status=" + Status1;
}
int companyid = userinfo_session.getCompany();
if(companyid!=0){
	WhereSql += " and companyid=" + companyid;
}
	WhereSql += " and User ="+userinfo_session.getId();
ListSql += WhereSql;
CountSql += WhereSql;

if(channel.getIsWeight()==1)
{
	ListSql += " order by newtime desc,id desc";
}
else
{
	ListSql += " order by OrderNumber desc";
}

//out.println(ListSql);
	System.out.println("我的图片listsql="+ListSql);
int listnum = rowsPerPage;
if(listType==2) listnum = cols*rows;

TableUtil tu = channel.getTableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
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
						<a href="javascript:list('Status1=-1');" class="nav-link list_draft">草稿</a>
						<a href="javascript:list('Status1=1');" class="nav-link list_publish">已发</a>
						<a href="javascript:list('IsDelete=1');" class="nav-link list_delete">已删除</a>
						<a href="#" class="nav-link">搜索</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端-->

			<div class="btn-group hidden-xs-down">
				<a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i class="fa fa-th"></i></a>
				<a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i class="fa fa-th-list"></i></a>
			</div>
			<!-- btn-group -->
			<div class="btn-group mg-l-10 hidden-xs-down">
				<a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
				<a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">草稿</a>
				<a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已发</a>
				<a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
				<a href="#" class="btn btn-outline-info btn-search">搜索</a>
			</div>
			<!-- btn-group -->

			<div class="btn-group mg-l-auto hidden-sm-down">
				<a href="javascript:addDocument();" class="btn btn-outline-info">新建</a>
				<%if(canApprove){%>
					<a href="javascript:approve();" class="btn btn-outline-info">发布</a>
					<a href="javascript:Preview();"  class="btn btn-outline-info">预览</a>
				<%}else{%>
					<a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
				<%}%>
					<a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
					<a href="javascript:deleteFile2();" class="btn btn-outline-info">撤稿</a>
					<a href="javascript:uploadImages();" class="btn btn-outline-info">批量上传</a>
				<%if(!channel.getRecommendOut().equals("")){%>
					<a href="javascript:recommendOut()" class="btn btn-outline-info">推荐</a>
				<%}%>
				<%if(!channel.getAttribute1().equals("")){%>
					<a href="javascript:recommendIn();" class="btn btn-outline-info hidden-md-1500-down">引用</a>
				<%}%>
		    <!--	<a href="javascript:copy(0)" class="btn btn-outline-info hidden-md-1500-down">复制</a>
				<a href="javascript:copy(1)" class="btn btn-outline-info hidden-md-1500-down">移动</a>  -->
				<%if(IsWeight!=1){%>
					<a href="javascript:SortDoc();" class="btn btn-outline-info hidden-md-1500-down">排序</a>
				<%}%>
				<%if(canDelete){%>
					<a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>
				<%}%>
			</div>
			<!-- START: 按钮过多时的部分功能下拉 -->
			<div class="dropdown hidden-md-1500-up hidden-sm-down mg-l-10">
				<a href="#" class="btn btn-outline-info" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
				<div class="dropdown-menu dropdown-menu-right pd-10">
					<nav class="nav nav-style-1 flex-column">					
						<%if(!channel.getAttribute1().equals("")){%>
						<a href="javascript:recommendIn();" class="nav-link">引用</a>
						<%}%>
						<%if(IsWeight!=1){%>
						<a href="javascript:SortDoc();" class="nav-link">排序</a>
						<%}%>				
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 按钮过多时的部分功能下拉 -->
			<!-- START: 只显示在移动端 -->
			<div class="dropdown mg-l-auto hidden-md-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
				<div class="dropdown-menu dropdown-menu-right pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="javascript:addDocument();" class="nav-link">新建</a>
						<%if(canApprove){%>
						<a href="javascript:approve();" class="nav-link">发布</a>
						<a href="javascript:Preview();" class="nav-link">预览</a>
						<%}else{%>
						<a href="javascript:Preview();" class="nav-link">预览</a>
						<%}%>
						<a href="javascript:editDocument1();" class="nav-link">编辑</a>
						<a href="javascript:deleteFile2();" class="nav-link">撤稿</a>
						<a href="javascript:uploadImages();" class="nav-link">批量上传</a>
						<%if(!channel.getRecommendOut().equals("")){%>
						<a href="javascript:recommendOut()" class="nav-link">推荐</a>
						<%}%>
						<%if(!channel.getAttribute1().equals("")){%>
						<a href="javascript:recommendIn();" class="nav-link">引用</a>
						<%}%>
					<!--	<a href="javascript:copy(0);" class="nav-link">复制</a>
						<a href="javascript:copy(1);" class="nav-link">移动</a>   -->
						<%if(IsWeight!=1){%>
						<a href="javascript:SortDoc();" class="nav-link">排序</a>
						<%}%>
						<%if(canDelete){%>
						<a href="javascript:deleteFile();" class="nav-link">删除</a>
						<%}%>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端 -->
						
			<!--上一页 下一页-->
			<div class="btn-group mg-l-10">
			<%if(currPage>1){%>
				<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
			<%}%>
			<%if(currPage<TotalPageNumber){%>
				<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
			<%}%>
			</div>
			<!-- btn-group -->
			
		</div>
		<!--操作-->

		<!--搜索-->
		<div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
			<div class="search-content bg-white">
				<form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onsubmit="return check();">
					<div class="row">
						<!--标题-->
						<div class="mg-r-10 mg-b-30 search-item">
							<input class="form-control search-title" placeholder="标题" type="text" name="Title" value="<%=S_Title%>" onClick="this.select()">
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
								<option value="2" <%=(S_Status==2?"selected":"")%>>已发</option>
								<option value="1" <%=(S_Status==1?"selected":"")%>>草稿</option>
							</select>
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

	<%if(channel.hasRight(userinfo_session,1)){%>
		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0 <%=listType==2?"table-fixed":""%>" id="content-table">
				<%if(listType==1){%>
					<thead>
						<tr>
							<th class="wd-5p wd-50">选择</th>
							<th class="tx-12-force tx-mont tx-medium">标题</th>
							<%if(IsWeight==1){%>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">权重</th>
							<%}%>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">文档标题</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120">频道</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-60">文件大小</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-60">状态</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">日期</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100 wd-author">作者</th>
							<%if(IsComment==1){%>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">评论</th>
							<%}%>
							<%if(IsClick==1){%>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">点击量</th>
							<%}%>
							<th class="tx-12-force wd-180 tx-mont tx-medium hidden-xs-down">操作</th>
						</tr>
					</thead>
                  <%}%>
					<tbody>
<%

int j = 0;
int m = 0;
int temp_gid=0;
while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	int category = Rs.getInt("Category");
	int user = Rs.getInt("User");
	int active = Rs.getInt("Active");
	int Parent = Rs.getInt("Parent");
	int FileSize_KB = Rs.getInt("Filesize")/1024;
	String p_title="";
	String p_channelname="";
	int p_itemid = 0;
	int p_channelid = 0;
	if(Parent>0){
		Document pdoc = new Document(Parent);
		p_title = pdoc.getTitle();
		p_channelname = pdoc.getChannel().getName();
		p_channelid = pdoc.getChannelID();
		p_itemid = pdoc.getId();
	}
	String Title	= convertNull(Rs.getString("Title"));
	//int IsPhotoNews = Rs.getInt("IsPhotoNews");
	if(listAll)
	{
		if(category>0)
			Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
	}
	int Weight=Rs.getInt("Weight");
	int GlobalID=Rs.getInt("GlobalID");


	if(temp_gid!=0){
		globalids+=",";
	}
	temp_gid++;
	globalids+=GlobalID+"";


	String ModifiedDate	= convertNull(Rs.getString("ModifiedDate"));
	ModifiedDate=Util.FormatDate("yyyy-MM-dd HH:mm",ModifiedDate);
	String UserName	= CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
	String StatusDesc = "";
	if(IsDelete!=1){
	if(Status==0)
		StatusDesc = "<span class='tx-orange'>草稿</span>";
	else if(Status==1)
		StatusDesc = "<span class='tx-success'>已发</span>";
	}else{
		StatusDesc = "<span class='tx-danger'>已删除</span>";
	}

	String Photo	= convertNull(Rs.getString("Photo"));
	String photoAddr = "";
	if(Photo.startsWith("http://"))
		photoAddr = Photo;
	else
		photoAddr = SiteAddress + Photo;

	if(gids.length()>0){gids+=","+GlobalID+"";}else{gids=GlobalID+"";}

	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;

	if(listType==1)
	{
%>
		<tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>" status="<%=Status%>" GlobalID="<%=GlobalID%>" id="item_<%=id_%>" data-url="<%=photoAddr%>" class="tide_item">
            <td class="valign-middle">
              <label class="ckbox mg-b-0">
				<input type="checkbox" name="id"  value="<%=id_%>"><span></span>
			  </label>
            </td>
            <td ondragstart="OnDragStart(event)">            
			 <i class="fa fa-picture-o tx-18 tx-primary lh-0 valign-middle" id="img_<%=j%>"></i>              
			 <!--  <i class="icon ion-clipboard tx-22 tx-warning lh-0 valign-middle" id="img_<%=j%>"></i> -->             
              <span class="pd-l-5 tx-black"><%=Title%></span>
            </td>		
			<%if(IsWeight==1){%>
			<td class="hidden-xs-down"><span ItemID="<%=id_%>"><%=Weight%></span></td>
			<%}%>
			<td  class="hidden-xs-down">
				<span ItemID="<%=p_itemid%>" ChannelID="<%=p_channelid%>">
					<%=p_title%>
				</span>
			</td>
			<td class="hidden-xs-down">
				<%=p_channelname%>
			</td>
			<td class="hidden-xs-down">
				<%=FileSize_KB%>k
			</td>
			<td class="hidden-xs-down">
				<%=StatusDesc%>
			</td>
			<td class="hidden-xs-down">
				<%=ModifiedDate%>
			</td>
			<td class="hidden-xs-down">
				<%=UserName%>
			</td>
			<%if(IsComment==1){%>
			<td class="hidden-xs-down"><span id="comment_<%=GlobalID%>"></span></td>
			<%}%>
			<%if(IsClick==1){%>
			<td class="hidden-xs-down"><span id="click_<%=GlobalID%>"></span></td>
			<%}%>
			<td class="dropdown hidden-xs-down">
				<%if(active==1 && canApprove){%>
				<a href="javascript:approve2(<%=id_%>);" class="btn pd-0 mg-r-5" title="发布"><i class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>
				<%}%>
				<%if(active==0 && userinfo_session.isAdministrator()){%>
				<a href="javascript:resume(<%=id_%>);" class="btn pd-0 mg-r-5" title="恢复"><i class="fa fa-reply tx-18 handle-icon" aria-hidden="true"></i></a>
				<%}else{%>
				<a href="javascript:Preview2('<%=photoAddr%>');" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
				<a href="javascript:Preview3('<%=photoAddr%>');" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
				<a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info"><i class="icon ion-more"></i></a>
				<div class="dropdown-menu dropdown-menu-right pd-10">
					<nav class="nav nav-style-1 flex-column">
					    <%if(canApprove){%>
						<a href="javascript:approve2(<%=id_%>);" class="nav-link">发布</a>
						<%}%>
						<a href="javascript:Preview3('<%=photoAddr%>');" class="nav-link">预览</a>
						<a href="javascript:editDocument(<%=id_%>);" class="nav-link">编辑</a>
						<a href="javascript:deleteFile3(<%=id_%>);" class="nav-link">撤稿</a>
						<%if(!channel.getRecommendOut().equals("")){%>
						<a href="javascript:recommendOut1(<%=id_%>);" class="nav-link">推荐</a>
						<%}%>
				    <!--	<a href="javascript:copy(0);" class="nav-link">复制</a>
						<a href="javascript:copy(1);" class="nav-link">移动</a>  -->
						<%if(IsWeight!=1){%>
						<a href="javascript:SortDoc1(<%=id_%>);" class="nav-link">排序</a>
						<%}%>
						<%if(canDelete){%>
						<a href="javascript:deleteFile1(<%=id_%>);" class="nav-link">删除</a>
						<%}%>
					</nav>
				</div>
				<!-- dropdown-menu -->
				<%}%>
			</td>
		</tr>
	<%}
	if(listType==2)
	{
		if(m==0) out.println("<tr>");
		m++;
%>
		<td id="item_<%=id_%>" status="<%=Status%>" class="tide_item" class="c" data-url="<%=photoAddr%>">
			<div class="row">
				<div class="col-md">
				<div class="card bd-0">
					<div class="list-pic-box">
					<img class="card-img-top" src="<%=photoAddr%>" alt="Image" onerror="checkLoad(this);" >
					</div>
					<div class="card-body bd-t-0 rounded-bottom">
					  <p class="card-text"><i class="icon ion-image tx-22 tx-warning lh-0 valign-middle"></i><%=Title%>(<%=StatusDesc%>)</p>
					  <div class="row mg-l-0 mg-r-0 mg-t-5">				                  					                  
						  <label class="ckbox mg-b-0 d-inline-block mg-r-5">
							<input name="id" value="<%=id_%>" type="checkbox"><span></span>
						  </label>
						  <%if(active==1 && canApprove){%>
						  <a href="javascript:approve2(<%=id_%>);" class="btn pd-0 mg-r-5" title="发布"><i class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>
						  <%}%>
						  <%if(active==0 && userinfo_session.isAdministrator()){%>
						  <a href="javascript:resume(<%=id_%>);" class="btn pd-0 mg-r-5" title="恢复"><i class="fa fa-reply tx-18 handle-icon" aria-hidden="true"></i></a>
						  <%}else{%>
						  <a href="javascript:Preview2('<%=photoAddr%>');" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
						  <a href="javascript:Preview3('<%=photoAddr%>');" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
						  <%}%>
					  </div>
					</div>
				  </div>
				</div>
			</div>  				          
		</td>
<%	
		if(m==cols){ out.println("</tr>");m=0;}
	} 
}
if(listType==2 && m<cols) out.println("</tr>");
tu.closeRs(Rs);
%>
					</tbody>
				</table>

				<script>
					var page = {
						id: '<%=id%>',
						currPage: '<%=currPage%>',
						rowsPerPage: '<%=rowsPerPage%>',
						querystring: '<%=querystring%>',
						TotalPageNumber: <%=TotalPageNumber%>
					};
				</script>
                
				<%if(TotalPageNumber>0){%>
				<!--分页-->
				<div id="tide_content_tfoot">
					<label class="ckbox mg-b-0 mg-r-30 ">
						<input type="checkbox" id="checkAll_1"><span></span>
					</label>
					<span class="mg-r-20 ">共<%=TotalNumber%>条</span>
					<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

					<%if(TotalPageNumber>1){%>
					<div class="jump_page ">
						<span class="">跳至:</span>
						<label class="wd-60 mg-b-0">
							<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
						</label>
						<span class="">页</span>
						<a href="javascript:jumpPage();" class="tx-14">Go</a>
					</div>
					<%}%>
                    <%if(listType==1){%>
					<div class="each-page-num mg-l-auto">
						<span class="">每页显示:</span>
						<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change('#rowsPerPage','<%=id%>');" id="rowsPerPage">
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
						
					<div class="each-page-num mg-l-auto">
						<span class="">每页显示:</span>
						<select name="rows" class="form-control select2 wd-80" data-placeholder="" onChange="changeRowsCols();" id="rows">
							<option value="3">3</option>
							<option value="5">5</option>
							<option value="8">8</option>
							<option value="10">10</option>
							<option value="20">20</option>
							<option value="50">50</option>
							<option value="100">100</option>          
						</select>
                        <span class="">行</span>
						<select name="cols" class="form-control select2 wd-80" data-placeholder="" onChange="changeRowsCols();" id="cols">
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="10">10</option>
							<option value="16">16</option>            
						</select>
                        <span class="">列</span>
                     </div>

                    <%}%>
				</div>
				<!--分页-->
				<%}%>
				<div class="table-page-info" style="display: none;">
					<div class="ckbox-parent">
						<label class="ckbox mg-b-0">
							<input type="checkbox" id="checkAll"><span></span>
						</label>
                    </div>
                </div>

			</div>
		</div>
		<!--列表-->

		<!--操作-->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

			<!--<button id="showSubLeft" class="btn btn-secondary mg-r-10 hidden-lg-up"><i class="fa fa-navicon"></i></button>-->

			<!-- START: 只显示在移动端 -->
			<div class="dropdown hidden-sm-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
				<div class="dropdown-menu pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="javascript:list();" class="nav-link list_all">全部</a>
						<a href="javascript:list('Status1=-1');" class="nav-link list_draft">草稿</a>
						<a href="javascript:list('Status1=1');" class="nav-link list_publish">已发</a>
						<a href="javascript:list('IsDelete=1');" class="nav-link list_delete">已删除</a>
						<a href="#" class="nav-link">搜索</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端 -->
            <div class="btn-group hidden-xs-down">
				<a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i class="fa fa-th"></i></a>
				<a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i class="fa fa-th-list"></i></a>
			</div>
			<!-- btn-group -->
			<div class="btn-group mg-l-10 hidden-xs-down">
				<a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
				<a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">草稿</a>
				<a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已发</a>
				<a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
				<a href="#" class="btn btn-outline-info btn-search">搜索</a>
			</div>
			<!-- btn-group -->

			<div class="btn-group mg-l-auto hidden-sm-down">
				<a href="javascript:addDocument();" class="btn btn-outline-info">新建</a>
				<%if(canApprove){%>
				<a href="javascript:approve();" class="btn btn-outline-info">发布</a>
				<a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
				<%}else{%>
				<a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
				<%}%>
				<a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
				<a href="javascript:deleteFile2();" class="btn btn-outline-info">撤稿</a>
				<a href="javascript:uploadImages();" class="btn btn-outline-info">批量上传</a>
				<%if(!channel.getRecommendOut().equals("")){%>
				<a href="javascript:recommendOut()" class="btn btn-outline-info">推荐</a>
				<%}%>
				<%if(!channel.getAttribute1().equals("")){%>
				<a href="javascript:recommendIn();" class="btn btn-outline-info hidden-md-1500-down">引用</a>
				<%}%>
				<%if(IsWeight!=1){%>
				<a href="javascript:SortDoc();" class="btn btn-outline-info hidden-md-1500-down">排序</a>
				<%}%>
				
				<%if(canDelete){%>
				<a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>
				<%}%>
			</div>
			
            <!-- START: 按钮过多时的部分功能下拉 -->
			<div class="dropdown hidden-md-1500-up hidden-sm-down mg-l-10">
				<a href="#" class="btn btn-outline-info" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
				<div class="dropdown-menu dropdown-menu-right pd-10">
					<nav class="nav nav-style-1 flex-column">					
						<%if(!channel.getAttribute1().equals("")){%>
						<a href="javascript:recommendIn();" class="nav-link">引用</a>
						<%}%>
						
						<%if(IsWeight!=1){%>
						<a href="javascript:SortDoc();" class="nav-link">排序</a>
						<%}%>			
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 按钮过多时的部分功能下拉 -->
			<!-- START: 只显示在移动端 -->
			<div class="dropdown mg-l-auto hidden-md-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
				<div class="dropdown-menu dropdown-menu-right pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="javascript:addDocument();" class="nav-link">新建</a>
						<%if(canApprove){%>
						<a href="javascript:approve();" class="nav-link">发布</a>
						<a href="javascript:Preview();" class="nav-link">预览</a>
						<%}else{%>
						<a href="javascript:Preview();" class="nav-link">预览</a>
						<%}%>
						<a href="javascript:editDocument1();" class="nav-link">编辑</a>
						<a href="javascript:deleteFile2();" class="nav-link">撤稿</a>
						<a href="javascript:uploadImages();" class="nav-link">批量上传</a>
						<%if(!channel.getRecommendOut().equals("")){%>
						<a href="javascript:recommendOut()" class="nav-link">推荐</a>
						<%}%>
						<%if(!channel.getAttribute1().equals("")){%>
						<a href="javascript:recommendIn();" class="nav-link">引用</a>
						<%}%>
						<%if(IsWeight!=1){%>
						<a href="javascript:SortDoc();" class="nav-link">排序</a>
						<%}%>
						
						<%if(canDelete){%>
						<a href="javascript:deleteFile();" class="nav-link">删除</a>
						<%}%>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端 -->
			<!-- btn-group -->
			<!--<div class="btn-group mg-l-10 hidden-sm-down">-->
			<div class="btn-group mg-l-10">
				<%if(currPage>1){%>
				<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
				<%}%>
				<%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
				<%}%>
			</div>
			<!-- btn-group -->
		</div>
		<!--操作-->

     <%}else{%>
		<script>
			var page = {
				id: '<%=id%>',
				currPage: '<%=currPage%>',
				rowsPerPage: '<%=rowsPerPage%>',
				querystring: '<%=querystring%>',
				TotalPageNumber: 0
			};
		</script>
     <%}%>


<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script type="text/javascript" src="../common/2018/jquery.contextmenu.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script>
	//==========================================
	//设置高亮
	var Status1_ = <%=Status1%>;
	var IsDelete_ = <%=IsDelete%>;
	$(function() {

		if (Status1_ == -1) {

			$(".list_draft").addClass("active");

		} else if (Status1_ == 1) {

			$(".list_publish").addClass("active");

		} else if (IsDelete_ == 1) {

			$(".list_delete").addClass("active");

		} else {
			$(".list_all").addClass("active");
		}
	});



	//===========================================
	$(function() {
		'use strict';

		//show only the icons and hide left menu label by default
		$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

		$(document).on('mouseover', function(e) {
			e.stopPropagation();
			if ($('body').hasClass('collapsed-menu')) {
				var targ = $(e.target).closest('.br-sideleft').length;
				if (targ) {
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

		$('#showMailBoxLeft').on('click', function(e) {
			e.preventDefault();
			if ($('body').hasClass('show-mb-left')) {
				$('body').removeClass('show-mb-left');
				$(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
			} else {
				$('body').addClass('show-mb-left');
				$(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
			}
		});


		$("#content-table tr:gt(0) td").click(function() {
			var _tr = $(this).parent("tr")
			if(!$("#content-table").hasClass("table-fixed")){
				if( _tr.find(":checkbox").prop("checked") ){
					_tr.find(":checkbox").removeAttr("checked");
					$(this).parent("tr").removeClass("bg-gray-100");
				}else{
					_tr.find(":checkbox").prop("checked", true);
					$(this).parent("tr").addClass("bg-gray-100");
				}
			}
		});

		$("#checkAll,#checkAll_1").click(function() {
			if($("#content-table").hasClass("table-fixed")){
	    		var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
	    	}else{
	    		var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
	    	}	
			var existChecked = false;
			for (var i = 0; i < checkboxAll.length; i++) {
				if (!checkboxAll.eq(i).prop("checked")) {
					existChecked = true;
				}
			}
			if (existChecked) {
				checkboxAll.prop("checked", true);
				checkboxAll.parents("tr").addClass("bg-gray-100");
				$(this).prop("checked", true);
			} else {
				checkboxAll.removeAttr("checked");
				checkboxAll.parents("tr").removeClass("bg-gray-100");
				$(this).prop("checked", false);
			}
			return;
		})
		$(".btn-search").click(function() {
			$(".search-box").toggle(100);
		})
        //表头排序
        $("#content-table").tablesorter({headers: { 0: { sorter: false}}});
		// Datepicker
		tidecms.setDatePicker(".fc-datepicker");

	});

	$(function(){    		
		$('tbody').on('mousedown','tr td',function(e){ 

/*			if($("#content-table").hasClass("table-fixed")){
	    		var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
	    	}else{
	    		var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
	    	}
			checkboxAll.removeAttr("checked");
			$(this).parent("tr").find("td").find(":checkbox").prop("checked", true);
			$("tbody tr").removeClass("bg-gray-100");
			$(this).parent("tr").addClass("bg-gray-100") ;  	
*/			
		})
		var beforeShowFunc = function() {
			//console.log( getActiveNav() )
		};
		var menu = [
		<%if(canApprove){%>
			{'<i class="fa fa-search mg-r-5"></i>发布':function(menuItem,menu) {approve();} },
		<%}%>
			{'<i class="fa fa fa-eye mg-r-5"></i>预览':function(menuItem,menu) {Preview(); }},
			{'<i class="fa fa-edit mg-r-5 fa"></i>编辑':function(menuItem,menu) {editDocument1(); }},
			{'<i class="fa fa-arrow-down mg-r-5 fa"></i>撤稿':function(menuItem,menu) {deleteFile2(); }},
		<%if(!channel.getRecommendOut().equals("")){%>
			{'<i class="fa fa-share mg-r-5 fa"></i>推荐':function(menuItem,menu) {recommendOut();}},
		<%}%>
		<%if(!channel.getAttribute1().equals("")){%>
			{'<i class="fa fa-reply mg-r-5 fa"></i>引用':function(menuItem,menu) {recommendIn();}},
		<%}%>
		    {'<i class="fa fa-clone mg-r-5 fa"></i>复制':function(menuItem,menu) {copy(0)}}, 
			{'<i class="fa fa-arrows mg-r-5 fa"></i>移动':function(menuItem,menu) {copy(1)}},
		<%if(IsWeight!=1){%>
			{'<i class="fa fa-sort-alpha-desc mg-r-5 fa"></i>排序':function(menuItem,menu) {SortDoc(); }},
		<%}%>
		 // {'<img src="../images/inner_menu_cache.gif" title="刷新Cache"/>刷新Cache':function(menuItem,menu) {RefreshItem(); }}
		 <%if(canDelete){%>
			{'<i class="fa fa-trash mg-r-5"></i><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile();}}
		<%}%>
		];
		$('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});	
	})

       //预览事件
    function Preview() {
        var obj = getCheckbox();
        if (obj.length == 0) {
            TideAlert("提示", "请先选择要预览的文件！");
        } else if (obj.length >1){
            TideAlert("提示", "请选择一个预览的文件！");
        } else{
            //使用attr获取属性值
            var DataUrl = $("#item_"+obj.id).attr("data-url");
            window.open(DataUrl);
		}
    }
    function Preview2(DataUrl) {
        window.open(DataUrl);
    }
    function Preview3(DataUrl) {
        window.open(DataUrl);
    }


</script>

    </div>
    <%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
    <!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>

</html>
