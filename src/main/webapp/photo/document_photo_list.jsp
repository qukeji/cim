<%@page import="java.util.Date"%>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.text.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"channelid_photo");

if(id==0)
{
	//把图片库频道编号的配置移到sys_config_photo中了，废除sys_channelid_photo 2012-10-12
	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
	id = photo_config.getInt("channelid");
	//id = CmsCache.getParameter("sys_channelid_photo").getIntValue();
	if(id==0)
	{
		out.println("图片集频道没有配置.");
		return;
	}
}
int globalid = getIntParameter(request,"globalid");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
int fieldgroup = getIntParameter(request,"fieldgroup");//表单组

int TotalPageNumber=0;
int TotalNumber=0;
String sortable = getParameter(request,"sortable");
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
Channel parentchannel = null;
int ChannelID = channel.getId();
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();

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

String SiteAddress = channel.getSite().getUrl();

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&globalid="+globalid+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&fieldgroup="+fieldgroup;

int Status1			=	getIntParameter(request,"Status1");

int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list_new",request.getCookies()));
if(listType==0) listType = 1;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

String uri=request.getRequestURI();
String li_style="";

switch(cols){
		case 3: li_style="style=\"width:33.33%\"";break;
		case 4: li_style="style=\"width:25%\"";break;
		case 5: li_style="style=\"width:20%\"";break;
		case 6: li_style="style=\"width:16.66%\"";break;
		case 7: li_style="style=\"width:14.28%\"";break;
		case 8: li_style="style=\"width:12.5%\"";break;
		case 10: li_style="style=\"width:10%\"";break;
		case 16: li_style="style=\"width:6.25%\"";break;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
<meta name="renderer" content="webkit">
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
<link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />
<style>
	.collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
	#content-table .row{margin-left: 0;margin-right: 0;}
	table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
	border-collapse: collapse !important;}
	table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word;}
	
	.list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;position: relative;}
	.list-pic-box .list-img-contanier{width: 100%;position: absolute;left: 0;top: 0;height: 100%;display: flex;justify-content: center;align-items: center;}
	.list-pic-box .list-img-contanier img{width: auto;max-height: 100%;max-width: 100%;}
	@media (max-width: 575px){
		#content-table .hidden-xs-down {word-break: normal;	}
	}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/content.js"></script>
<script>
var ChannelID = <%=ChannelID%>;
var rows = <%=rows%>;
var cols = <%=cols%>;
var currPage = <%=currPage%>;
var currRowsPerPage = <%=rowsPerPage%>;
var globalid = <%=globalid%>;
var fieldgroup = <%=fieldgroup%>;
var listType = <%=listType%>;//图片列表
var Parameter = "&ChannelID="+ChannelID+"&globalid="+globalid+"&rows="+rows+"&cols="+cols+"&currPage="+currPage+"&fieldgroup="+fieldgroup + "&rowsPerPage=" + currRowsPerPage;
var pageName = "<%=pageName%>";
if (pageName == "") pageName = "content.jsp";
var order_numbers = "";
var ids = "";

function addDocument()
{
	if(top)
	{
		var gid = top.document.form.GlobalID.value;
		if(gid==0){
		}else{
			//var url="../content/document.jsp?ItemID=0&ChannelID=" + ChannelID;
			//if(pid>0) url += "&pid="+ pid;
			//window.open(url);
			var url='../photo/document_sub_photo.jsp?ItemID=0&ChannelID=' + ChannelID + '&globalid=' + globalid + "&fieldgroup="+fieldgroup;
			var	dialog = new top.TideDialog();
			dialog.setWidth(600);
			dialog.setHeight(520);
			dialog.setUrl(url);
			dialog.setLayer(2);
			dialog.setScroll('auto');
			dialog.setTitle("添加图片");
			dialog.show();
		}
	}
}

//图集排序

