<%@ page import="java.sql.*,
				java.util.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
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
int type=getIntParameter(request,"type");
//System.out.println(type+"接收的参数");

String ids=getParameter(request,"ids");

int Status = getIntParameter(request,"Status");

String S_Title=Util.getParameter(request,"S_Title");
//String S_CreateDate		=	getParameter(request,"CreateDate");
//String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_startDate		=	getParameter(request,"startDate");
String S_endDate		=	getParameter(request,"endDate");
int S_type			=   getIntParameter(request,"type_");
//获取当前日期
Calendar calendar = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
String nowDate = sdf.format(calendar.getTime());
if(S_type==1){
	calendar.add(Calendar.DATE, +1);
	String  date = sdf.format(calendar.getTime());

	S_startDate = 	nowDate ;
	S_endDate = date;
}else if(S_type==2){
	calendar.add(Calendar.DATE, -1);
	String  date = sdf.format(calendar.getTime());

	S_startDate = 	date ;
	S_endDate = nowDate;
}


if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 50;
	
String queryString="&SiteId="+SiteId+"&Scheme="+Scheme+"&S_Title="+S_Title+"&Status="+Status+"&startDate="+S_startDate+"&endDate="+S_endDate;
//System.out.println("queryString:"+queryString);

String queryString1="&SiteId="+SiteId+"&Scheme="+Scheme+"&Status="+Status+"&type="+type;
//System.out.println("queryString1:"+queryString1);

