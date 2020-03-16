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
	 *
	 *	姓名             日期               备注
	 *
	 *  曲科籍           20140804           修改删除状态(active=0已删除)
	 *
	 */
String domainname = CmsCache.getParameterValue("sns_domainname_address");
String tableprefix = CmsCache.getParameterValue("sns_tableprefix");
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
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
if(listType==0) listType = 1;

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
//String S_Summary		=	getParameter(request,"Summary");
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
querystring = "&Summary="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");return;
}

String SiteAddress = channel.getSite().getUrl();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/tidecms7.css" type="text/css" rel="stylesheet" />
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<script type="text/javascript" src="../common/ui.draggable.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/content.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
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

function Preview22(url){
	window.open(url);
}

function Preview()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要预览的文件！");
		}else if(obj.length>1){
		alert("请选择一个要预览的文件！");
		}else{
		var url = $("#item_" + obj.id).attr("url");
		//var url= $(this).attr("url");
		Preview22(url);
		}
} 

function deleteFile_1(){
	var obj=getCheckbox();
	var message = "确实要删除这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要删除的文件！");
	}else{
		 if(confirm(message)){
			 var url="sns_comment_action.jsp?id=" + obj.id+"&action=1";
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
	var message = "确实要撤销这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要撤销的文档！");
	}else{
		 if(confirm(message)){
			 var url="sns_comment_action.jsp?id=" + obj.id+"&action=3";
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
	 var url= "sns_comment_action.jsp?id=" + id +"&action=2";
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.reload();}   
		}); 
}
function delfile2(id){
	var message = "确实要撤销这1项吗？";
	
	if(!confirm(message)){
			return;
	}


	 delfile(id);	
}
function delfile(id){
	var url= "sns_comment_action.jsp?id=" + id +"&action=3";
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.reload();}   
	}); 
}
function resume22(id){
	var message = "确实要恢复这1项吗？";
	
	if(!confirm(message)){
			return;
	}


	 resume1(id);	
}
function resume1(id){
	var url= "sns_comment_action.jsp?id=" + id +"&action=4";
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.reload();}   
	}); 
}

function double_click()
{
	jQuery("#oTable .tide_item").dblclick(function(){
		var obj=jQuery(":checkbox",jQuery(this));
		var url= $(this).attr("url");
		obj.trigger("click");
		window.open(url);
	});
}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%=channel.getName()%></div>
    <div class="content_new_post">
		<div class="top_button button_inline_block" onClick="openSearch();">
				<div class="top_button_outer button_inline_block">
					<div class="top_button_inner button_inline_block">
						<span class="img"><img src="../images/icon/preview.png" /></span>
						<span class="txt">检索</span>
					</div>
				</div>	
		</div>
		<!-- <div class="top_button button_inline_block" onClick="addDocument();">
				<div class="top_button_outer button_inline_block">
					<div class="top_button_inner button_inline_block">
						<span class="img"><img src="../images/icon/add.png" /></span>
						<span class="txt">新建</span>
					</div>
				</div>
		</div> -->
    </div>
