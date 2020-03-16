<%@ page import="java.sql.*,
				tidemedia.cms.publish.PublishScheme,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.util.Util,
				tidemedia.cms.system.LogAction"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
    *1、王海龙 20151225 querystring 加上数解决分页问题
	*
	*
	*/
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int type = getIntParameter(request,"type");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
String S_Title			=   getParameter(request,"S_Title");
String Action = getParameter(request,"Action");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 20;
String querystring="&S_Title="+S_Title;

if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	String Sql = "delete from tidecms_system_log where id=" + id;

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("system_log2018.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage);return;
}
else if(Action.equals("Clear"))
{
	String Sql = "TRUNCATE tidecms_system_log";

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("system_log2018.jsp");return;
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
.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<!-- <script type="text/javascript" src="../common/jquery.contextmenu.js"></script> -->
<script language="javascript">

//function setReturnValue(o){
//	if(o.refresh){
//		var s = "system_log2018.jsp";
//		if(o.rowsPerPage) s += "?rowsPerPage="+o.rowsPerPage;
//		if(o.currPage) s += "&currPage="+o.currPage;
//		document.location.href=s;
//	}
//}
function clearItems()
{
	var url="system_log_clear2018.jsp";
	var	dialog = new top.TideDialog();
	dialog.setWidth(320);
	dialog.setHeight(260);
	//dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("清空日志");
	dialog.show();	
	
	//if(confirm("确实要清空系统日志吗？")) 
	//{
	//	this.location = "system_log2018.jsp?Action=Clear";
	//}
}
function del(id)
{
	
	var url="system_log_del2018.jsp?Action=Del&rowsPerPage=<%=rowsPerPage%>&currPage=<%=currPage%>&id="+id;
	var	dialog = new top.TideDialog();
	dialog.setWidth(320);
	dialog.setHeight(260);
	//dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("删除日志");
	dialog.show();	
	
	//if(confirm("确实要清空系统日志吗？")) 
	//{
	//	this.location = "system_log2018.jsp?Action=Clear";
	//}
}

function Details(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(340);
	dialog.setScroll("auto");
	dialog.setUrl("system/system_log_detail.jsp?id=" + id);
	dialog.setTitle("详细信息");
	dialog.show();
}


function openSearch()
{ 
	var SearchArea=document.getElementById("SearchArea");
	if(SearchArea.style.display == "none")
	{
		//document.search_form.OpenSearch.value="1";
		SearchArea.style.display = "";
	}
	else
	{
		//document.search_form.OpenSearch.value="0";
		SearchArea.style.display = "none";
	}
}
function gopage(currpage) 
{
	var url = "system_log2018.jsp?currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
	this.location = url;
}

</script>

</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
        <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">日志管理 / 内容系统日志</span>
        </nav>
        </div><!-- br-pageheader -->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
        <div class="btn-group hidden-xs-down">
          <a href="system_log2018.jsp" class="btn btn-outline-info list_all">全部</a>
		  <a href="system_log2018.jsp?type=1" class="btn btn-outline-info list_draft">采集</a>
		  <a href="#" class="btn btn-outline-info btn-search" onClick="openSearch();">检索</a>      
        </div><!-- btn-group -->
		<div class="btn-group mg-l-auto hidden-xs-down">
			<a href="javascript:;" class="btn btn-outline-info" onClick="clearItems();">清空日志</a> 
		</div><!-- btn-group -->
<%
PublishScheme pt = new PublishScheme();
//String ListSql = "select * from tidecms_system_log order by id desc";
//String CountSql = "select count(*) from tidecms_system_log";

String ListSql = "select * from tidecms_system_log where 1=1";
String CountSql = "select count(*) from tidecms_system_log where 1=1";
if(type>0)
{
	ListSql +=" and SourceType = "+ type ;
	CountSql +=" and SourceType = "+ type ;
}
if(!S_Title.equals(""))
{
	 ListSql +=" and content like '%"+S_Title+"%'";
	 CountSql +=" and content like '%"+S_Title+"%'";
}
ListSql +=" order by id desc";

ResultSet Rs = pt.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = pt.pagecontrol.getMaxPages();
%>		
		 <div class="btn-group mg-l-10 hidden-sm-down">
					 <%if(currPage>1){%>
					 <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
					 <%}%>
					 <%if(currPage<TotalPageNumber){%>
					 <a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
					 <%}%>
		</div>
    </div>
	  <!--搜索-->
     <div class="search-box pd-x-20 pd-sm-x-30" id="SearchArea" style="display:none;">
		<div class="search-content bg-white">
			<form name="search_form" action="system_log2018.jsp?rowsPerPage=<%=rowsPerPage%>" method="post" onsubmit="return check()">
      		<div class="row">
				<!--标题-->
				<div class="mg-r-20 mg-b-40 search-item">
                             	 <input class="form-control search-title" placeholder="内容" type="text" name="S_Title" size="10" value="<%=S_Title%>">                                
				</div>			
				<div class="search-item mg-b-30">
					<input type="submit" name="Submit" value="查找" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
				</div>
			</div><!-- row -->
			</form>
      	</div>
     </div><!--搜索-->	
	 
<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">

				<thead>
				  <tr>				
					<th class="tx-12-force tx-mont tx-medium">编号</th>				
					<%if(type==0){%>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">来源</th>
                    <%}%>					
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">详细信息</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">日期</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">操作</th>							
				  </tr>
				</thead>
				<tbody>
<%
int TotalNumber = pt.pagecontrol.getRowsCount();
if(pt.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				int  sourceType			=Rs.getInt("SourceType");
				String Content		= convertNull(Rs.getString("Content"));
				String CreateDate	= convertNull(Rs.getString("CreateDate"));
				int id				= Rs.getInt("id");
				String source = Rs.getString("Source");
				//LogAction.getSourceDesc(sourceType)
				j++;
%>
		<tr>
			<td class="valign-middle">
			  <label class="ckbox mg-b-0">
				<%=j%>
			  </label>
			</td>
			<%if(type==0){%>
			<td class="hidden-xs-down"><%=source%> </td>	
			<%}%>
			<td class="hidden-xs-down"><%=Util.convertNewlines(Content)%></td>
			<td class="hidden-xs-down"><%=CreateDate%></td>			
            <!--  <td class="hidden-xs-down"><a href="system_log2018.jsp?Action=Del&id=<%=id%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td> -->			
		  <td class="hidden-xs-down"><a href="#" class="btn btn-info btn-sm tx-13" onclick="del('<%=id%>')">删除</a></td> 
		</tr>
<%
			}		
}
pt.closeRs(Rs);
%>		
</tbody>
</table>			
		<!--分页-->
			<div id="tide_content_tfoot">	
          		<span class="mg-r-20 ">共<%=TotalNumber%>条</span>
          		<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

				<%if(TotalPageNumber>1){%><%}%>
				<div class="jump_page ">
          			<span class="">跳至:</span>
          			<label class="wd-60 mg-b-0">
						<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
					</label>
					<span class="">页</span>
					<a id="goToId" href="javascript:;" class="tx-14">Go</a>
				</div>
          		<div class="each-page-num mg-l-auto ">
          			<span class="">每页显示:</span>
                     
          			<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="状态" onChange="change(this);" id="rowsPerPage">
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
			</div><!--分页-->
			</div>
	 </div><!--列表-->
	 <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
        <div class="btn-group hidden-xs-down">
          <a href="system_log2018.jsp" class="btn btn-outline-info list_all">全部</a>
		  <a href="system_log2018.jsp?type=1" class="btn btn-outline-info list_draft">采集</a>
		  <a href="#" class="btn btn-outline-info btn-search" onClick="openSearch();">检索</a>      
        </div><!-- btn-group -->
		<div class="btn-group mg-l-auto hidden-xs-down">
			<a href="javascript:;" class="btn btn-outline-info" onClick="clearItems();">清空日志</a> 
		</div><!-- btn-group -->
		 <div class="btn-group mg-l-10 hidden-sm-down">
							      <%if(currPage>1){%>
					                <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
					              <%}%>
								  <%if(currPage<TotalPageNumber){%>
									<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
							      <%}%>
		</div>
    </div>
	</div>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<!--<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>-->
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>

<script type="text/javascript">
//设置高亮
						var type = <%=type%>;
					
						$(function() {

							if (type == 1) {

								$(".list_draft").addClass("active");

							} else {
								$(".list_all").addClass("active");
							}
						});

function change(obj)
{
		if(obj!=null)		this.location="system_log2018.jsp?rowsPerPage="+ obj.value +"<%=querystring%>";
}


jQuery(document).ready(function(){
	jQuery("#rowsPerPage").val('<%=rowsPerPage%>');

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
		var href="system_log2018.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		document.location.href=href;
	});

});
</script>
</body></html>
