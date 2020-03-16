<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
* 用途：文档列表页
* 1,李永海 20140101 创建
* 2,王海龙 20150408  修改	 定制列表页无需再删除重定向代码
* 3,王海龙 20150609 修改     261行使用user数据源，解决按用户搜索bug
* 4,
* 5,
*/
String uri = request.getRequestURI();
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
boolean IsTopStatus=false;//是否置顶
if(channel.getIsTop()==1){
	IsTopStatus=true;
}
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
 

if(channel.getListProgram().length()>0 && uri.endsWith("/content/content.jsp"))
{response.sendRedirect(channel.getListProgram()+"?id="+id);return;}

String S_Title				=	getParameter(request,"Title");
String S_CreateDate			=	getParameter(request,"CreateDate");
String S_CreateDate1		=	getParameter(request,"CreateDate1");
String S_User				=	getParameter(request,"User");
int S_IsIncludeSubChannel	=	getIntParameter(request,"IsIncludeSubChannel");
int S_Status				=	getIntParameter(request,"Status");
int S_IsPhotoNews			=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch			=	getIntParameter(request,"OpenSearch");
int IsDelete				=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list",request.getCookies()));
if(listType==0) listType = 1;

boolean listAll = false;

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
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;

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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
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
    	.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
      @media (min-width:950px){.hidden-md-up {display: none !important;}}
</style>

<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/2018/content.js"></script>
<!--<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<%if(IsWeight==1){%><script type="text/javascript" src="../common/jquery.jeditable.js"></script><%}%>
<script type="text/javascript" src="../common/ui.draggable.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>-->
<script>
var listType = <%=listType%>;
var rows = <%=rows%>;
var cols = <%=cols%>;
var ChannelID = <%=ChannelID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
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

//右键排序
function SortDoc(){
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
}

</script>
</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
	
	<div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">当前位置：<%=channel.getName()%></span>
        </nav>
    </div><!-- br-pageheader -->

	<%
int S_UserID = 0;
long weightTime = 0;
int IsActive = 1;
if(IsDelete==1) IsActive=0;

