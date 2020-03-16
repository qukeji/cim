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
String searchTitle="publish_task.jsp?rowsPerPage="+rowsPerPage+queryString1;
String endSearch="publish_task.jsp?rowsPerPage="+rowsPerPage+queryString1;
if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	String Sql = "delete from publish_task where Status!=0 and id=" + id;

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("publish_task.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage+queryString);return;
}
else if(Action.equals("Clear"))
{
	//String Sql = "delete from publish_item where Status=1";
	
	String Sql ="DELETE FROM publish_task where status= "+Status+" ";
	TableUtil tu = new TableUtil();
	if(Status!=1){
		tu.executeUpdate(Sql);
	}

	response.sendRedirect("publish_task.jsp?a=a"+queryString);return;
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
			response.sendRedirect("publish_task.jsp?a=a"+queryString);return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>

<script language="javascript">
$(document).ready(function() {
	tidecms.setDatePicker("#startDate");
	tidecms.setDatePicker("#endDate");
});
function change(obj)
{
	if(obj!=null)
		this.location = "publish_task.jsp?rowsPerPage="+obj.value+"<%=queryString%>";
}

function ClearItems()
{
	if(confirm("确实要清空所有待发布记录吗？")) 
	{
		this.location = "publish_task.jsp?Action=Clear<%=queryString%>";
	}
}

function FreshItems()
{
	//window.location.reload();
	this.location="publish_task.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>";
}

function MM_jumpMenu(obj){ //v3.0
	if(obj!=null)
	{
		if(document.getElementById("rowsPerPage")!=null)
			this.location = "publish_task.jsp?Scheme=" + obj.value+"&rowsPerPage="+document.getElementById("rowsPerPage").value+"&SiteId=<%=SiteId%>";
		else
			this.location = "publish_task.jsp?Scheme=" + obj.value+"&SiteId=<%=SiteId%>";
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


function again_publish_all(status)
{
	var message='';
	if(status==1){
		message="已发布记录禁止再次重新发布!";
	}else if(status==2){
	    message="确定要重新发布全部正在发布的记录吗？"; 	
	}else if(status==0){
		  message="确定要重新发布全部等待发布的记录吗？"; 	
	}
	
	if(status!=1){
            if(confirm(message)) 
			{
	           this.location = "../publish/publish_task.jsp?Action=PublishAgain" ;
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
	       this.location = "../publish/publish_task.jsp?Action=Publish&ids=" + obj.id +"<%=queryString%>" ;
		
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
	dialog.setUrl("publish/publish_task_details.jsp?id=" + id);
	dialog.setTitle("错误信息");
	dialog.show();
}
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>
<body>
<div class="content_t1">
    <div class="content_new_post">
    	<a href="javascript:openSearch();" class="first">检索</a>
		<a href="javascript:ClearItems();" class="second">全部删除</a>
		<a href="javascript:FreshItems();" class="second">刷新</a>
    </div>
</div>
<div class="viewpane_c1" id="SearchArea"  style="display:<%=(!S_Title.trim().equals("")?"":"none")%>">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
    <table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20"> </td>
    <td>
		检索：<!--文件名<input name="S_Title"  id="S_Title" type="text" size="18" class="textfield" value="<%=S_Title%>">-->
		开始时间
		<input id="startDate" name="startDate" type="text" size="10"  class="textfield" value="<%=S_startDate%>">
		结束时间
		<input id="endDate" name="endDate" type="text" size="10"  class="textfield" value="<%=S_endDate%>">
		<input type="button" name="button" class="tidecms_btn3" value="查找" onclick="search_submit()">
		<input type="button" name="button" class="tidecms_btn3" value="当天" onclick="search_list(1)">
		<input type="button" name="button" class="tidecms_btn3" value="昨天" onclick="search_list(2)"></td>
    <td width="20"> </td>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content">
	<%if(Status==2){%>
	<div class="toolbar">
		<div class="toolbar_l">
			<span class="toolbar1">操作：</span>
			<ul class="toolbar2">				
				<li class="first"><a href="javascript:again_publish();">重新发布</a></li>
				<li class="first"><a href="javascript:again_publish_all();">全部重新发布</a></li>
			</ul>
		 </div>
	</div>
	<%}%>
  	<div class="viewpane">
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
		            <%if(Status==2){%>
					<th class="v1" width="25" align="center" valign="middle">  </th>
					<%}%>
    				<th class="v1" width="25" align="center" valign="middle">编号</th>
    				<th class="v3" style="padding-left:10px;text-align:left;">频道</th>
					<th>类型</th>
					<th>文档</th>
					<th class="v1"	align="center" valign="middle">入队列</th>
					<th class="v1"	align="center" valign="middle">可以发布</th>
					<th class="v1"	align="center" valign="middle">开始发布</th>
					<th class="v1"	align="center" valign="middle">结束发布</th>
					<th class="v1"	align="center" valign="middle"><a href="javascript:SortItems('<%=type%>');" >发布用时</a></th>
    				<th class="v9" width="55" align="center" valign="middle">>></th>
  				</tr>
</thead>
 <tbody> 
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
	<td class="v1" width="25" align="center" valign="middle"><span><input name="id" value="<%=id%>" type="checkbox"/></span></td>
	<%}%>
	<td class="v1" width="25" align="center" valign="middle"><%=j%></td>
    <td class="v3" style="font-weight:700;"><%=channel_desc%></td>
	<td><%=PublishType_%></td>
	<td></td>
    <td class="v4"  style="color:#666666;"><%=CreateDate%></td>	
	<td><%=CanPublishTime%></td>
    <td class="v4"  style="color:#666666;"><%=PublishBegin%></td>
    <td class="v4"  style="color:#666666;"><%=PublishEnd%></td>
	<td><%if(usetime<1000){%>
	   <%=usetime%>毫秒
	   <%}else if(usetime>60000){%>
	   <%=String .format("%.1f",(double)usetime*1.00/60000)%>分钟
	   <%}else{%>
	   <%=usetime*1.00/1000%>秒
	   <%}%>
	</td>
	<td class="v9"><div class="v9_button" onclick="Details(<%=id%>);"><img src="../images/v9_button_2.gif" title="查看信息" /></div><a href="publish_task.jsp?Action=Del&id=<%=id%><%=queryString%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td>
  </tr>
<%
			}
}

tu.closeRs(Rs);
%>
  
 </tbody> 
</table> 
        </div>
        <div class="viewpane_pages">
        	<div class="select"></div>
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="publish_task.jsp?currPage=1&rowsPerPage=<%=rowsPerPage%><%=queryString%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="publish_task.jsp?currPage=<%=currPage-1%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="publish_task.jsp?currPage=<%=currPage+1%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="publish_task.jsp?currPage=<%=TotalPageNumber%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}%>
            <div class="right">
            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="rowsPerPage" onChange="change(this);" id="rowsPerPage">
                  <option value="10">10</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                    <option value="25">25</option>
                    <option value="30">30</option>
                    <option value="50">50</option>
                    <option value="80">80</option>
                    <option value="100">100</option>
                  </select>
                </div>
                </div>
            	<div style="float:left;">条</div>
            </div>
        </div>
  </div>
 
</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
 
<script type="text/javascript"> 	
	function change(obj)
	{
		if(obj!=null)		this.location="publish_task.jsp?rowsPerPage="+obj.value+"<%=queryString%>";
	}

	function sort_select(obj){	

	}
	
	function SortItems(type)
	{
	 if(type==0){
	   this.location="publish_task.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=1";
	 }else if(type==1){
	   this.location="publish_task.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=2";
	 }else{
	   this.location="publish_task.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=0";
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
		var href="publish_task.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=queryString%>";
		document.location.href=href;
	});

});
</script>
</body></html>
