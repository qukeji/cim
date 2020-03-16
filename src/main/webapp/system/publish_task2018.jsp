<%@ page import="java.sql.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{out.close();return;}
long begin_time = System.currentTimeMillis();
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int Scheme = getIntParameter(request,"Scheme");
int SiteId=getIntParameter(request,"SiteId");
String S_Title=Util.getParameter(request,"S_Title");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 50;
	
String queryString="&SiteId="+SiteId+"&Scheme="+Scheme+"&S_Title="+S_Title;
String queryString1="&SiteId="+SiteId+"&Scheme="+Scheme;
String Action = getParameter(request,"Action");
String searchTitle="publish_task2018.jsp?rowsPerPage="+rowsPerPage+queryString1;
String endSearch="publish_task2018.jsp?rowsPerPage="+rowsPerPage+queryString1;
if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	String Sql = "delete from publish_item where Status=1 and id=" + id;

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("publish_task2018.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage+queryString);return;
}
else if(Action.equals("Clear"))
{
	//String Sql = "delete from publish_item where Status=1";
	String Sql ="DELETE FROM publish_item USING publish_item,publish_scheme WHERE publish_item.PublishScheme=publish_scheme.id ";
	Sql+=" and publish_item.Status=1";
	if(SiteId>0){
	Sql+=" and publish_scheme.site="+SiteId;
	}
	if(Scheme>0){
	Sql+=" and publish_item.PublishScheme="+Scheme;
	}
	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("publish_task2018.jsp?a=a"+queryString);return;
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
<script src="../common/2018/common2018.js"></script>
<!-- <script type="text/javascript" src="../common/jquery.contextmenu.js"></script> -->
<script language="javascript">
function change(obj)
{
	if(obj!=null)
		this.location = "publish_task2018.jsp?rowsPerPage="+obj.value+"<%=queryString%>";
}

function ClearItems()
{
	if(confirm("确实要清空所有待发布记录吗？")) 
	{
		this.location = "publish_task2018.jsp?Action=Clear<%=queryString%>";
	}
}

function MM_jumpMenu(obj){ //v3.0
	if(obj!=null)
	{
		if(document.getElementById("rowsPerPage")!=null)
			this.location = "publish_task2018.jsp?Scheme=" + obj.value+"&rowsPerPage="+document.getElementById("rowsPerPage").value+"&SiteId=<%=SiteId%>";
		else
			this.location = "publish_task2018.jsp?Scheme=" + obj.value+"&SiteId=<%=SiteId%>";
	}
}

function openSearch(obj)
{
var SearchArea=document.getElementById("SearchArea");
	if(SearchArea.style.display == "none")
	{
		SearchArea.style.display = "";
	}
	else
	{
	   SearchArea.style.display = "none";
       this.location="<%=endSearch%>";
	}
}
function search_submit(){
var S_Title=document.getElementById("S_Title").value;
this.location="<%=searchTitle%>&S_Title="+S_Title;
}

function  del()
{
	//
}
</script>

</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
       
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
        <div class="btn-group hidden-xs-down">
          <a href="../system/manager2018.jsp" class="btn btn-outline-info list_all">返回</a>
		  <a href="javascript:openSearch();" class="btn btn-outline-info list_draft">检索</a>
		      
        </div><!-- btn-group -->
		<div class="btn-group mg-l-auto hidden-xs-down">
			<a href="javascript:ClearItems();" class="btn btn-outline-info" >清空日志</a> 
		</div><!-- btn-group -->	
<%			//System.out.println("list begin....");
TableUtil tu = new TableUtil();


String ListSql = "select id,ChannelID,ItemID,User,CreateDate,PublishType,FROM_UNIXTIME(PublishBegin/1000,'%m-%d %H:%i:%s') as PublishBegin,FROM_UNIXTIME(PublishEnd/1000,'%m-%d %H:%i:%s') as PublishEnd,PublishEnd-PublishBegin as usetime from publish_task where Status=0 ";
String CountSql = "select count(*) from publish_task  where Status=0";

if(!S_Title.trim().equals("")){
	ListSql+=" and FileName like '%"+S_Title+"%'";
	CountSql += " and FileName like '%"+S_Title+"%'";
}	
ListSql += " order by id desc ";

ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
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
      		<div class="row">
				<!--标题-->
				<div class="mg-r-20 mg-b-40 search-item">
                    <input class="form-control search-title" size="18" placeholder="文件名" type="text" name="S_Title"  id="S_Title"  value="<%=S_Title%>">                                
				</div>			
				<div class="search-item mg-b-30">
					<input type="button" name="button" value="查找" onclick="search_submit()" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
				</div>
			</div><!-- row -->			
      	</div>
     </div><!--搜索-->	
	 
<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">
				<thead>
				  <tr>	
              			 
					<th class="tx-12-force tx-mont tx-medium">编号</th>								
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">频道</th>                   					
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">目录</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">类型</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">文档</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">入队列时间</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">开始发布时间</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">结束发布时间</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">发布用时(毫秒)</th>	
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">操作</th>	
				  </tr>
				</thead>
				<tbody>
<%
int TotalNumber = tu.pagecontrol.getRowsCount();
if(tu.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				String Name = "";
				String FileName = "";
				String CreateDate = convertNull(Rs.getString("CreateDate"));
				String PublishBegin = convertNull(Rs.getString("PublishBegin"));
				String PublishEnd = convertNull(Rs.getString("PublishEnd"));
				int usetime = Rs.getInt("usetime");
				int ChannelID = Rs.getInt("ChannelID");
				int ItemID = Rs.getInt("ItemID");
				int User = Rs.getInt("User");
				int id = Rs.getInt("id");
				int PublishType = Rs.getInt("PublishType");

				String channel_desc = "";
				String channel_path = "";
				Channel c_ = CmsCache.getChannel(ChannelID);
				if(c_!=null)
				{
					channel_desc = c_.getParentChannelPath();
					channel_path = c_.getFullPath();
				}
				j++;
%>
		<tr>		
			<td class="hidden-xs-down"><%=j%></td>			
			<td class="hidden-xs-down"><%=channel_desc%></td>
			<td class="hidden-xs-down"><%=channel_path%></td>	
<td class="hidden-xs-down"><%=PublishType%></td>	
<td class="hidden-xs-down"><%=CreateDate%></td>	
<td class="hidden-xs-down"><%=PublishBegin%></td>	

<td class="hidden-xs-down"><%=PublishEnd%></td>	

<td class="hidden-xs-down"><%=usetime%></td>
		  <td class="hidden-xs-down">
		  <a href="#" class="btn btn-danger btn-sm tx-13" onclick="del(<%=id%>,'<%=queryString%>')">删除</a></td>			
            <!--  <a href="publish_task2.jsp?Action=Del&id=<%=id%><%=queryString%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td> -->			
		</tr>
<%
			}
}

tu.closeRs(Rs);
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

function change(obj)
{
		if(obj!=null)		this.location="publish_task2018.jsp?rowsPerPage="+ obj.value +"<%=queryString%>";
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
		var href="publish_task2018.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=queryString%>";
		document.location.href=href;
	});

});
</script>
</body></html>