</div>
<div class="viewpane_c1" id="SearchArea" style="display:<%=(S_OpenSearch==1?"":"none")%>">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
    <table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20">&nbsp;</td>
    <td><form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：评论内容
		  <input name="Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
		  评论日期
		  <select name="CreateDate1" >
		    <option value=">" <%=(S_CreateDate1.equals(">")||S_CreateDate1.equals("")?"selected":"")%>>大于</option>
		    <option value="=" <%=(S_CreateDate1.equals("=")?"selected":"")%>>等于</option>
		    <option value="<" <%=(S_CreateDate1.equals("<")?"selected":"")%>>小于</option>
      </select>
		  <input id="CreateDate" name="CreateDate" type="text" size="10"  class="textfield" value="<%=S_CreateDate%>">
		  用户
		  <input name="User" type="text" size="10"  class="textfield" value="<%=S_User%>">
		  状态
		  <select name="Status" >
		    <option value="0" <%=(S_Status==0?"selected":"")%>></option>
		    <option value="2" <%=(S_Status==2?"selected":"")%>>已审核</option>
		    <option value="1" <%=(S_Status==1?"selected":"")%>>未审核</option>
      </select>

    <input type="submit" name="Submit" class="tidecms_btn3" value="查找"><input type="hidden" name="OpenSearch" id="OpenSearch" value="0"></form></td>
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
	<div class="toolbar">
    	<div class="toolbar_l">
        	<span class="toolbar1">显示：</span>
        	<ul class="toolbar3" style="display:none;">
            	<li id="displayOperation">
                	<p><span>全部<img src="../images/toolbar2_list.gif" /></span></p>
                </li>
            </ul>
            <ul class="toolbar2">
                <li class="first"><a href="javascript:list();">全部</a></li>
                <li><a href="javascript:list('Status1=-1');">未审核</a></li>
                <li><a href="javascript:list('Status1=1');">已审核</a></li>
                <li class="last"><a href="javascript:list('IsDelete=1');">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
               <!--<li><a href="#">归档</a></li> -->
                <li  class="first"><a href="javascript:approve();">审核通过</a></li>
            <!--   <li><a href="javascript:Publish();">发布</a></li> -->  
                <li><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:editDocument1();">编辑</a></li>
				 <li><a href="javascript:deleteFile2();">撤销审核</a></li>
				<%if(!channel.getRecommendOut().equals("")){%>	
					<li><a href="javascript:recommendOut();">推荐</a></li>
				<%}%>
				<%if(!channel.getAttribute1().equals("")){%>
				<li><a href="javascript:recommendIn();">引用</a></li>
				<%}%>
					<!--<li><a href="javascript:RefreshItem();">刷新Cache</a></li>-->
					<li class="last"><a href="javascript:deleteFile_1();"><font style="color:red;">删除</font></a></li>
            </ul>
        </div>
        <!-- <ul class="toolbar_r">
        	<li class="<%=listType==1?"b1_cur":"b1"%>" title="文字列表" onClick="changeList(1);"></li>
            <li class="<%=listType==2?"b3_cur":"b3"%>" title="图片平铺" onClick="changeList(2);"></li>
        </ul> -->
    </div>
<div class="viewpane">
<%if(channel.hasRight(userinfo_session,1)){%>
        <div class="<%=listType==2?"viewpane_pic_list":"viewpane_tbdoy"%>">
<table width="100%" border="0" id="oTable" class="view_table comment_list">
<%if(listType==1){%>
<thead>
		<tr id="oTable_th">
    				<th class="v1" width="15" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3">评论</th>
    				<th class="v1" align="center" valign="middle" width="50">状态</th>
    				<th class="v4" align="center" valign="middle" width="100">用户</th>
					<th align="left" valign="middle" width="200">文章</th>
    				<%if(IsComment==1){%>
    				<th class="v7" align="left" valign="middle">评论</th>
    				<%}%>	
    				<%if(IsClick==1){%>
    				<th class="v6" align="center" valign="middle">点击量</th>
    				<%}%>
    				<th class="v9" width="25" align="center" valign="middle">>></th>
  				</tr>
</thead>
<%}%>
 <tbody> 
<%
int S_UserID = 0;
long weightTime = 0;
int IsActive = 1;
if(IsDelete==1) IsActive=0;

if(!S_User.equals("")){
	String sql2="select * from uchome_comment where author='"+S_User+"'";
	TableUtil tu2 = new TableUtil("sns");
	ResultSet Rs2 = tu2.executeQuery(sql2);
	if(Rs2.next()){
		S_UserID=Rs2.getInt("authorid");
	}else{
		S_UserID=0;
	}
}

//System.out.println("time:"+weightTime);
String Table = channel.getTableName();
String ListSql = "select active,title,cid,id,ip,message,FROM_UNIXTIME(dateline) as dateline,url,authorid,status,author from "+tableprefix+"_comment";
String CountSql = "select count(*) from "+tableprefix+"_comment";

//if(!S_User.equals(""))
	//CountSql = "select count(*) from "+Table+" ";

ListSql += " where idtype in ('news','kn2012','cw2012','movie')";
CountSql += " where  idtype in ('news','kn2012','cw2012','movie')";

String WhereSql = "";

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and message like '%" + channel.SQLQuote(tempTitle) + "%'";
}
if(!S_CreateDate.equals("")){
	long fromTime=Util.getFromTime(S_CreateDate,"");
	if(S_CreateDate1.equals("=")){
		WhereSql += " and dateline>="+fromTime;
		WhereSql += " and dateline<"+(fromTime+86400);
	}else{
		WhereSql += " and dateline" + S_CreateDate1+fromTime;
	}
}