function SortDoc2(){
	
	var obj=getCheckbox();
	if(obj.length!=1){
		TideAlert("提示","请选择一个待排序的选项!");
	}else{
		SortDoc3(obj.id);
	}	
}

function SortDoc3(id){
 	var iframe = window.frameElement.id;
	var OrderNumber = $("#item_"+id).attr("OrderNumber");		
	var url= "../photo/document_sort.jsp?ChannelID="+ChannelID+"&ItemID="+id+"&OrderNumber="+OrderNumber+"&iframe="+iframe;
	var	dialog = new top.TideDialog();
	dialog.setWidth(300);
	dialog.setHeight(230);
	dialog.setUrl(url);
	dialog.setTitle("排序");
	dialog.show();
}

function editDocument(itemid)
{
	var url='../photo/document_sub_photo.jsp?ItemID='+itemid+'&ChannelID=' + ChannelID + '&globalid=' + globalid + '&fieldgroup='+fieldgroup;

	var	dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(520);
	dialog.setUrl(url);
	dialog.setLayer(2);
	dialog.setScroll('auto');
	dialog.setTitle("添加图片");
	dialog.show();
}

function init()
{
	var gid = top.document.form.GlobalID.value;
	if(gid==0)
	{
		var url="../content/document_get_globalid.jsp?id="+top.document.form.ChannelID.value;
		$.ajax({
			 type: "GET",
			 url: url,
			 error:function(){alert("超时错误");},
			 success: function(msg)
			{
				var str = msg.split(",");
				globalid = str[0];
				var itemid = str[1];
				Parameter = "&ChannelID="+ChannelID+"&globalid="+globalid+"&rows="+rows+"&cols="+cols+"&currPage="+currPage;
				top.document.form.GlobalID.value = globalid;
				top.document.form.ItemID.value = itemid;
				top.document.form.Action.value = "Update";
				var url = top.$("#form"+fieldgroup).attr("url");//alert(url);
				url = url.replace("globalid=0","globalid="+globalid);
				top.$("#form"+fieldgroup).attr("url",url);//alert(top.$("#form2").attr("url"));
				window.location.href = url;
			}   
		}); 
	}

	$("#content-table td").each(function(){
		order_numbers += (order_numbers==""?"":",") +$(this).attr("order_number");
	}); 
}

/**改变每页显示*/
function changeRowsCols()
{
	var rows = $("#rows").val();
	var cols = $("#cols").val();
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = "rows_new=" + rows + ";path=/;expires=" + expires.toGMTString();
	document.cookie = "cols_new=" + cols + ";path=/;expires=" + expires.toGMTString();
	document.location.href = "document_photo_list.jsp?id="+ChannelID+"&globalid="+globalid+"&rows="+rows+"&cols="+cols;
}

//批量上传
function multiUpload()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(900);
	dialog.setHeight(650);
	dialog.setLayer(2);
	dialog.setUrl("../photo/upload_images.jsp?ChannelID="+ChannelID+"&globalid="+globalid+"&fieldgroup="+fieldgroup);
	dialog.setTitle("批量上传");
	dialog.show();
}
function deletePicture(){
	var obj = getCheckbox();
	if(obj.length==0){
		TideAlert("提示","请先选择要删除的图片！");
		return;
	}else{
		message = "确定要删除这"+obj.length+"个图片吗？";
	}
	if(!confirm(message)){
			return;
	}
	$.post("../photo/delete_picture.jsp",{itemid:obj.id,id:<%=id%>},function(data){
	    var obj = JSON.parse(data);
		if(obj.status=="success"){
				location.reload();
		}
	});
}
function deletePicture1(id){
	message = "确定要删除这个图片吗？";
	if(!confirm(message)){
			return;
	}
	$.post("../photo/delete_picture.jsp",{"itemid":id,"id":<%=id%>},function(data){
	    var obj = JSON.parse(data);
		if(obj.status=="success"){
				location.reload();
		}
	});
}
function selectNo(){
	jQuery("#content-table>td").removeClass("cur");
	var obj=jQuery(":checkbox",jQuery("#content-table"));
	obj.removeAttr("checked","checked");
}

