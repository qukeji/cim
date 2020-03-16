<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
* 用途：文档列表页
* 1,李永海 20140101 创建
* 2,王海龙 20150408  修改	 定制列表页无需再删除重定向代码
* 3,王海龙 20150609 修改     261行使用user数据源，解决按用户搜索bug
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
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage = 20;

if(rows==0)
	rows = Util.parseInt(Util.getCookieValue("rows_new",request.getCookies()));
if(cols==0)
	cols = Util.parseInt(Util.getCookieValue("cols_new",request.getCookies()));

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
String ChannelName = channel.getName();
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();
String gids = "";
 

if(channel.getListProgram().length()>0 && uri.endsWith("/content/content2018.jsp"))
{response.sendRedirect(channel.getListProgram()+"?id="+id);return;}

int ApproveScheme = channel.getApproveScheme();
if(ApproveScheme!=0){
	response.sendRedirect("../approve/content_approve.jsp?id="+id);
	return ;
}

String S_Title				=	getParameter(request,"Title");
String S_startDate			=	getParameter(request,"startDate");
String S_endDate			=	getParameter(request,"endDate");
String S_User				=	getParameter(request,"User");
int S_IsIncludeSubChannel	=	getIntParameter(request,"IsIncludeSubChannel");
int S_Status				=	getIntParameter(request,"Status");
int S_IsPhotoNews			=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch			=	getIntParameter(request,"OpenSearch");
int IsDelete				=	getIntParameter(request,"IsDelete");
int docType				=	getIntParameter(request,"doc_type");

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
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&startDate="+S_startDate+"&endDate="+S_endDate+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1+"&doc_type="+docType;

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
boolean createCategory = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CreateCategory);
int canExcel=channel.getIsExportExcel();//是否导出Excel
int canWord=channel.getIsImportWord();//是否导出world
String SiteAddress = channel.getSite().getUrl();


