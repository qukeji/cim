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
//社区管理->图片 列表页 2015.3.9
String domainname = CmsCache.getParameterValue("sns_domainname_address");
String tableprefix = CmsCache.getParameterValue("sns_tableprefix");
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
int userid=userinfo_session.getId();
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
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();
String gids = "";

int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list",request.getCookies()));
if(listType==0) listType = 2;

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
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

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
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<!-- <script type="text/javascript" src="../common/2018/common2018.js"></script> -->
<script type="text/javascript" src="../common/2018/content.js"></script>
<script type="text/javascript" src="../lib/2018/popper.js/popper.js"></script>
<script type="text/javascript"src="../lib/2018/bootstrap/bootstrap.js"></script>
<script type="text/javascript"src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script type="text/javascript"src="../lib/2018/moment/moment.js"></script>
<script type="text/javascript"src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script type="text/javascript"src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script type="text/javascript"src="../lib/2018/peity/jquery.peity.js"></script>
<script type="text/javascript"src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script type="text/javascript"src="../lib/2018/select2/js/select2.min.js"></script>
<script type="text/javascript" src="../common/2018/bracket.js"></script>
<!-- <script type="text/javascript" src="../common/2018/jquery.contextmenu.js"></script>  -->
<script>
var listType = 1;
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

function Preview22(id)
{
	tidecms.dialog("content/video_player3.jsp?id="+id,640,510,"视频预览");
}
function getCheckbox(){
var id="";
jQuery("#oTable input:checked").each(function(i){
if(i==0)
id+=jQuery(this).val();
else
id+=","+jQuery(this).val();
});
var obj={length:jQuery("#oTable input:checked").length,id:id};
return obj;
} 
function deleteFile(){
	var obj=getCheckbox();
	var message = "确实要删除这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要删除的文件！");
	}else{
		 if(confirm(message)){
			 var url="sns_operate_action.jsp?id=" + obj.id+"&action=1&table=uchome_pic&c_id=picid";
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
	var message = "确实要撤稿这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要撤稿的文档！");
	}else{
		 if(confirm(message)){
			 var url="sns_operate_action.jsp?id=" + obj.id+"&action=3&table=uchome_pic&c_id=picid";
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
	 var url= "sns_operate_action.jsp?id=" + id + "&action=2&table=uchome_pic&c_id=picid";
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.href=document.location.href;}   
		}); 
}
function Preview22(filepath){
	window.open("<%=domainname%>attachment/"+filepath);
}

function Preview()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要预览的文件！");
		}else if(obj.length>1){
		alert("请选择一个要预览的文件！");
		}else{
		var filepath = $("#item_" + obj.id).attr("filepath");
		Preview22(filepath);
		}
} 

