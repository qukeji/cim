<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.report.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
int id = Util.getIntParameter(request,"id");
int currPage = Util.getIntParameter(request,"currPage");
int rowsPerPage = Util.getIntParameter(request,"rowsPerPage");
String sortable = Util.getParameter(request,"sortable");

if(currPage<1)
	currPage = 1;

if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage = 20;
String querystring="";
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
	response.sendRedirect("page_info.jsp?id="+id);
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
String S_startDate			=	getParameter(request,"startDate");
String S_endDate			=	getParameter(request,"endDate");
int parent = getIntParameter(request,"Parent");
int type2 = getIntParameter(request,"type2");
int IsDisplay = getIntParameter(request,"IsDisplay");
String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1){
	pageName = pageName.substring(pindex+1);
}
//querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete;
querystring = "&id="+id;
int Status1			=	getIntParameter(request,"Status1");
String ListSql = "select * from channel where parent="+ChannelID ;
String CountSql = "select count(*) from channel where parent="+ChannelID ;
String WhereSql = "";
int S_UserID = 0;
int IsActive = 0;

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
if(S_UserID>0)
{
	WhereSql += " and User="+S_UserID;
}

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and name like '%" + channel.SQLQuote(tempTitle) + "%'";
}
if(!S_startDate.equals("")){
	long startTime=Util.getFromTime(S_startDate,"");
	WhereSql += " and CreateDate>="+startTime ;
}
if(!S_endDate.equals("")){
	long endTime=Util.getFromTime(S_endDate,"");
	WhereSql += " and CreateDate<"+(endTime+86400);
}

if(S_Status!=0)
	WhereSql += " and Status=" + (S_Status-1);

if(Status1!=0)
{
	if(Status1==-1)
		WhereSql += " and Status=0";
	else
		WhereSql += " and Status=" + Status1;
}

if(type2>0)
	WhereSql +=" and type2="+type2;
if(IsDisplay>0)
	WhereSql +=" and IsDisplay="+IsDisplay;

WhereSql +=" order by OrderNumber desc,id";
//String WhereSql = " and type2=3 and IsDisplay=1 order by OrderNumber,id";
ListSql +=WhereSql;
CountSql +=WhereSql;
 CmsCache.delParameter("sys_special_template_json");
String template_json= CmsCache.getParameter("sys_special_template_json").getContent();
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
var ChannelID = <%=ChannelID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var listType = 1;
	var pageName = "<%=pageName%>";
	if (pageName == "") pageName = "content.jsp";
function list(str) {
		var url = pageName + "?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
		if (typeof(str) != 'undefined')
			url += "&" + str;
		this.location = url;
	}
function addSpecial()
{
	var url='../special/channel_special_add1.jsp?ChannelID=<%=channel.getId()%>&Type=0';
	url+='&ChannelName=<%=java.net.URLEncoder.encode(channel.getName(),"UTF-8")%>';
	var	dialog = new top.TideDialog();
		dialog.setWidth(900);
		dialog.setHeight(700);
		dialog.setUrl(url);
		dialog.setTitle("新建专题频道");
		dialog.show();
}
function addSpecialcould()
{
 window.open("special_list.jsp?ChannelID=<%=channel.getId()%>&Type=0&&ChannelName=<%=java.net.URLEncoder.encode(channel.getName(),"UTF-8")%>" );
}

function Preview(id)
{
	 window.open("special_preview1.jsp?id=" + id);
}

function Preview()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要预览的文件！");
	}else if(obj.length>1){
		alert("请先选择一个预览的文件！");
	}else{
		window.open("special_preview.jsp?id=" + obj.id);
	}
}

function Preview_bar(){
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要预览的文件！");
	}else if(obj.length>1){
		alert("请先选择一个预览的文件！");
	}else{
		window.open("special_preview.jsp?id=" + obj.id);
	}
}
function Preview2(id)
{
	 window.open("special_preview2.jsp?id=" + id);
}
//模板设置
function Template(id,name,flag){
	//alert(id+"=="+name+"flag")
	$.ajax({
		type:"POST",
		url:"special_template_set.jsp",
	    data:"flag="+flag+"&id="+id+"&name="+name,//flag=1是设为模板，flag=2移除模板
		async:false,
		success:function(msg){
			 var jsonobj = eval("("+msg+")");
			 var res = jsonobj.res;
			 var flag= jsonobj.flag;
			 if(flag==1&&res>0)
					alert("设置模板成功");
			 else if(flag==0&&res>0)
					 alert("移除模板成功");
			 else
				 alert("模板设置失败");
			 window.location.reload();
		}
	});
}