String Action = getParameter(request,"Action");
String searchTitle="publish_task2018.jsp?rowsPerPage="+rowsPerPage+queryString1;
String endSearch="publish_task2018.jsp?rowsPerPage="+rowsPerPage+queryString1;
if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	String Sql = "delete from publish_task where Status!=0 and id=" + id;

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("publish_task2018.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage+queryString);return;
}
else if(Action.equals("Clear"))
{
	//String Sql = "delete from publish_item where Status=1";
	
	String Sql ="DELETE FROM publish_task where status= "+Status+" ";
	TableUtil tu = new TableUtil();
	if(Status!=1){
		tu.executeUpdate(Sql);
	}

	response.sendRedirect("publish_task2018.jsp?a=a"+queryString);return;
}else if(Action.equals("Publish")){
	  String []ids_group=ids.split(",");
      for(String id:ids_group){
			String Sql ="update publish_task set status=0 where id="+id;
			TableUtil tu = new TableUtil();
			tu.executeUpdate(Sql);
	  }
		
}else if(Action.equals("PublishAgain")){
	        String Sql ="update publish_task set status=0 where status=2 ";
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

var Status = <%=Status%>;

function gopage(currpage) {
	var url = "publish_task2018.jsp?currPage="+currpage+"&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>";
	this.location = url;
}

$(document).ready(function() {
	tidecms.setDatePicker("#startDate");
	tidecms.setDatePicker("#endDate");
});
function change(obj)
{
	if(obj!=null)
		this.location = "publish_task2018.jsp?rowsPerPage="+obj.value+"<%=queryString%>";
}

function ClearItems()
{
	var msg = "确实要清空所有待发布记录吗？";
	if(Status==1){
		msg = "确实要清空所有已发布记录吗？";
	}else if(Status==2){
		msg = "确实要清空所有正在发布的记录吗？";
	}

	if(confirm(msg)) 
	{
		this.location = "publish_task2018.jsp?Action=Clear<%=queryString%>";
	}
}

function FreshItems()
{
	//window.location.reload();
	this.location="publish_task2018.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>";
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


function again_publish_all()
{
	var message='确定要重新发布全部等待发布的记录吗？';
	if(Status==1){
		message="已发布记录禁止再次重新发布!";
	}else if(Status==2){
	    message="确定要重新发布全部正在发布的记录吗？"; 	
	}
	
	if(Status!=1){
            if(confirm(message)) 
			{
	           this.location = "../publish/publish_task2018.jsp?Action=PublishAgain<%=queryString%>" ;
			}
	}else{
		alert(message);
	}
		   
		
}

function again_publish(id)
{
               var obj=getCheckbox();
			    if(obj.length==0){
				alert("请先选择要发布文档！");
			return;
			}
	       this.location = "../publish/publish_task2018.jsp?Action=Publish&ids=" + obj.id +"<%=queryString%>" ;
		
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
//       this.location="<%=endSearch%>";
	}
}
function search_submit(){
	//var S_Title=document.getElementById("S_Title").value;
	var startDate=document.getElementById("startDate").value;
	var endDate=document.getElementById("endDate").value;

	this.location="<%=searchTitle%>&startDate="+startDate+"&endDate="+endDate;
}
function search_list(type){
	this.location="<%=searchTitle%>&type_="+type;
}

function Details(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(340);
	dialog.setScroll("auto");
	dialog.setUrl("publish/publish_task_details2018.jsp?id=" + id);
	dialog.setTitle("错误信息");
	dialog.show();
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
		  <%if(Status==2){%>
		  <a href="javascript:again_publish();" class="btn btn-outline-info list_draft">重新发布</a>
		  <a href="javascript:again_publish_all();" class="btn btn-outline-info list_draft">全部重新发布</a>
          <%}%>		  
			<a href="javascript:ClearItems();" class="btn btn-outline-info list_draft">全部删除</a>
		  <a href="javascript:FreshItems();" class="btn btn-outline-info list_draft">刷新</a> 
		</div><!-- btn-group -->	
<%			//System.out.println("list begin....");
TableUtil tu = new TableUtil();


String ListSql = "select id,ChannelID,ItemID,User,CreateDate,PublishType,FROM_UNIXTIME(PublishBegin/1000,'%m-%d %H:%i:%s') as PublishBegin,FROM_UNIXTIME(PublishEnd/1000,'%m-%d %H:%i:%s') as PublishEnd,FROM_UNIXTIME(CanPublishTime,'%m-%d %H:%i:%s') as CanPublishTime,PublishEnd-PublishBegin as usetime,ChannelTemplateID from publish_task where Status=" + Status;
String CountSql = "select count(*) from publish_task  where Status="+Status;

if(!S_Title.trim().equals("")){
	ListSql+=" and FileName like '%"+S_Title+"%'";
	CountSql += " and FileName like '%"+S_Title+"%'";
}
if(!S_startDate.equals("")){
	long fromTime	=Util.getFromTime(S_startDate,"");
	ListSql += " and UNIX_TIMESTAMP(CreateDate)>="+fromTime;
	CountSql += " and UNIX_TIMESTAMP(CreateDate)>="+fromTime;
}
if(!S_endDate.equals("")){
	long fromTime1	=Util.getFromTime(S_endDate,"");
	ListSql += " and UNIX_TIMESTAMP(CreateDate)<"+fromTime1;
	CountSql += " and UNIX_TIMESTAMP(CreateDate)<"+fromTime1;
}

if(type==2){
	ListSql += " order by usetime asc ";
}else if(type==1){
	ListSql += " order by usetime desc ";
}else{
	ListSql += " order by id desc ";
}
//System.out.println(type+"");
//System.out.println(ListSql);

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
				<!--
				<div class="mg-r-20 mg-b-40 search-item">
                    <input class="form-control search-title" size="18" placeholder="文件名" type="text" name="S_Title"  id="S_Title"  value="<%=S_Title%>">                                
				</div>	标题-->
                 <div class="wd-200 mg-b-30 mg-r-10 search-item">
                            <div class="input-group">
                                <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" id="startDate" name="startDate" value="<%=S_startDate%>" size="10">
                            </div>
                  </div>
                  <div class="wd-200 mg-b-30 mg-r-10 search-item">
                            <div class="input-group">
                                <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" id="endDate" name="endDate" size="12" value="<%=S_endDate%>"/>
                            </div>
                   </div>				  
				<div class="search-item mg-b-30 mg-r-10">
					<input type="button" name="button" value="查找" onclick="search_submit()" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
				</div>
				<div class="search-item mg-b-30 mg-r-10">
					<input type="button" name="button" value="当天" onclick="search_list(1)" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
				</div>
				<div class="search-item mg-b-30 mg-r-10">
					<input type="button" name="button" value="昨天" onclick="search_list(2)" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
				</div>
			</div><!-- row -->			
      	</div>
     </div><!--搜索-->	
	 
<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">
				<thead>
				  <tr>
				  <%if(Status==2){%>
                    <th class="wd-5p">
						<label class="ckbox mg-b-0">
							<input type="checkbox" id="checkAll"><span></span>
						</label>
					</th>
                   <%}%>					
					<th class="tx-12-force tx-mont tx-medium">编号</th>								
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">频道</th>                   					
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">类型</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">文档</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">入队列</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">可以发布</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">开始发布</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">结束发布</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down"><a href="javascript:SortItems('<%=type%>');" >发布用时</a></th>	
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
				String CanPublishTime = convertNull(Rs.getString("CanPublishTime"));
				int usetime = Rs.getInt("usetime");
				int ChannelID = Rs.getInt("ChannelID");
				int ItemID = Rs.getInt("ItemID");
				int User = Rs.getInt("User");
				int id = Rs.getInt("id");
				int PublishType = Rs.getInt("PublishType");
				int ChannelTemplateID = Rs.getInt("ChannelTemplateID");

				String PublishType_ = "";
				if(PublishType==0) PublishType_ = "文件发布";
				if(PublishType==1) 
				{
					PublishType_ = "频道发布";
					if(ChannelTemplateID>0)
					{
						PublishType_ += "(" + ChannelUtil.getChannelTemplate(ChannelID,ChannelTemplateID).getTargetName() + ")";
					}
				}
				if(PublishType==2) PublishType_ = "审核文档后发布";
				if(PublishType==3) PublishType_ = "编辑文档后发布";
				if(PublishType==4) PublishType_ = "排序文档后发布";
				if(PublishType==5) PublishType_ = "删除文档后发布";
				if(PublishType==6) PublishType_ = "只发布附加模板";
				if(PublishType==7) PublishType_ = "只发布指定模板";
				if(PublishType==8) PublishType_ = "只发布指定文档";
				if(PublishType==9) PublishType_ = "没有内容页的频道发布";

				String channel_desc = "";
				Channel c_ = CmsCache.getChannel(ChannelID);
				if(c_!=null)
				{
					channel_desc = c_.getParentChannelPath();
				}
				j++;
%>
		<tr>	
           <%if(Status==2){%>
		    <td class="valign-middle">
              <label class="ckbox mg-b-0">
				<input type="checkbox" name="id" value="<%=id%>"><span></span>
			  </label>
            </td>
           <%}%>		   
			<td class="hidden-xs-down"><%=j%></td>			
			<td class="hidden-xs-down"><%=channel_desc%></td>
			<td class="hidden-xs-down"></td>	
			<td class="hidden-xs-down"><%=PublishType_%></td>	
            <td class="hidden-xs-down"><%=CreateDate%></td>	
            <td class="hidden-xs-down"><%=CanPublishTime%></td>	
            <td class="hidden-xs-down"><%=PublishBegin%></td>	
            <td class="hidden-xs-down"><%=PublishEnd%></td>	
            <td class="hidden-xs-down">
          <%if(usetime<1000){%>
	          <%=usetime%>毫秒
	          <%}else if(usetime>60000){%>
	          <%=String .format("%.1f",(double)usetime*1.00/60000)%>分钟
	          <%}else{%>
			   <%=usetime*1.00/1000%>秒
			   <%}%>
           </td>
		  <td class="hidden-xs-down">
         <!-- <a href="#" class="btn btn-info btn-sm tx-13" onclick="Details(<%=id%>);">查看信息</a>  -->
		  <a href="publish_task2018.jsp?Action=Del&id=<%=id%><%=queryString%>" class="btn btn-danger btn-sm tx-13" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td>			
          	
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
			     <%if(Status==2){%>
				 <label class="ckbox mg-b-0 mg-r-30 ">
					<input type="checkbox" id="checkAll_1"><span></span>
				</label> 
				 <%}%>
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
						<option value="10" <%if(rowsPerPage == 10){%> selected<%}%> >10</option>
						<option value="15" <%if(rowsPerPage == 15){%> selected<%}%> >15</option>
						<option value="20" <%if(rowsPerPage == 20){%> selected<%}%> >20</option>
						<option value="25" <%if(rowsPerPage == 25){%> selected<%}%> >25</option>
						<option value="30" <%if(rowsPerPage == 30){%> selected<%}%> >30</option>
						<option value="50" <%if(rowsPerPage == 50){%> selected<%}%> >50</option>
						<option value="80" <%if(rowsPerPage == 80){%> selected<%}%> >80</option>
						<option value="100" <%if(rowsPerPage == 100){%> selected<%}%> >100</option>
					</select>       
				<span class="">条</span>
          		</div>
			</div><!--分页-->
			</div>
	 </div><!--列表-->
	 <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
        <div class="btn-group hidden-xs-down">
          <a href="../system/manager2018.jsp" class="btn btn-outline-info list_all">返回</a>
		  <a href="javascript:openSearch();" class="btn btn-outline-info list_draft">检索</a>		  
        </div><!-- btn-group -->
		<div class="btn-group mg-l-auto hidden-xs-down">
		 <%if(Status==2){%>
		  <a href="javascript:again_publish();" class="btn btn-outline-info list_draft">重新发布</a>
		  <a href="javascript:again_publish_all();" class="btn btn-outline-info list_draft">全部重新发布</a>
          <%}%>		
			<a href="javascript:ClearItems();" class="btn btn-outline-info list_draft">全部删除</a>
		  <a href="javascript:FreshItems();" class="btn btn-outline-info list_draft">刷新</a> 
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
$("#checkAll,#checkAll_1").click(function()
{
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

	function change(obj)
	{
		if(obj!=null)		this.location="publish_task2018.jsp?rowsPerPage="+obj.value+"<%=queryString%>";
	}

	function sort_select(obj){	

	}
	
	function SortItems(type)
	{
	 if(type==0){
	   this.location="publish_task2018.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=1";
	 }else if(type==1){
	   this.location="publish_task2018.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=2";
	 }else{
	   this.location="publish_task2018.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=0";
	 } 
	 
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
//搜索日期鼠标移入弹出  
$('.fc-datepicker').datepicker({
showOtherMonths: true,
selectOtherMonths: true,
dateFormat: "yy-mm-dd"
});
</script>
</body></html>