if(!S_User.equals("")){
	String sql2="select * from userinfo where Name='"+S_User+"'";
	TableUtil tu2 = new TableUtil("user");
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
String ListSql = "select id,Title,Photo,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews";

String FieldStr=",DocTop,DocTopTime";
if(IsTopStatus){
	ListSql+=FieldStr;
}


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
		ListSql += " where "+ (!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
		CountSql += " where "+(!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
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
if(!S_CreateDate.equals("")){
	long fromTime=Util.getFromTime(S_CreateDate,"");
	if(S_CreateDate1.equals("=")){
		WhereSql += " and CreateDate>="+fromTime;
		WhereSql += " and CreateDate<"+(fromTime+86400);
	}else{
		WhereSql += " and CreateDate" + S_CreateDate1+fromTime;
	}
}

/*
if(S_IsIncludeSubChannel==1)
{
	WhereSql += " and ChannelCode like '"+channel.getChannelCode() + "%'";
}*/

if(S_UserID>0)
{
	WhereSql += " and User="+S_UserID;
}

if(S_IsPhotoNews==1)
	WhereSql += " and IsPhotoNews=1";
if(S_Status!=0)
	WhereSql += " and Status=" + (S_Status-1);

if(Status1!=0)
{
	if(Status1==-1)
		WhereSql += " and Status=0";
	else
		WhereSql += " and Status=" + Status1;
}

ListSql += WhereSql;
CountSql += WhereSql;

if(channel.getIsWeight()==1)
{
	ListSql += " order by newtime desc,id desc";
}
else
{
   if(IsTopStatus){
		ListSql += " order by  DocTop desc ,DocTopTime  desc  ,OrderNumber desc ";
   }else {
	    ListSql += " order by OrderNumber desc ";
   }
}

// out.println(ListSql);

int listnum = rowsPerPage;
if(listType==3) listnum = cols*rows;

TableUtil tu = channel.getTableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();

%>

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
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
        <!-- END: 只显示在移动端 -->

        <div class="btn-group hidden-xs-down">
          <a href="#" class="btn btn-outline-info"><i class="fa fa-th"></i></a>
          <a href="#" class="btn btn-outline-info active"><i class="fa fa-th-list"></i></a>
        </div><!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-xs-down">
          <a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
          <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">草稿</a>
          <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已发</a>
          <a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
          <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div><!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
          <a href="javascript:approve();" class="btn btn-outline-info">发布</a>
          <a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
          <a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
          <a href="javascript:deleteFile2();" class="btn btn-outline-info">撤稿</a>
          <a href="#" class="btn btn-outline-info">推荐</a>
          <a href="javascript:recommendIn();" class="btn btn-outline-info">引用</a>
          <a href="#" class="btn btn-outline-info">排序</a>
          <a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>          
        </div><!-- btn-group -->
        
        <div class="btn-group mg-l-10 hidden-sm-down">
          <%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a><%}%>
          <%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info active"><i class="fa fa-chevron-right"></i></a><%}%>
        </div><!-- btn-group -->

		<!-- START: 只显示在移动端 -->
        <div class="dropdown mg-l-auto hidden-md-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
          <div class="dropdown-menu dropdown-menu-right pd-10">
            <nav class="nav nav-style-1 flex-column">
              <a href="javascript:approve();" class="nav-link">发布</a>
              <a href="javascript:Preview();" class="nav-link">预览</a>
              <a href="javascript:editDocument1();" class="nav-link">编辑</a>
              <a href="javascript:deleteFile2();" class="nav-link">撤稿</a>
              <a href="#" class="nav-link">推荐</a>
              <a href="javascript:recommendIn();" class="nav-link">引用</a>
              <a href="#" class="nav-link">排序</a>
              <a href="javascript:deleteFile();" class="nav-link">删除</a>          
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
        <!-- END: 只显示在移动端 -->

     </div><!-- d-flex -->

	 <!--搜索-->
     <div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
		<div class="search-content bg-white">
			<form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post">
      		<div class="row">
				<!--标题-->
				<div class="mg-r-10 mg-b-30 search-item">
				  <input class="form-control search-title" placeholder="标题" type="text" name="Title" value="<%=S_Title%>"  onClick="this.select()">
				</div>
				<!--日期-->
				<div class="wd-200 mg-b-30 mg-r-10 search-item">
					<div class="input-group">
						<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
						<input type="text" class="form-control fc-datepicker search-time" placeholder="MM/DD/YYYY" name="startDate">
					</div>
				</div>
				<div class="wd-20 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>
				<div class="wd-200 mg-b-30 mg-r-10 search-item">
					<div class="input-group">
						<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
						<input type="text" class="form-control fc-datepicker search-time" placeholder="MM/DD/YYYY" name="endDate">
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
						<option value="0"></option>
						<option value="2" <%=(S_Status==2?"selected":"")%>>已发</option>
						<option value="1" <%=(S_Status==1?"selected":"")%>>草稿</option>
					</select>
				</div>
				<div class="search-item mg-b-30">
					<input type="submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
				</div>
			</div><!-- row -->
			</form>
      	</div>
     </div><!--search-box-->

<%if(channel.hasRight(userinfo_session,1)){%>
	 <div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">
<%if(listType==1){%>
				<thead>
				  <tr>
					<th class="wd-5p">
					  <label class="ckbox mg-b-0">
						<input type="checkbox" id="checkAll"><span></span>
					  </label>
					</th>
					<th class="tx-12-force tx-mont tx-medium">标题</th>
					<%if(IsWeight==1){%>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">权重</th>
					<%}%>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">状态</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">日期</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">作者</th>
					<%if(IsComment==1){%>
    				<th class="tx-12-force tx-mont tx-medium hidden-xs-down">评论</th>
    				<%}%>	
    				<%if(IsClick==1){%>
    				<th class="tx-12-force tx-mont tx-medium hidden-xs-down">点击量</th>
    				<%}%>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">操作</th>
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
	String Title	= convertNull(Rs.getString("Title"));
	int IsPhotoNews = Rs.getInt("IsPhotoNews");
	int TopStatus = 0;
	if(IsTopStatus){
		 TopStatus = Rs.getInt("DocTop");
	}
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
		StatusDesc = "<font color=red>草稿</font>";
	else if(Status==1)
		StatusDesc = "<font color=blue>已发</font>";
	}else{
		StatusDesc = "<font color=blue>已删除</font>";
	}

	if(gids.length()>0){gids+=","+GlobalID+"";}else{gids=GlobalID+"";}

	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;

	if(listType==1)
	{
%>
		<tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  status="<%=Status%>" GlobalID="<%=GlobalID%>" id="item_<%=id_%>">
			<td class="valign-middle">
			  <label class="ckbox mg-b-0">
				<input type="checkbox" name="id" value="<%=id_%>"><span></span>
			  </label>
			</td>
			<td ondragstart="OnDragStart (event)">
			  <%if(IsPhotoNews==1){%><img id="img_<%=j%>" src="../images/icon/170.png" title="图片新闻"><%}else{%><img id="img_<%=j%>" src="../images/icon/172.png"/><%}%>  <%if(TopStatus==0){%><%}else{%><img id="imgtop_<%=j%>" src="../images/doctop_03.png" title="置顶"><%}%>
			  <span class="pd-l-5"><%=Title%></span>
			</td>
		<%if(IsWeight==1){%>
			<td class="hidden-xs-down"><span ItemID="<%=id_%>"><%=Weight%></span></td>
		<%}%>
			<td class="hidden-xs-down"><%=StatusDesc%></td>
			<td class="hidden-xs-down"><%=ModifiedDate%></td>
			<td class="hidden-xs-down"><%=UserName%></td>
		<%if(IsComment==1){%>
			<td class="hidden-xs-down"><span id="comment_<%=GlobalID%>"></span></td>
		<%}%>
		<%if(IsClick==1){%>
			<td class="hidden-xs-down"><span id="click_<%=GlobalID%>"></span></td>
		<%}%>
			<td class="dropdown hidden-xs-down">
			  <a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info"><i class="icon ion-more"></i></a>
			  <div class="dropdown-menu dropdown-menu-right pd-10">
				<nav class="nav nav-style-1 flex-column">
				  <%if(active==1 && canApprove){%><a href="javascript:approve2(<%=id_%>);" class="nav-link">发布</a><%}%>
				  <%if(active==0 && userinfo_session.isAdministrator()){%><a href="javascript:resume(<%=id_%>);" class="nav-link">恢复</a><%}else{%>
				  <a href="javascript:Preview3(<%=id_%>);" class="nav-link">预览</a>
				  <a href="javascript:editDocument(<%=id_%>);" class="nav-link">编辑</a>
				  <a href="javascript:deleteFile2_(<%=id_%>);" class="nav-link">撤稿</a>
				  <a href="" class="nav-link">推荐</a>
				  <a href="" class="nav-link">排序</a>
				  <a href="javascript:deleteFile_(<%=id_%>);" class="nav-link">删除</a><%}%>
				</nav>
			  </div><!-- dropdown-menu -->
			</td>
		</tr>
<%  }
	if(listType==2)
	{
		String Photo	= convertNull(Rs.getString("Photo"));
		String photoAddr = "";
		if(Photo.startsWith("http://"))
			photoAddr = Photo;
		else
			photoAddr = SiteAddress + Photo;
		String Summary = convertNull(Rs.getString("Summary"));
		if(Summary.length()==0)
		{
			String Content = convertNull(Rs.getString("Content"));
			Summary = Util.substring(Util.removeHtml(Content),156);
		}

		String path = "";
		if(category>0)
			path = CmsCache.getChannel(category).getParentChannelPath();
		else
			path = channel.getParentChannelPath();
		String keyword = convertNull(Rs.getString("Keyword"));
%>


<%	} 
}
tu.closeRs(Rs);
%>
				</tbody>
			</table>
		</div>
	 </div><!-- br-pagebody -->

	 <script>
		var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
	 </script>   

	 <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

        <!--<button id="showSubLeft" class="btn btn-secondary mg-r-10 hidden-lg-up"><i class="fa fa-navicon"></i></button>-->

		<!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
          <div class="dropdown-menu pd-10">
            <nav class="nav nav-style-1 flex-column">
              <a href="javascript:list();" class="nav-link list_all">全部</a>
              <a href="javascript:list('Status1=-1');"" class="nav-link list_draft">草稿</a>
              <a href="javascript:list('Status1=1');" class="nav-link list_publish">已发</a>
              <a href="javascript:list('IsDelete=1');" class="nav-link list_delete">已删除</a>
              <a href="#" class="nav-link">搜索</a>
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
        <!-- END: 只显示在移动端 -->

        <div class="btn-group hidden-xs-down">
          <a href="#" class="btn btn-outline-info"><i class="fa fa-th"></i></a>
          <a href="#" class="btn btn-outline-info active"><i class="fa fa-th-list"></i></a>
        </div><!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-xs-down">
          <a href="javascript:list();" class="btn btn-outline-info">全部</a>
          <a href="javascript:list('Status1=-1');"" class="btn btn-outline-info">草稿</a>
          <a href="javascript:list('Status1=1');" class="btn btn-outline-info">已发</a>
          <a href="javascript:list('IsDelete=1');" class="btn btn-outline-info">已删除</a>
          <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div><!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
          <a href="javascript:approve();" class="btn btn-outline-info">发布</a>
          <a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
          <a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
          <a href="javascript:deleteFile2();" class="btn btn-outline-info">撤稿</a>
          <a href="#" class="btn btn-outline-info">推荐</a>
          <a href="javascript:recommendIn();" class="btn btn-outline-info">引用</a>
          <a href="#" class="btn btn-outline-info">排序</a>
          <a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>         
        </div><!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-sm-down">
          <a href="#" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
          <a href="#" class="btn btn-outline-info active"><i class="fa fa-chevron-right"></i></a>
        </div><!-- btn-group -->

		<!-- START: 只显示在移动端 -->
        <div class="dropdown mg-l-auto hidden-md-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
          <div class="dropdown-menu dropdown-menu-right pd-10">
            <nav class="nav nav-style-1 flex-column">
              <a href="javascript:approve();" class="nav-link">发布</a>
              <a href="javascript:Preview();" class="nav-link">预览</a>
              <a href="javascript:editDocument1();" class="nav-link">编辑</a>
              <a href="javascript:deleteFile2();" class="nav-link">撤稿</a>
              <a href="#" class="nav-link">推荐</a>
              <a href="javascript:recommendIn();" class="nav-link">引用</a>
              <a href="#" class="nav-link">排序</a>
              <a href="javascript:deleteFile();" class="nav-link">删除</a>         
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
        <!-- END: 只显示在移动端 -->

    </div><!-- d-flex -->
<%}else{%>
	<script>
		var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:0};
	</script> 
<%}%>

	<script src="../lib/2018/jquery/jquery.js"></script>
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
//			console.log($(this).find(":checkbox").prop("checked"))    
			if ($(this).find(":checkbox").prop("checked"))// 此处要用prop不能用attr，至于为什么你测试一下就知道了。    
			{    
				$(this).find(":checkbox").removeAttr("checked");    
				// $(this).find(":checkbox").attr("checked", 'false');     
			}else{    
				$(this).find(":checkbox").prop("checked", true);    
			}     
		}); 
		$(".all-table-tr,#checkAll").click(function(){
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
          selectOtherMonths: true
        });
  
      });
    </script>
</div>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
