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
String searchTitle="publish_task2.jsp?rowsPerPage="+rowsPerPage+queryString1;
String endSearch="publish_task2.jsp?rowsPerPage="+rowsPerPage+queryString1;
if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	String Sql = "delete from publish_item where Status=1 and id=" + id;

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("publish_task2.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage+queryString);return;
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

	response.sendRedirect("publish_task2.jsp?a=a"+queryString);return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script language="javascript">
function change(obj)
{
	if(obj!=null)
		this.location = "publish_task2.jsp?rowsPerPage="+obj.value+"<%=queryString%>";
}

function ClearItems()
{
	if(confirm("确实要清空所有待发布记录吗？")) 
	{
		this.location = "publish_task2.jsp?Action=Clear<%=queryString%>";
	}
}

function MM_jumpMenu(obj){ //v3.0
	if(obj!=null)
	{
		if(document.getElementById("rowsPerPage")!=null)
			this.location = "publish_task2.jsp?Scheme=" + obj.value+"&rowsPerPage="+document.getElementById("rowsPerPage").value+"&SiteId=<%=SiteId%>";
		else
			this.location = "publish_task2.jsp?Scheme=" + obj.value+"&SiteId=<%=SiteId%>";
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
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>
<body>
<div class="content_t1">
    <div class="content_new_post">
    	<a href="javascript:openSearch();" class="first">检索</a>
		<a href="javascript:ClearItems();" class="second">清空</a>
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
    <td width="20">&nbsp;</td>
    <td>检索：文件名<input name="S_Title"  id="S_Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
    <input type="button" name="button" class="tidecms_btn3" value="查找" onclick="search_submit()"></td>
    <td width="20">&nbsp;</td>
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
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle">编号</th>
    				<th class="v3" style="padding-left:10px;text-align:left;">频道</th>
					<th>目录</th>
					<th>类型</th>
					<th>文档</th>
					<th class="v1"	align="center" valign="middle">入队列时间</th>
					<th class="v1"	align="center" valign="middle">开始发布时间</th>
					<th class="v1"	align="center" valign="middle">结束发布时间</th>
					<th class="v1"	align="center" valign="middle">发布用时(毫秒)</th>
    				<th class="v9" width="55" align="center" valign="middle">>></th>
  				</tr>
</thead>
 <tbody> 
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
    <td class="v1" width="25" align="center" valign="middle"><%=j%></td>
    <td class="v3" style="font-weight:700;"><%=channel_desc%></td>
	<td><%=channel_path%></td>
	<td></td>
	<td><%=PublishType%></td>
    <td class="v4"  style="color:#666666;"><%=CreateDate%></td>
    <td class="v4"  style="color:#666666;"><%=PublishBegin%></td>
    <td class="v4"  style="color:#666666;"><%=PublishEnd%></td>
	<td><%=usetime%></td>
	<td class="v9"><a href="publish_task2.jsp?Action=Del&id=<%=id%><%=queryString%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td>
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
            <div class="center"><a href="publish_task2.jsp?currPage=1&rowsPerPage=<%=rowsPerPage%><%=queryString%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="publish_task2.jsp?currPage=<%=currPage-1%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="publish_task2.jsp?currPage=<%=currPage+1%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="publish_task2.jsp?currPage=<%=TotalPageNumber%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
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
		if(obj!=null)		this.location="publish_task2.jsp?rowsPerPage="+obj.value+"<%=queryString%>";
	}

	function sort_select(obj){	

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
		var href="publish_task2.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=queryString%>";
		document.location.href=href;
	});

});
</script>
</body></html>