function editDocument(itemid)
{
  	var url="special_edit.jsp?id="+itemid;
  	window.open(url);
}
</script>
</head>

<body class="collapsed-menu email">
	<div class="br-mainpanel br-mainpanel-file" id="js-source">
		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active">当前位置：<%=channel.getName()%></span>
			</nav>
		</div>
		<!-- br-pageheader -->

		<!--操作-->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

			<!-- START: 只显示在移动端 -->
			<div class="dropdown hidden-sm-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
				<div class="dropdown-menu pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="javascript:list();" class="nav-link list_all">全部</a>
					
						<a href="#" class="nav-link">搜索</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端-->

			<div class="btn-group hidden-xs-down">
				<a href="javascript:changeList(2);" class="btn btn-outline-info "><i class="fa fa-th"></i></a>
				<a href="javascript:changeList(1);" class="btn btn-outline-info active"><i class="fa fa-th-list"></i></a>
			</div>
			<!-- btn-group -->
			<div class="btn-group mg-l-10 hidden-xs-down">
				<a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
			
				<a href="#" class="btn btn-outline-info btn-search">搜索</a>
			</div>
			<!-- btn-group -->

			<div class="btn-group mg-l-auto hidden-sm-down">
            <%if(new ChannelPrivilege().hasRight(userinfo_session,ChannelID,ChannelPrivilege.AddItem)){%><a href="javascript:addSpecial();" class="btn btn-outline-info " >新建专题</a><%}%>
            <a href="javascript:addSpecialcould();" class="btn btn-outline-info " >云专题</a>
			

            <a href="javascript:Preview();" class="btn btn-outline-info " >预览</a>

			</div>
			
		  <div class="btn-group mg-l-10 hidden-sm-down">
            <a href="" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
            <a href="" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
          </div>
			<!-- dropdown -->
		
						
			<!--上一页 下一页-->
			<div class="btn-group mg-l-10">
			
			</div>
			<!-- btn-group -->
			
		</div>
		<!--操作-->

		<!--搜索-->
		<div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
			<div class="search-content bg-white">
				<form name="search_form" action="special_content.jsp?id=16220&rowsPerPage=20" method="post" onsubmit="return check();">
					<div class="row">
						<!--标题-->
						<div class="mg-r-10 mg-b-30 search-item">
							<input class="form-control search-title" placeholder="标题" type="text" name="Title" value="" onClick="this.select()">
						</div>
						<!--日期-->
						<div class="wd-200 mg-b-30 mg-r-10 search-item">
							<div class="input-group">
								<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
								<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="startDate" value="" id="startDate">
							</div>
						</div>
						<div class="wd-20 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>
						<div class="wd-200 mg-b-30 mg-r-10 search-item">
							<div class="input-group">
								<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
								<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="endDate" value="" id="endDate">
							</div>
						</div>
						<!-- wd-200 -->
						
						<!--状态-->
						<div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
							<select class="form-control select2" data-placeholder="状态" name="Status">
								<option label="Choose one"></option>
								<option value="0">全部</option>
								
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

	
		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<%if(channel.hasRight(userinfo_session,1)){%>
            
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0 " id="content-table">
					<thead>
						<tr style="text-align:center">
							<th class="wd-5p wd-50">选择</th>
							<th class="tx-12-force tx-mont tx-medium wd-250">标题</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150" style="text-align:center">日期</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120 wd-author" style="text-align:center">作者</th>
							<th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down" style="text-align:center">操作</th>
						</tr>
					</thead>
                  
					<tbody>
                            <%
                            //ArrayList arraylist = channel.listSubChannels();
                            //for(int i = arraylist.size()-1;i>=0;i--)
                            //{
                            	//Channel subch = (Channel)arraylist.get(i);
                            	//if(subch.getType2()!=Channel.ChannelSpecial)
                            		//continue;
                            
                            	TableUtil tu = new TableUtil();
                            	ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
                            	int TotalPageNumber = tu.pagecontrol.getMaxPages();
                                int TotalNumber = tu.pagecontrol.getRowsCount();
                            	while(Rs.next()){
                            	int id_ = Rs.getInt("id");
                            	String name = Rs.getString("Name");
                            		int Status = Rs.getInt("Status");
                            		String StatusDesc="";
                    		    	if(Status==0){
                                		StatusDesc = "<span class='tx-orange'>草稿</span>";
                                	}else if(Status==1){
                                		StatusDesc = "<span class='tx-success'>已发</span>";
                                	}else{
                                		StatusDesc = "<span class='tx-danger'>已删除</span>";
                                	}

                            	String date = Util.FormatDate("yyyy-MM-dd HH:mm:ss",Rs.getString("CreateDate"));
                            %>
                             <tr ItemID="<%=id_%>" class="tide_item">
                               <td class="valign-middle">
                                  <label class="ckbox mg-b-0">
                    				<input type="checkbox" name="id" value="<%=id_%>"><span></span>
                    			  </label>
                                </td>
                                <td class="hidden-xs-down">
                                    <%=name%>
                                </td>
                               
                                <td class="hidden-xs-down" style="text-align:center">
                                    <%=date%>
                                </td>
                                <td class="v4"  style="color:#666666;"style="text-align:center"></td>
            
                                <td class="dropdown hidden-xs-down" style="text-align:center">
                                    <a href="javascript:Preview(<%=id_%>);" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
                                    <a href="javascript:Preview2(<%=id_%>);" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
                                    <% if(!template_json.contains(id_+"")){ %>
                                    <div class="btn pd-0 mg-r-5" onclick="Template(<%=id_%>,'<%=name%>',1);"><img src="../images/icon/01.png" title="添加模板" /></div>
                                    <%}else{ %>
                                    <div class="btn pd-0 mg-r-5" onclick="Template(<%=id_%>,'<%=name%>',0);"><img src="../images/icon/02.png" title="移除模板" /></div>
                                    <%} %>
                                </td>
                              </tr>
                              <%}%>
					</tbody>
				</table>
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
                            <option value="10" <%=rowsPerPage==10?"selected":""%>>10</option>
                            <option value="15" <%=rowsPerPage==15?"selected":""%>>15</option>
                            <option value="20" <%=rowsPerPage==20?"selected":""%>>20</option>
                            <option value="25" <%=rowsPerPage==25?"selected":""%>>25</option>
                            <option value="30" <%=rowsPerPage==30?"selected":""%>>30</option>
                            <option value="50" <%=rowsPerPage==50?"selected":""%>>50</option>
                            <option value="80" <%=rowsPerPage==80?"selected":""%>>80</option>
                            <option value="100" <%=rowsPerPage==100?"selected":""%>>100</option>
                            <option value="500" <%=rowsPerPage==500?"selected":""%>>500</option>
                            <option value="1000" <%=rowsPerPage==1000?"selected":""%>>1000</option>
                            <option value="5000" <%=rowsPerPage==5000?"selected":""%>>5000</option>
                        </select>
                    </label> 条
                </div>
            </div>
            <!--分页-->
				<script>
				 var page = {
                    id: '<%=id%>',
                    currPage: '<%=currPage%>',
                    rowsPerPage: '<%=rowsPerPage%>',
                    querystring: '<%=querystring%>',
                    TotalPageNumber: 0
                };
				</script>
                
				
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

			
            <div class="btn-group hidden-xs-down">
				<a href="javascript:changeList(2);" class="btn btn-outline-info "><i class="fa fa-th"></i></a>
				<a href="javascript:changeList(1);" class="btn btn-outline-info active"><i class="fa fa-th-list"></i></a>
			</div>
			<!-- btn-group -->
			<div class="btn-group mg-l-10 hidden-xs-down">
				<a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
			
				<a href="#" class="btn btn-outline-info btn-search">搜索</a>
			</div>
			<!-- btn-group -->

			<div class="btn-group mg-l-auto hidden-sm-down">
            <%if(new ChannelPrivilege().hasRight(userinfo_session,ChannelID,ChannelPrivilege.AddItem)){%><a href="javascript:addSpecial();" class="btn btn-outline-info " >新建专题</a>
              <a href="javascript:addSpecialcould();" class="btn btn-outline-info " >云专题</a>
			

            <a href="javascript:Preview();" class="btn btn-outline-info " >预览</a>
            <%}%>
			</div>
			  <div class="btn-group mg-l-10 hidden-sm-down">
			   <%if(currPage>1){%>
                <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
                <%}%>
                <%if(currPage<TotalPageNumber){%>
                <a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
                <%}%>
                
             </div>
			
			<div class="btn-group mg-l-10">
    			
			</div>
			<!-- btn-group -->
		</div>
		<!--操作-->
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
	function change(obj)
{
	if(obj!=null)		this.location="special_content.jsp?rowsPerPage="+obj.value+"<%=querystring%>";
}

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
		
			{'<i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i>预览':function(menuItem,menu) {Preview_bar(); }},
			//{'<i class="fa fa-trash mg-r-5"></i><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile();}}
		
		];
		$('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});	
	})
</script>

    </div>
    
    <!--3ms-->
</body>

</html>