if(S_UserID>0)
{
	WhereSql += " and authorid ="+S_UserID;
}

if(S_Status!=0)
	WhereSql += " and status=" + (S_Status-1);

if(Status1!=0)
{
	if(Status1==-1)
		WhereSql += " and status=0";
	else
		WhereSql += " and status=" + Status1;
}

WhereSql += " and Active="+IsActive;

ListSql += WhereSql;
CountSql += WhereSql;


ListSql += " order by dateline desc";

//out.println(ListSql);

int listnum = rowsPerPage;
if(listType==2) listnum = cols*rows;
//System.out.println("ListSql----"+ListSql);
//System.out.println("CountSql----"+CountSql);
TableUtil tu = new TableUtil("sns");
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);

int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;
int m = 0;

while(Rs.next())
{
	int id_ = Rs.getInt("cid");
	int Status = Rs.getInt("status");
	int authorid = Rs.getInt("authorid");
	String message	= convertNull(Rs.getString("message"));
	String title	= convertNull(Rs.getString("title"));
	String url	= convertNull(Rs.getString("url"));
	String IP	= convertNull(Rs.getString("ip"));

	String ModifiedDate	= convertNull(Rs.getString("dateline"));
	ModifiedDate=Util.FormatDate("yyyy-MM-dd HH:mm",ModifiedDate);


	String author	= convertNull(Rs.getString("author"));	
	String StatusDesc = "";
	if(IsDelete!=1){
		if(Status==0)
			StatusDesc = "<font color=red>未审核</font>";
		else if(Status==1)
			StatusDesc = "<font color=green>已审核</font>";
	}else{
		StatusDesc = "<font color=red>已删除</font>";
	}


	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;

	if(listType==1)
	{
%>
  <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"   url="<%=url%>" status="<%=Status%>" id="item_<%=id_%>" class="tide_item">
    <td class="v1" align="center" valign="middle"><input name="id" value="<%=id_%>" type="checkbox"/></td>
    <td class="v3" ondragstart="OnDragStart (event)">
	<div class="comment_date">提交于 <%=ModifiedDate%></div>
    	<p><%=message%></p>
	</td>
	<td class="v1" align="center" valign="middle"><%=StatusDesc%></td>
    
    <td class="v4" style="color:#666666;">
	<a href="<%=domainname%>space.php?uid=<%=authorid%>" target="_blank"><%=author%></a><!-- 这里的链接是用户的sns链接，如http://sns.cutv.com/space.php?uid=<authorid> --><br /><%=IP%>
	</td>
	<td><a href="<%=url%>" target="_blank"><%=title%></a><!-- 这里的链接是被评论文章的链接，如http://www.cutv.com/news/cj/2012-3-20/1332199649493.shtml --></td>
	<td class="v9">
	<% if(IsDelete!=1){
			if(Status==0){%>
				<div class="v9_button" onclick="approve2(<%=id_%>);"><img src="../images/v9_button_1.gif" title="审核通过" /></div>
			<%}else if(Status==1){%>
				<div class="v9_button" onclick="delfile2(<%=id_%>);"><img src="../images/v9_button_6.gif" title="撤销审核" /></div>
			<%}
	}else{%>
		<div class="v9_button" onclick="resume22(<%=id_%>);"><img src="../images/v9_button_3.gif" title="恢复" /></div>
	<%}%>
	<!-- <div class="v9_button" onclick="Preview2(<%=id_%>);"><img src="../images/preview2.gif" title="页面预览" /></div> -->
	</td>
  </tr>
  <%}

}

if(listType==2 && m<cols) out.println("</tr>");

tu.closeRs(Rs);
%>
 </tbody> 
</table>
</div>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
</script>        
<%if(TotalPageNumber>0){%> 
        <div class="viewpane_pages">
        	<div class="select">选择：<span id="selectAll">全部</span><span id="selectNo">无</span>			</div>
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="javascript:gopage(1);" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>);" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>);" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="javascript:gopage(<%=TotalPageNumber%>);" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}%>
            <div class="right">