function recommendOut()
{
	var id="";
	var approved = true;
	var fromchannelid=0;
	$("#oTable input:checked").each(function(i){
		if(i==0)
			id+=$(this).val();
		else
			id+=","+$(this).val();
		
		//var status=$("#item_"+$(this).val()).attr("status");
		//fromchannelid=$("#item_"+$(this).val()).attr("channelid");
		
		//if(status!="1") approved = false;
	});

	var obj=getCheckbox();
	if(id==""){
		alert("请选择要被推荐的文档！");
		return;
	}

	/*if(!approved){
		alert("请选择发布后的文档!");
		return;
	}
	*/
	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(450);
	dialog.setUrl("sns/sns_recommend_out_index.jsp?ChannelID="+13959+"&ids="+id+"&sns_tablename=<%=tableprefix%>_pic&userid="+<%=userid%>);
	dialog.setTitle("推荐");
	dialog.show();	
}
function double_click()
{
	jQuery("#oTable .tide_item").dblclick(function(){
		var obj=jQuery(":checkbox",jQuery(this));
		var filepath = $(this).attr("filepath");
		obj.trigger("click");
		window.open("<%=domainname%>attachment/"+filepath);
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
		</div>
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

String Table = channel.getTableName();
String ListSql = "select FROM_UNIXTIME(dateline) as dateline,picid,username,uid,filepath,filename,title,status,size from "+tableprefix+"_pic";

String CountSql = "select count(*) from "+tableprefix+"_pic";

String WhereSql = " where 1=1 ";

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and title like '%" + channel.SQLQuote(tempTitle) + "%'";
}

if(S_IsPhotoNews==1)
	WhereSql += " and IsPhotoNews=1";
if(S_Status!=0)
	WhereSql += " and status=" + (S_Status-1);

if(Status1!=0)
{
	if(Status1==-1)
		WhereSql += " and Status=0";
	else
		WhereSql += " and Status=" + Status1;
}

ListSql += WhereSql;
CountSql += WhereSql;


ListSql += " order by dateline desc";

int listnum = rowsPerPage;
if(listType==2) listnum = cols*rows;

TableUtil tu = new TableUtil("sns");
ResultSet Rs = null;
try{
Rs = tu.List(ListSql,CountSql,currPage,listnum);

int TotalPageNumber = tu.pagecontrol.getMaxPages();
%>	
		<!-- br-pageheader -->
		<!--操作-->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

		<!-- START: 只显示在移动端 -->			
		<div class="dropdown hidden-sm-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
          <div class="dropdown-menu pd-10">
            <nav class="nav nav-style-1 flex-column">
              <a href="javascript:list();" class="btn btn-outline-info list_all" >全部</a>
		      <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft" >未审核</a>
		      <a href="javascript:list('Status1=1');" class="btn btn-outline-info  list_publish" >已审核</a>		  
              <a href="#" class="btn btn-outline-info btn-search">检索</a>
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
		<!-- END: 只显示在移动端-->
		<!-- START: 只显示在移动端 -->		
        <div class="dropdown mg-l-auto hidden-md-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
          <div class="dropdown-menu dropdown-menu-right pd-10">
            <nav class="nav nav-style-1 flex-column">
				<a href="#" class="btn btn-outline-info list_all" onClick="addDocument();" >新建</a>
            <a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
            <a href="javascript:recommendOut();" class="btn btn-outline-info">推荐</a> 					
			<a href="javascript:approve();" class="btn btn-outline-info">审核</a>
			<a href="javascript:deleteFile2();" class="btn btn-outline-info">撤销审核</a>
			<a href="javascript:javascript:deleteFile();" class="btn btn-outline-danger">删除</a>  
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->		
		<!-- END: 只显示在移动端-->
			<div class="btn-group hidden-xs-down">
				<a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i class="fa fa-th"></i></a>
				<a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i class="fa fa-th-list"></i></a>
			</div>
        <div class="btn-group mg-l-10 hidden-xs-down">          
          <a href="javascript:list();" class="btn btn-outline-info list_all" >全部</a>
		  <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft" >未审核</a>
		  <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish" >已审核</a>		  
          <a href="#" class="btn btn-outline-info btn-search">检索</a>
	    </div>			
				<!-- btn-group -->
		<div class="btn-group mg-l-auto hidden-sm-down">
		    <a href="#" class="btn btn-outline-info list_all" onClick="addDocument();" >新建</a>
            <a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
            <a href="javascript:recommendOut();" class="btn btn-outline-info">推荐</a> 					
			<a href="javascript:approve();" class="btn btn-outline-info">审核</a>
			<a href="javascript:deleteFile2();" class="btn btn-outline-info">撤销审核</a>
			<a href="javascript:javascript:deleteFile();" class="btn btn-outline-danger">删除</a>  
        </div><!-- btn-group -->
			<div class="btn-group mg-l-10 hidden-sm-down">
			<%if(currPage>1){%>
				<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
			<%}%>
			<%if(currPage<TotalPageNumber){%>
				<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
			<%}%>
			</div>
			<!-- btn-group -->
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
		</div>
		<!--操作-->
      <!--搜索-->
		<div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
		<div class="search-content bg-white">
			<form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">
      		<div class="row">
				<!--标题-->
				<div class="mg-r-10 mg-b-30 search-item">
				  <input class="form-control search-title" size="18"  placeholder="标题" type="text" name="Title" value="<%=S_Title%>">
				</div>	
				<div class="search-item mg-b-30">
					<input type="submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
					<input type="hidden" name="OpenSearch" id="OpenSearch" value="0">
				</div>
			</div><!-- row -->
			</form>
      	</div>
     </div> 
	 <!--搜索-->		
<%if(channel.hasRight(userinfo_session,1)){%>
		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0 <%=listType==2?"viewpane_pic_list":"viewpane_tbdoy"%>" id="content-table">
				<%if(listType==1){%>
					<thead>
						  <tr>
					<th class="wd-5p">
					  <label class="ckbox mg-b-0">
						<input type="checkbox" id="checkAll"><span></span>
					  </label>
					</th>
					<th class="tx-12-force tx-mont tx-medium">标题</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">状态</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">文件名</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">创建日期</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">作者</th>
					<th class="tx-12-force wd-150 tx-mont tx-medium hidden-xs-down">操作</th>
				  </tr>
					</thead>
                  <%}%>
					<tbody>
<%
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;
int m = 0;

while(Rs!=null && Rs.next())
{
	int id_ = Rs.getInt("picid");
 
	int uid = Rs.getInt("uid");
	TableUtil tu2 = new TableUtil("sns");
	String sql2 = "select username from "+tableprefix+"_usermagic where uid="+uid;
	ResultSet rs2 = tu2.executeQuery(sql2);
	tu2.closeRs(rs2);
	String dateline	= convertNull(Rs.getString("dateline"));
	dateline=Util.FormatDate("yyyy-MM-dd HH:mm:ss",dateline);
	String title = Rs.getString("title");
	int Status = Rs.getInt("status");
	int size = Rs.getInt("size")/1024;
	String username	= convertNull(Rs.getString("username"));
	String filepath = Rs.getString("filepath");
	String filename	= convertNull(Rs.getString("filename"));
	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;
	String StatusDesc = "";
	if(IsDelete!=1){
		if(Status==0)
			StatusDesc = "<font color=red>未审核</font>";
		else if(Status==1)
			StatusDesc = "<font color=blue>已审核</font>";
	}else{
		StatusDesc = "<font color=blue>已删除</font>";
	}
//http://tv.sxrtv.com:81/sns/space.php?uid=1&do=podcast&picid=154
	if(listType==1)
	{
%>
		<tr No="<%=j%>"  id="item_<%=id_%>" filepath="<%=filepath%>" class="tide_item">
            <td class="valign-middle">
              <label class="ckbox mg-b-0">
				<input type="checkbox" name="id" value="<%=id_%>"><span></span>
			  </label>
            </td>
            <td ondragstart="OnDragStart (event)">
              <img id="img_<%=j%>" src="../images/tree6.png"/><%=title%>
			</td>
			<td class="hidden-xs-down"><%=StatusDesc%></td>
			<td class="hidden-xs-down"><%=dateline%></td>
			<td class="hidden-xs-down"><%=username%></td>
			<td class="dropdown hidden-xs-down">			
			<a href="javascript:Preview22('<%=filepath%>');" class="nav-link">正式地址预览</a>
			</td>
		</tr>
<%}

	if(listType==2)
	{
		String photoAddr = "";
			photoAddr = domainname+"attachment/" + filepath;
		if(m==0) out.println("<tr>");
		m++;
%>
		<td id="item_<%=id_%>"  filepath="<%=filepath%>" align="center" valign="top" class="tide_item" class="c">
			<div class="row">
				<div class="col-md">
				<div class="card bd-0">
					<div class="list-pic-box">
					<img class="card-img-top" src="<%=photoAddr%>" alt="Image" onerror="checkLoad(this);" >
					</div>
					<div class="card-body bd-t-0 rounded-bottom">
					  <p class="card-text"><i class="icon ion-image tx-22 tx-warning lh-0 valign-middle"></i><%=title%></p>
					  <div class="row mg-l-0 mg-r-0 mg-t-5">				                  					                  
						  <label class="ckbox mg-b-0 d-inline-block mg-r-5">
							<input name="id" value="<%=id_%>" type="checkbox"><span></span>
						  </label>
							<span class="title">作者:<%=username%></span>
						    <span class="title">大小:<%=size%>KB</span><p>
						    <span class="title">时间:<%=dateline%></span></P>
					
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

if(listType==3 && m<cols) out.println("</tr>");

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

		   <div class="btn-group hidden-xs-down">
				<a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i class="fa fa-th"></i></a>
				<a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i class="fa fa-th-list"></i></a>
			</div>
			<!--<button id="showSubLeft" class="btn btn-secondary mg-r-10 hidden-lg-up"><i class="fa fa-navicon"></i></button>-->
		  <div class="btn-group mg-l-10 hidden-xs-down">          
          <a href="javascript:list();" class="btn btn-outline-info list_all" >全部</a>
		  <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft" >未审核</a>
		  <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish" >已审核</a>		  
          <a href="#" class="btn btn-outline-info btn-search">检索</a>
	    </div>			
				<!-- btn-group -->
		<div class="btn-group mg-l-auto hidden-sm-down">
		    <a href="#" class="btn btn-outline-info " onClick="addDocument();" >新建</a>
            <a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
            <a href="javascript:recommendOut();" class="btn btn-outline-info">推荐</a> 					
			<a href="javascript:approve();" class="btn btn-outline-info">审核</a>
			<a href="javascript:deleteFile2();" class="btn btn-outline-info">撤销审核</a>
			<a href="javascript:javascript:deleteFile();" class="btn btn-outline-danger">删除</a>  
        </div><!-- btn-group -->
			
            
			
			<!-- btn-group -->
			<div class="btn-group mg-l-10 hidden-sm-down">
				<%if(currPage>1){%>
				<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
				<%}%>
				<%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
				<%}%>
			</div>
			<!-- btn-group -->

		<!-- START: 只显示在移动端 -->			
		<div class="dropdown hidden-sm-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
          <div class="dropdown-menu pd-10">
            <nav class="nav nav-style-1 flex-column">
              <a href="javascript:list();" class="btn btn-outline-info list_all" >全部</a>
		      <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft" >未审核</a>
		      <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish" >已审核</a>		  
              <a href="#" class="btn btn-outline-info btn-search">检索</a>
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
		<!-- END: 只显示在移动端-->
		<!-- START: 只显示在移动端 -->		
        <div class="dropdown mg-l-auto hidden-md-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
          <div class="dropdown-menu dropdown-menu-right pd-10">
            <nav class="nav nav-style-1 flex-column">
				<a href="#" class="btn btn-outline-info list_all" onClick="addDocument();" >新建</a>
            <a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
            <a href="javascript:recommendOut();" class="btn btn-outline-info">推荐</a> 					
			<a href="javascript:approve();" class="btn btn-outline-info">审核</a>
			<a href="javascript:deleteFile2();" class="btn btn-outline-info">撤销审核</a>
			<a href="javascript:javascript:deleteFile();" class="btn btn-outline-danger">删除</a>  
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->		
		<!-- END: 只显示在移动端-->
		</div>
		<!--操作-->

     <%}else{%>
		<script>
			var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:0};
		</script>
     <%}%>
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

		// Datepicker
		$('.fc-datepicker').datepicker({
			showOtherMonths: true,
			selectOtherMonths: true,
			dateFormat: "yy-mm-dd"
		});

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
	});
jQuery(document).ready(function(){

<%if(listType==2){%>
	$("img[type='tide']").each(function(i){
   autoLoadImage(true,120,120,"",$(this));
 });
$("#rows").val(rows);
$("#cols").val(cols);
<%}%>
var beforeShowFunc = function() {}
		var menu = [
  {'<img src="../images/inner_menu_release.gif" title="审核"/>审核':function(menuItem,menu) {approve();} },
  {'<img src="../images/inner_menu_recall.gif" title="撤销审核"/>撤销审核':function(menuItem,menu) {deleteFile2(); }},
  {'<img src="../images/inner_menu_preview.gif" title="预览"/>预览':function(menuItem,menu) {Preview(); }},
  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile();}}
];
/*$(document).bind("contextmenu",function(){return false;});
$('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
}); */
</script>
<%
}catch(Exception e)
{
	//System.out.println("::"+e.getMessage());
	if(e.getMessage().contains("连接数据库失败"))
	{
			out.println("<div class=\"channel-name mg-l-30 mg-r-30\"><div class=\"channel-name-box\"><div class=\"set-img-box\"><i class=\"fa fa-exclamation-triangle tx-50 lh-72\" aria-hidden=\"true\"></i></div><div class=\"right-info\"><h5 class=\"tx-22\">不能获取数据</h5><p class=\"tx-12\">请联系系统管理员确定配置是否正确，或拨打400-0873-128寻求技术支持。</p></div></div></div>");
	
	}
}
%>
</div>
  <%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>