function selectAll(){
	jQuery("#content-table>td").addClass("cur");
	var obj=jQuery(":checkbox",jQuery("#main_content"));
	obj.attr("checked","checked");
}

</script>
</head>
<body onLoad="init();" class="collapsed-menu email">
	<div class="br-mainpanel br-mainpanel-file" id="js-source">
		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active"><%=channel.getParentChannelPath().replace(">"," / ")%></span>
			</nav>
			
		</div>
		<!-- br-pageheader -->
<%
if(globalid!=0){
int S_UserID = 0;
long weightTime = 0;
int IsActive = 1;
if(IsDelete==1) IsActive=0;
//Site imagesite = CmsCache.getSite(3);

/*
boolean has_photo_s = false;//是否有缩略图字段
Field field = channel.getFieldByFieldName("Photo_s");
if(field!=null) has_photo_s = true;
*/
boolean has_photo_m = false;//是否有缩略图字段
Field field = channel.getFieldByFieldName("Photo_m");
if(field!=null) has_photo_m = true;

String ids = "";
String Sql = "select * from "+channel.getTableName()+" where Parent=" + globalid + " and Status=1 order by OrderNumber desc";
String Sql2 = "select count(*) from "+channel.getTableName()+" where Parent=" + globalid + " and Status=1";

int listnum = rowsPerPage;
if(listType==2) listnum = cols*rows;

TableUtil tu = channel.getTableUtil();
ResultSet Rs = tu.List(Sql,Sql2,currPage,listnum);
TotalPageNumber = tu.pagecontrol.getMaxPages();
TotalNumber = tu.pagecontrol.getRowsCount();
%>

		<!--操作-->
		<div class="d-flex align-items-center justify-content-start pd-t-25 pd-x-20 mg-b-20 mg-sm-b-30">
			
			<div class="btn-group hidden-xs-down">
				<a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i class="fa fa-th"></i></a>
				<a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i class="fa fa-th-list"></i></a>
			</div>
			
			<!-- btn-group -->

			<!-- START: 只显示在移动端 -->
			<div class="dropdown hidden-sm-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
				<div class="dropdown-menu dropdown-menu-right pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="javascript:approve();" class="nav-link">发布</a>
						<a href="javascript:Preview();" class="nav-link">预览</a>
						<a href="javascript:editDocument1();" class="nav-link">编辑</a>
						<a href="javascript:deleteFile2();" class="nav-link">撤稿</a>
						<%if(!channel.getRecommendOut().equals("")){%>
						<a href="javascript:recommendOut()" class="nav-link">推荐</a>
						<%}%>
						<%if(!channel.getAttribute1().equals("")){%>
						<a href="javascript:recommendIn();" class="nav-link">引用</a>
						<%}%>
						<a href="javascript:delete();" class="nav-link">删除</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- END: 只显示在移动端 -->
            <div class="btn-group mg-l-auto hidden-sm-down">
				<a href="javascript:addDocument()" class="btn btn-outline-info">新建</a>		
				<a href="javascript:approve();" class="btn btn-outline-info">发布</a>
				<a href="javascript:Preview_wl();" class="btn btn-outline-info">预览</a>
				<a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
				<!--<a href="javascript:deleteFile2();" class="btn btn-outline-info">撤稿</a>-->
				<%if(!channel.getRecommendOut().equals("")){%>
					<a href="javascript:recommendOut()" class="btn btn-outline-info">推荐</a>
				<%}%>
				<%if(!channel.getAttribute1().equals("")){%>
					<a href="javascript:recommendIn();" class="btn btn-outline-info">引用</a>
				<%}%>
				<a href="javascript:deletePicture();" class="btn btn-outline-info">删除</a>
				<a href="javascript:SortDoc2();" class="btn btn-outline-info">排序</a>
				<a href="javascript:parentEvent()" class="btn btn-outline-info">图集预览</a>				
				<a href="javascript:multiUpload()" class="btn btn-outline-info">批量上传</a>
										
			</div>
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
		<!--操作-->

		<!--列表-->
		<!--列表-->
		<div class="br-pagebody pd-x-20">
			<div class="card bd-0 shadow-base">
<%if(channel.hasRight(userinfo_session,1)){%>
				<table class="table mg-b-0 <%=listType==2?"table-fixed":""%>" cellspacing="0" cellpadding="0" id="content-table">
				<%if(listType==1){%>
					<thead>
						<tr>
							<th class="wd-5p wd-50">选择</th>
							<th class="tx-12-force tx-mont tx-medium">标题</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-60">状态</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">日期</th>
							<th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down wd-160">操作</th>
						</tr>
					</thead>
                  <%}%>
					<tbody>
<%

int j = 0;
int m = 0;
while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status =Rs.getInt("Status");
	int user = Rs.getInt("User");
//	int OrderNumber = Rs.getInt("OrderNumber");
	String Title2="";
	String Title	= tu.convertNull(Rs.getString("Title"));
	String ModifiedDate	= convertNull(Rs.getString("ModifiedDate"));
/*	long l=Long.parseLong(ModifiedDate);
	Date date = new Date(l);*/
//	ModifiedDate=Util.FormatDate("yyyy-MM-dd HH:mm",l*1000);
    ModifiedDate = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date(Long.valueOf(ModifiedDate+"000")));
	String htmlTitle ="";
	Title2=Title;
	if(Title.length()>10){
		Title2=Title.substring(0,10);
		Title2+="...";
	}

	String Photo = "";
	String Photo_s = "";
	String Photo_m = "";
	String Photo_b = "";
/*	if(has_photo_s)
		Photo_s = tu.convertNull(Rs.getString("Photo_s"));
*/	
	if(has_photo_m)
		Photo_m = tu.convertNull(Rs.getString("Photo_m"));
	
	Photo = tu.convertNull(Rs.getString("Photo"));

	Photo_b = Photo ;//大图

//	if(Photo_s.length()>0) Photo = Photo_s;
	if(Photo_m.length()>0) Photo = Photo_m;

	int GlobalID = 0;//doc.getGlobalID();

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
	String photoAddr = "";
	if(Photo.startsWith("http://"))//以http开头的就保持不变 2012-06-19
	{
		photoAddr = Photo;
		//if(photoAddr.startsWith(imagesite.getExternalUrl()))
		//{
			//photoAddr = photoAddr.replace(imagesite.getExternalUrl(),imagesite.getUrl());
		//}
	}
	else {
		photoAddr = SiteAddress + Photo;
		Photo_b = SiteAddress + Photo_b ;
    }
	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;

	if(listType==1)
	{
%>

	<tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>" status="<%=Status%>" GlobalID="<%=globalid%>" id="item_<%=id_%>" class="tide_item">
		<td class="valign-middle">
		  <label class="ckbox mg-b-0">
			<input type="checkbox" name="id" value="<%=id_%>"><span></span>
		  </label>
		</td>
		<td ondragstart="OnDragStart(event)">
		  <input type="hidden" id="<%=id_%>" value="<%=Photo_b%>">
		  <i class="icon drag-list ion-clipboard tx-22 tx-warning lh-0 valign-middle" id="img_<%=j%>"></i>
		  <span class="pd-l-5 tx-black image" data-src="<%=Photo_b%>"><%=Title%></span>
		</td>
		<td class="hidden-xs-down">
			<%=StatusDesc%>
		</td>
		<td class="hidden-xs-down">
			<%=ModifiedDate%>
		</td>
		<td class="dropdown hidden-xs-down">
					<a href="javascript:editDocument(<%=id_%>);" class="class="drag-handle" title="编辑"><i class="fa fa-pencil-square-o tx-20" aria-hidden="true"></i></a>
					<a href="javascript:deletePicture1(<%=id_%>);" class="class="drag-handle" title="删除"><i class="fa fa-trash-o tx-20" aria-hidden="true"></i></a>
					<!--<a href="javascript:deleteFile3(<%=id_%>);" class="class="drag-handle" title="撤稿"><i class="fa fa-reply" aria-hidden="true"></i></a>-->
				<!-- dropdown-menu -->
		</td>
	</tr>

<%}
if(listType==2)
{
	if(m==0) out.println("<tr>");
	m++;
%>
		<td id_="<%=id_%>" class="tide_item" order_number="<%=OrderNumber%>" parentid="<%=globalid%>"  <%=li_style%> >
			<div class="row">
				<div class="col-md">
					<div class="card bd-0">
						<div class="list-pic-box">
								<div class="list-img-contanier">
									<img class="card-img-top" src="<%=photoAddr%>" data-src="<%=Photo_b%>" alt="Image" onerror="checkLoad(this);" type="tide">
								</div>	
						</div>
						
						<div class="card-body bd-t-0 rounded-bottom">
							<div class="row mg-l-0 mg-r-0 mg-t-5">				                  					                  
							    <label class="ckbox mg-b-0 d-inline-block mg-r-5">
								    <input name="id" value="<%=id_%>" type="checkbox"><span></span>
							    </label>
					  		</div>
							<p class="card-text" title="<%=htmlTitle%>"><%=Title%>(<%=StatusDesc%>)</p>
						</div>
						
						<%-- <div class="row mg-l-0 mg-r-0 mg-t-15">
							<label class="ckbox mg-b-0 d-inline-block mg-r-5">
								<input name="id" value="<%=id_%>" type="checkbox"><span></span>
							</label>
							<label>
								<p class="card-text" title="<%=htmlTitle%>"><%=Title%>(<%=StatusDesc%>)</p>
							</label>
						</div> --%>
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
<%
}
%>

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
			</div>
		</div>
		<!--列表-->

		<!--操作-->
		<div class="d-flex align-items-center justify-content-start pd-t-25 pd-x-20 mg-b-20 mg-sm-b-30">
			<div class="btn-group hidden-xs-down">
				<a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i class="fa fa-th"></i></a>
				<a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i class="fa fa-th-list"></i></a>
			</div> 
		
			<!-- START: 只显示在移动端 -->
			<div class="dropdown hidden-sm-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
				<div class="dropdown-menu dropdown-menu-right pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="javascript:approve();" class="nav-link">发布</a>
						<a href="javascript:Preview();" class="nav-link">预览</a>
						<a href="javascript:editDocument1();" class="nav-link">编辑</a>
						<a href="javascript:deleteFile2();" class="nav-link">撤稿</a>
						<%if(!channel.getRecommendOut().equals("")){%>
						<a href="javascript:recommendOut()" class="nav-link">推荐</a>
						<%}%>
						<%if(!channel.getAttribute1().equals("")){%>
						<a href="javascript:recommendIn();" class="nav-link">引用</a>
						<%}%>
						<a href="javascript:deleteFile();" class="nav-link">删除</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- END: 只显示在移动端 -->
             <div class="btn-group mg-l-auto hidden-sm-down">
				 <a href="javascript:addDocument()" class="btn btn-outline-info">新建</a>	
				 <a href="javascript:approve();" class="btn btn-outline-info">发布</a>
				 <a href="javascript:Preview_wl();" class="btn btn-outline-info">预览</a>
				 <a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
				 <!--<a href="javascript:deleteFile2();" class="btn btn-outline-info">撤稿</a>-->
				 <%if(!channel.getRecommendOut().equals("")){%>
				 	<a href="javascript:recommendOut()" class="btn btn-outline-info">推荐</a>
				 <%}%>
				 <%if(!channel.getAttribute1().equals("")){%>
				 	<a href="javascript:recommendIn();" class="btn btn-outline-info">引用</a>
				 <%}%>
				 <a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>
				 <a href="javascript:SortDoc2();" class="btn btn-outline-info">排序</a>
				<a href="javascript:parentEvent()" class="btn btn-outline-info">图集预览</a>				
				<a href="javascript:multiUpload()" class="btn btn-outline-info">批量上传</a>
											
			</div>
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
		<!--操作-->

<%}else{%>
		<script>
			var page={id:'<%=id%>',currPage:'<%=currPage%>',querystring:'<%=querystring%>',TotalPageNumber:0};
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
			$(function() {
				'use strict';

				$("#content-table tr td").click(function() {				
					var _tr = $(this).parent("tr")
					if(!$("#content-table").hasClass("table-fixed")){
						if( _tr.find(":checkbox").prop("checked") ){
							_tr.find(":checkbox").removeAttr("checked");
							$(this).parent("tr").removeClass("bg-gray-100");
						}else{
							_tr.find(":checkbox").prop("checked", true);
							$(this).parent("tr").addClass("bg-gray-100");
						}
					}else{
						if( $(this).find(":checkbox").prop("checked") ){
							$(this).find(":checkbox").removeAttr("checked");
							//$(this).removeClass("bg-gray-100");
						}else{
							$(this).find(":checkbox").prop("checked", true);
							//$(this).addClass("bg-gray-100");
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
			});

			$(function(){    		
				
				var beforeShowFunc = function() {
					//console.log( getActiveNav() )
				};
				var menu = [
					{'<i class="fa fa-search mg-r-5"></i>发布':function(menuItem,menu) {approve();} },
					{'<i class="fa fa fa-eye mg-r-5"></i>预览':function(menuItem,menu) {Preview(); }},
					{'<i class="fa fa-edit mg-r-5 fa"></i>编辑':function(menuItem,menu) {editDocument1(); }},
					{'<i class="fa fa-arrow-down mg-r-5 fa"></i>撤稿':function(menuItem,menu) {deleteFile2(); }},
					<%if(!channel.getRecommendOut().equals("")){%>
					{'<i class="fa fa-share mg-r-5 fa"></i>推荐':function(menuItem,menu) {recommendOut();}},<%}%>
					<%if(!channel.getAttribute1().equals("")){%>
					{'<i class="fa fa-reply mg-r-5 fa"></i>引用':function(menuItem,menu) {recommendIn();}},<%}%>
					//{'<i class="fa fa-reply mg-r-5 fa"></i>刷新Cache':function(menuItem,menu) {RefreshItem(); }},
					{'<i class="fa fa-trash mg-r-5"></i><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile(); }},
					{'<i class="fa fa-trash mg-r-5"></i><font style="color:red;">排序</font>':function(menuItem,menu) {SortDoc2(); }}
				];
				$('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});	
				
				
				sortable(); //图集排序
			})
		</script>


<script type="text/javascript">
	function gopage(currpage) {
		var url = "document_photo_list.jsp?currPage=" + currpage + "&id=<%=id%><%=querystring%>";
		this.location = url;
	}
	function parentEvent(){
		window.parent.initPicsView(fieldgroup,listType);
	}
	function change(s,id){
		var value=jQuery(s).val();
		var exp = new Date();
		exp.setTime(exp.getTime() + 300*24*60*60*1000);
		document.cookie = "rowsPerPage="+value;
		document.location.href = pageName+"?id="+id+"&rowsPerPage="+value+"<%=querystring%>";

	}
	//图集预览
	function Preview_wl(){
		var obj=getCheckbox();
		if(obj.length==0){
			TideAlert("提示","请先选择要预览的文件！");
		}else if(obj.length>1){
			TideAlert("提示","请选择一个预览的文件！");
		}else{
			Preview_wl2(obj.id);//window.open("../content/document_preview.jsp?ItemID=" + obj.id + Parameter);
		}
	}
	function Preview_wl2(id){
		window.open($("#"+id).val());
	}
</script>

<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