<%if(listType==1){%>
            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="rowsPerPage" onChange="change('#rowsPerPage','<%=id%>');" id="rowsPerPage">
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
<%}
if(listType==2){%>
            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="rows" onChange="changeRowsCols();" id="rows">
					<option value="3">3</option>
                    <option value="5">5</option>
                    <option value="8">8</option>
                    <option value="10">10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                  </select>
                </div>
                </div>
            	<div style="float:left;">行</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="cols" onChange="changeRowsCols();" id="cols">
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="10">10</option>
                    <option value="16">16</option>
                  </select>
                </div>
                </div>
            	<div style="float:left;">列</div>
<%}%>
            </div>
        </div>
  <%}%>      
  </div>
  
	<div class="toolbar" style="margin:14px 0 0;">
    	<div class="toolbar_l">
        	<span class="toolbar1">显示：</span>
        	<ul class="toolbar3" style="display:none;">
            	<li id="displayOperation">
                	<p><span>全部<img src="../images/toolbar2_list.gif" /></span></p>
                </li>
            </ul>
            <ul class="toolbar2">
                <li class="first"><a href="javascript:list();">全部</a></li>
                <li><a href="javascript:list('Status1=-1');">未审核</a></li>
                <li><a href="javascript:list('Status1=1');">已审核</a></li>
                <li class="last"><a href="javascript:list('IsDelete=1');">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
               <!--<li><a href="#">归档</a></li> -->
                <li  class="first"><a href="javascript:approve();">审核通过</a></li>
            <!--   <li><a href="javascript:Publish();">发布</a></li> -->  
                <li><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:editDocument1();">编辑</a></li>
				<li><a href="javascript:deleteFile2();">撤销审核</a></li>
				<%if(!channel.getRecommendOut().equals("")){%>	
					<li><a href="javascript:recommendOut();">推荐</a></li>
				<%}%>
				<%if(!channel.getAttribute1().equals("")){%>
				<li><a href="javascript:recommendIn();">引用</a></li>
				<%}%>
					<!--<li><a href="javascript:RefreshItem();">刷新Cache</a></li>-->
					<li class="last"><a href="javascript:deleteFile_1();"><font style="color:red;">删除</font></a></li>
            </ul>
        </div>
        <!-- <ul class="toolbar_r">
        	<li class="<%=listType==1?"b1_cur":"b1"%>" title="文字列表" onClick="changeList(1);"></li>
            <li class="<%=listType==2?"b3_cur":"b3"%>" title="图片平铺" onClick="changeList(2);"></li>
        </ul> -->
    </div>

</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
<%}else{%>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:0};
</script> 
<%}%>
<script type="text/javascript">
jQuery(document).ready(function(){

<%if(listType==2){%>
	$("img[type='tide']").each(function(i){
   autoLoadImage(true,120,120,"",$(this));
 });
$("#rows").val(rows);
$("#cols").val(cols);
<%}%>

<%if(S_OpenSearch!=1){%>
	sortable();
	sortableDisable();
	<%if(sortable==1){%>
		sortableEnable();
	<%}%>
<%}%>

var beforeShowFunc = function() {}
var menu = [
  {'<img src="../images/inner_menu_release.gif" title="审核通过"/>审核通过':function(menuItem,menu) {approve();} },
  {'<img src="../images/inner_menu_preview.gif" title="预览"/>预览':function(menuItem,menu) {Preview(); }},
  {'<img src="../images/inner_menu_edit.gif" title="编辑"/>编辑':function(menuItem,menu) {editDocument1(); }},
  {'<img src="../images/inner_menu_recall.gif" title="撤销审核"/>撤销审核':function(menuItem,menu) {deleteFile2(); }},
	<%if(!channel.getRecommendOut().equals("")){%>{'<img src="../images/inner_menu_recommend.gif" title="推荐"/>推荐':function(menuItem,menu) {recommendOut();}},<%}%>
	<%if(!channel.getAttribute1().equals("")){%>{'<img src="../images/inner_menu_quote.gif" title="引用"/>引用':function(menuItem,menu) {recommendIn();}},<%}%>
  //{'<img src="../images/inner_menu_cache.gif" title="刷新Cache"/>刷新Cache':function(menuItem,menu) {RefreshItem(); }},
  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile_1();}}
];
$('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
});
//$("#img_1").draggable({ iframeFix: true } );
</script>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