//获取频道路径
String parentChannelPath = channel.getParentChannelPath().replaceAll(">"," / ");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
<meta name="renderer" content="webkit">
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
	.list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;position: relative;}
	/*.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}*/
	.list-pic-box .list-img-contanier{width: 100%;position: absolute;left: 0;top: 0;height: 100%;display: flex;justify-content: center;align-items: center;}
    .list-pic-box .list-img-contanier img{width: auto;max-height: 100%;max-width: 100%;}
    
    /*帖子列表页相关*/
    .media-box{display: flex;flex-wrap: nowrap;min-height: 57px;padding: 3px 0;}
    .media-box .td-img-box:nth-child(n+4){display: none;}
    .td-img-box,.td-video-box{width: 60px;height: 60px;display: flex;justify-content: center;align-items: center;margin-right: 10px;cursor: pointer;}
    .td-img-box{border-radius: 5px;overflow: hidden;}
    .td-video-box{width: 100px;border-radius: 5px;background: rgba(0,0,0,0.3);position: relative;overflow: hidden;height: 57px;}
    .td-img-box img{max-width: 100%;border-radius: 5px;}
    .td-video-box video,.td-video-box img{max-width: 100%;border-radius: 5px;}
    .td-video-box:after{ content: ""; width: 100%; height: 100%; background-image:url(../static/img/video_play.png) ; background-size: 20px 20px; background-position: 40px 20px; background-repeat: no-repeat; position: absolute; background-color: rgba(0,0,0,0.3); border-radius: 5px; }
    .imgmore{position: relative; }
    .imgmore:after{ position: absolute; content: "显示更多"; background: rgba(0,0,0,0.3); width: 100%; height: 100%; font-size: 12px; line-height: 60px; text-align: center; color: #fff; }
    .td-title{ overflow : hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; line-height: 1.5;cursor: pointer; }
	
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
	var ChannelName = "<%=ChannelName%>";
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
	function recommendOut1(id)
{
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(400);
		dialog.setUrl("../recommend/out_index.jsp?ChannelID="+ChannelID+"&ItemID="+id);
		dialog.setTitle('推荐');
		dialog.setChannelName(ChannelName);
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

String ListSql = "select id,Title,Photo,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews,txtContent,userid,doc_type,videourl,model,PublishDate";

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
if(docType!=0)
{
	if(docType==-1)
		WhereSql += " and doc_type=0";
	else
		WhereSql += " and doc_type=" + docType;
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
				<a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">待审核</a>
				<a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">审核通过</a>
				<a href="javascript:list('doc_type=-1');" class="btn btn-outline-info list_photo">图文</a>
				<a href="javascript:list('doc_type=1');" class="btn btn-outline-info list_video">视频</a>
				<a href="#" class="btn btn-outline-info btn-search">搜索</a>
			</div>
			<!-- btn-group -->

			<div class="btn-group mg-l-auto hidden-sm-down">
				<a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
				<a href="javascript:approve();" class="btn btn-outline-info">通过</a>
				<a href="javascript:Preview_();" class="btn btn-outline-info">预览</a>
				<a href="javascript:deleteFile2();" class="btn btn-outline-info">不通过</a>
				
			</div>
				
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
							<th class="wd-5p wd-50"><span class="pd-l-5"></span>选择</th>
							<th class="tx-12-force tx-mont tx-medium">内容</th>
							<th class="tx-12-force tx-mont tx-medium wd-150">用户</th>
							<th class="tx-12-force tx-mont tx-medium wd-60">板块</th>
							<th class="tx-12-force tx-mont tx-medium wd-80">审核</th>
							<th class="tx-12-force tx-mont tx-medium wd-120">发布日期</th>
							<th class="tx-12-force wd-100 tx-mont tx-medium wd-100">操作</th>
							<th class="tx-12-force tx-mont tx-medium wd-180">资源信息</th>
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

	int GlobalID=Rs.getInt("GlobalID");
	int Status = Rs.getInt("Status");
	int category = Rs.getInt("Category");
	int userid = Rs.getInt("userid");
	int model = Rs.getInt("model");
	int doc_type = Rs.getInt("doc_type");
	Document doc_model = CmsCache.getDocument(model);
	String modelName =doc_model.getTitle();
	Document doc = CmsCache.getDocument(userid,CmsCache.getChannel("register").getId());
	String userName = doc.getTitle();
	ArrayList list = new ArrayList();
	if(doc_type==0){
		TableUtil tu1 = new TableUtil();
		String sql = "select * from "+CmsCache.getChannel("photo").getTableName()+" where Parent="+GlobalID+" and active=1 and status=1";
		ResultSet rs = tu1.executeQuery(sql);
		while(rs.next()){
			String photoUrl = tu1.convertNull(rs.getString("Photo"));
			list.add(photoUrl);
		}
		tu1.closeRs(rs);
	}


	int active = Rs.getInt("Active");
	String Title	= convertNull(Rs.getString("Title"));
	String txtContent	= convertNull(Rs.getString("txtContent"));
	String videourl	= convertNull(Rs.getString("videourl"));
	String Photo	= convertNull(Rs.getString("Photo"));
	String photoAddr = "";
	if(Photo.startsWith("http")||Photo.startsWith("https"))
		photoAddr = Photo;
	else
		photoAddr = SiteAddress + Photo;
	int IsPhotoNews = Rs.getInt("IsPhotoNews");

	if(listAll)
	{
		if(category>0) {
			Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
		}
	}


	if(temp_gid!=0){
		globalids+=",";
	}
	temp_gid++;
	globalids+=GlobalID+"";


	String ModifiedDate	= convertNull(Rs.getString("PublishDate"));
	ModifiedDate=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(Long.parseLong(ModifiedDate+"000") ));
	String StatusDesc = "";
	if(IsDelete!=1){
	if(Status==0)
		StatusDesc = "<span class='tx-orange'>未审核</span>";
	else if(Status==1)
		StatusDesc = "<span class='tx-success'>通过</span>";
	}else{
		StatusDesc = "<span class='tx-danger'>已删除</span>";
	}

	if(gids.length()>0){gids+=","+GlobalID+"";}else{gids=GlobalID+"";}

	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;

	if(listType==1)
	{
%>
		<tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>" status="<%=Status%>" GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item">
            <td class="valign-middle">
              <label class="ckbox mg-b-0 mg-l-5">
				<input type="checkbox" name="id" value="<%=id_%>"><span></span>
			  </label>
            </td>
            <td ondragstart="OnDragStart(event)">
              <span class="pd-l-5 tx-black td-title"><%=txtContent%></span>
            </td>
			<td><%=userName%></td>
			<td>
				<%=modelName%>
			</td>
			<td>
				<%=StatusDesc%>
			</td>
			<td>
				<%=ModifiedDate%>
			</td>
			<td class="dropdown">
				<%if(Status==0){%>
					<a href="javascript:approve2(<%=id_%>);;" class="btn pd-0 mg-r-3" title="通过"><i class="fa  fa-check-square-o tx-18 handle-icon" aria-hidden="true"></i></a>
				<%}%>
				<a href="javascript:Preview3_(<%=id_%>);" class="btn pd-0 mg-r-3" title="预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
				<a href="javascript:deleteFile1(<%=id_%>);" class="btn pd-0 mg-r-3" title="删除"><i class="fa fa-trash-o tx-18 handle-icon" aria-hidden="true"></i></a>
				<!-- dropdown-menu -->
			</td>
			<td>
				<div class="media-box">
					<%if(doc_type==0){
						for(int i=0;i<list.size();i++){%>
							<div class="td-img-box">
								<img src="<%=list.get(i)%>">
							</div>
					<%}}else if(doc_type==1){%>
						<div class="td-video-box">
							<img src="<%=photoAddr%>" >
							<input type="hidden" class="vl" name="videourl" value="<%=videourl%>"/>
							<!--<video controls="controls" src="<%=videourl%>"></video>-->
						</div>
					<%}%>
				</div>
			</td>
		</tr>
	<%}
	if(listType==2)
	{



		if(m==0) out.println("<tr>");
		m++;
%>
		<td id="item_<%=id_%>" status="<%=Status%>" class="tide_item" class="c">
			<div class="row">
				<div class="col-md">
				<div class="card bd-0">
					<div class="list-pic-box">
						<div class="list-img-contanier">
							<img class="card-img-top" src="<%=photoAddr%>" alt="Image" onerror="checkLoad(this);" >
						</div>
					</div>
					<div class="card-body bd-t-0 rounded-bottom">
					  <p class="card-text"><%if(IsPhotoNews==1){%><i class="icon ion-image tx-22 tx-warning lh-0 valign-middle"></i><%}%><%=Title%>(<%=StatusDesc%>)</p>
					  <div class="row mg-l-0 mg-r-0 mg-t-5">				                  					                  
						  <label class="ckbox mg-b-0 d-inline-block mg-r-5">
							<input name="id" value="<%=id_%>" type="checkbox"><span></span>
						  </label>
						  <%if(active==1 && canApprove){%>
						  <a href="javascript:approve2(<%=id_%>);" class="btn pd-0 mg-r-5" title="发布"><i class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>
						  <%}%>
						  <%if(active==0 && canDelete){%>
						  <a href="javascript:resume(<%=id_%>);" class="btn pd-0 mg-r-5" title="恢复"><i class="fa fa-reply tx-18 handle-icon" aria-hidden="true"></i></a>
						  <%}else{%>
						  <a href="javascript:Preview2_(<%=id_%>);" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
						  <a href="javascript:Preview3_(<%=id_%>);" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
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
				<a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">待审核</a>
				<a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">审核通过</a>
				<a href="javascript:list('doc_type=-1');" class="btn btn-outline-info list_photo">图文</a>
				<a href="javascript:list('doc_type=1');" class="btn btn-outline-info list_video">视频</a>
				<a href="#" class="btn btn-outline-info btn-search">搜索</a>
			</div>
			<!-- btn-group -->

			<div class="btn-group mg-l-auto hidden-sm-down">
				<a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
				<a href="javascript:approve();" class="btn btn-outline-info">通过</a>
				<a href="javascript:Preview_();" class="btn btn-outline-info">预览</a>
				<a href="javascript:deleteFile2();" class="btn btn-outline-info">不通过</a>
			</div>
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
			<div class="program-time pd-x-20 pd-sm-x-30 pd-t-0 mg-b-20 wd-300">
      	        <span style="color: transparent;" class="ht-40 d-block" onclick="this.style.color='#333'" onmouseout="this.style.color='transparent'">执行时间：<%=(System.currentTimeMillis()-begin_time)%>毫秒</span>
            </div>

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
	var docType_ = <%=docType%>;
	$(function() {

		if (Status1_ == -1) {

			$(".list_draft").addClass("active");

		} else if (Status1_ == 1) {

			$(".list_publish").addClass("active");

		} else if (IsDelete_ == 1) {

			$(".list_delete").addClass("active");

		} else if (docType_ == -1) {

			$(".list_photo").addClass("active");

		} else if (docType_ == 1) {

			$(".list_video").addClass("active");

		} else {
			$(".list_all").addClass("active");
		}
	});



	//===========================================
	function checkAllCheckbox(){
    	var _checkboxAll = $("#content-table tr:gt(0)").find("td:first-child").find("input[type='checkbox']") ;
    	var _all =  false ;
    	for (var i=0;i<_checkboxAll.length;i++) {
    		if(!_checkboxAll.eq(i).prop("checked")){
    			_all = true ;
    		}
    	}
    	if(_all){
    		$("#checkAll,#checkAll_1").removeAttr("checked");
    	}
    	return;
    }
	;$(function() {
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


		$("#content-table tr:gt(0)").click(function() {
			if(!$("#content-table").hasClass("table-fixed")){
				if ($(this).find("input[type='checkbox']").prop("checked")){  		        	        	  
		            $(this).find(":checkbox").prop("checked", false);
		            $(this).removeClass("bg-gray-100");	            
		        }else{  
		           
		            $(this).find("input[type='checkbox']").prop("checked", true);
		            $(this).addClass("bg-gray-100");
		        } 
		        checkAllCheckbox()	  
			} 
		});
		//适配列表页平铺下的单个选中
		$("#content-table tr td").click(function() {
			if($("#content-table").hasClass("table-fixed")){
				if ($(this).find("input[type='checkbox']").prop("checked")){  		        	        	  
		            $(this).find(":checkbox").prop("checked", false);
		            $(this).removeClass("bg-gray-100");	            
		        }else{  
		            $(this).find("input[type='checkbox']").prop("checked", true);
		            $(this).addClass("bg-gray-100");
		        } 
		        //checkAllCheckbox()	  
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
		
		<%if(S_OpenSearch!=1){%>
			sortable();
			sortableEnable();
			//sortableDisable();
			<%if(sortable==1){%>
				//sortableEnable();
			<%}%>
		<%}%>
		
		var beforeShowFunc = function() {
			//console.log( getActiveNav() )
			checkAllCheckbox();
		};
		var menu = [
			{'<i class="fa fa-search mg-r-5"></i>通过':function(menuItem,menu) {approve();} },
			{'<i class="fa fa fa-eye mg-r-5"></i>预览':function(menuItem,menu) {Preview_(); }},
			{'<i class="fa fa-edit mg-r-5 fa"></i>编辑':function(menuItem,menu) {editDocument1(); }},
			{'<i class="fa fa-arrow-down mg-r-5 fa"></i>不通过':function(menuItem,menu) {deleteFile2(); }},
		];
		$('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});	
	})
</script>

    </div>
    <%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
    <!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
    <script>
    	
    	;$(function(){
	    	var td = $("tbody tr td:last-child") ;
	    	$.each( td ,function( vi , va ){
	    		//console.log(td)
	    		var imgBox = $(va).find(".td-img-box") ;
	    		if(imgBox.length > 3 ){
	    			imgBox.eq(2).addClass("imgmore") ;
	    		}
	    	})
	    	
	    })
    	//内容的
    	$(".td-title").click(function(){
    		var textcont = $(this).text();
    		if( ! $.trim(textcont)){
    			return false;
    		}
    		var id = $(this).parent().parent().attr("ItemID");
    		var	dialog = new top.TideDialog();
			dialog.setWidth(800);
			dialog.setHeight(600);
			dialog.setUrl("../jushi/content_post_preview.jsp?sourceType=1&id="+id+"&ChannelID="+ChannelID);
			dialog.setTitle('内容预览');
			dialog.show(); 
    		return false ;
    	});
    	
    	//图片的
    	$("table").delegate(".td-img-box","click",function(){
    		var imgArr = $(this).parent().find("img") ;
    		var imgUrl = "" ;
    		$.each(imgArr, function(i,va) {
    			if( i == 0 ){
    				imgUrl += $(va).attr("src") ;
    			}else{
    				imgUrl += "," +$(va).attr("src") ;
    			}
    		});
    		console.log(imgUrl)
    		var	dialog = new top.TideDialog();
			dialog.setWidth(1000);
			dialog.setHeight(650);
			dialog.setUrl("../jushi/content_post_preview.jsp?sourceType=2&imgUrl="+imgUrl);
			dialog.setTitle('图片预览');
			dialog.show(); 
			return false ;
    	})
    	//视频的
    	$(".td-video-box").click(function(){
    		var	dialog = new top.TideDialog();
    		var videoUrl = $(this).find("input[name='videourl']").val() ;
    		if( ! $.trim(videoUrl)){
    			dialog.showAlert("无有效视频地址！","danger")
    			return false ;
    		}
			dialog.setWidth(1000);
			dialog.setHeight(650);
			dialog.setUrl("../jushi/content_post_preview.jsp?sourceType=3&videoUrl="+videoUrl);
			dialog.setTitle('视频预览');
			dialog.show(); 
    		return false ;
    	});
    	
    </script>
    
</body>

</html>
