<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
String sortable = getParameter(request,"sortable");
int LinkChannelID	= getIntParameter(request,"LinkChannelID");
int LinkChannelID2 = getIntParameter(request,"LinkChannelID2");
int ChannelID	= getIntParameter(request,"ChannelID");
int GlobalID = getIntParameter(request,"GlobalID");
int fieldgroup	= getIntParameter(request,"fieldgroup");

if(id==0){
	id=LinkChannelID;
}
if(LinkChannelID==0){
	LinkChannelID=id;
}
if(currPage<1)
	currPage = 1;

if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage = 15;

Channel channel = null;

if(LinkChannelID2>0)
	channel = CmsCache.getChannel(LinkChannelID2);//如果LinkChannelID2大于0，频道取LinkChannelID2
else
	channel = CmsCache.getChannel(LinkChannelID);

Channel parentchannel = null;
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();

String SiteAddress = channel.getSite().getUrl();

int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list",request.getCookies()));
if(listType==0) listType = 1;

boolean listAll = false;

if(channel.isTableChannel() && channel.getType2()==8) listAll = true;


String S_Title			=	getParameter(request,"Title");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");
String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);
String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&GlobalID="+GlobalID+"&ChannelID="+ChannelID+"&fieldgroup="+fieldgroup+"&IsPhotoNews="+S_IsPhotoNews+"&listtype="+listType+"&LinkChannelID="+LinkChannelID+"&LinkChannelID2="+LinkChannelID2;

int Status1			=	getIntParameter(request,"Status1");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/tidecms7.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<script type="text/javascript" src="../common/jquery.jeditable.js"></script>
<script type="text/javascript" src="../common/content.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script>
var listType = <%=listType%>;
var ChannelID = <%=ChannelID%>;
var LinkChannelID = <%=LinkChannelID%>;
var GlobalID = <%=GlobalID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var fieldgroup = <%=fieldgroup%>;
var pageName = "<%=pageName%>";
function recommend()
{
	var obj=getGlobalID();
	if(obj.length==0){
		alert("请先选择文档！");
		return;
	}
	//window.console.info("select_child_submit_items.jsp?GlobalID="+GlobalID+"&ChannelID=" + ChannelID + "&LinkChannelID="+LinkChannelID+"&ChildGlobalID=" + obj.id);
	top.location = "select_child_submit_items.jsp?GlobalID="+GlobalID+"&ChannelID=" + ChannelID + "&LinkChannelID="+LinkChannelID+"&ChildGlobalID=" + obj.id+"&fieldgroup="+fieldgroup;
}

function editDocument(id)
{
	top.location = "document.jsp?ItemID=0&ChannelID=" + top.ChannelID + "&RecommendItemID=" + id + "&RecommendChannelID=" + ChannelID;
}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%=channel.getParentChannelPath()%></div>
    <div class="content_new_post">
		<div class="top_button button_inline_block" onClick="openSearch();">
				<div class="top_button_outer button_inline_block">
					<div class="top_button_inner button_inline_block">
						<span class="img"><img src="../images/icon/preview.png" /></span>
						<span class="txt">检索</span>
					</div>
				</div>	
		</div>
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
    <td><form name="search_form" action="select_child_content.jsp?rowsPerPage=<%=rowsPerPage%>&ChannelID=<%=ChannelID%>&LinkChannelID=<%=LinkChannelID%>&GlobalID=<%=GlobalID%>&fieldgroup=<%=fieldgroup%>&LinkChannelID2=<%=LinkChannelID2%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：标题
		  <input name="Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
		  创建日期
		  <select name="CreateDate1" >
		    <option value=">" <%=(S_CreateDate1.equals(">")||S_CreateDate1.equals("")?"selected":"")%>>大于</option>
		    <option value="=" <%=(S_CreateDate1.equals("=")?"selected":"")%>>等于</option>
		    <option value="<" <%=(S_CreateDate1.equals("<")?"selected":"")%>>小于</option>
      </select>
		  <input name="CreateDate" type="text" size="10"  class="textfield" value="<%=S_CreateDate%>"><img align="absmiddle" src="../images/calendar.gif" onclick="selectdate('CreateDate');">
		   
		  作者
		  <input name="User" type="text" size="10"  class="textfield" value="<%=S_User%>">
		  状态
		  <select name="Status" >
		    <option value="0" <%=(S_Status==0?"selected":"")%>></option>
		    <option value="2" <%=(S_Status==2?"selected":"")%>>已发</option>
		    <option value="1" <%=(S_Status==1?"selected":"")%>>草稿</option>
      </select>
	<!-- 图片新闻
		  <input type="checkbox" name="IsPhotoNews" value="1" <%=(S_IsPhotoNews==1?"checked":"")%>> -->	
		 包含子频道
		  <input type="checkbox" name="IsIncludeSubChannel" value="1" <%=(S_IsIncludeSubChannel==1?"checked":"")%>> 
    <input type="submit" name="Submit" class="tidecms_btn3" value="查找">
	<input type="hidden" name="OpenSearch" id="OpenSearch" value="0">
	<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	<input type="hidden" name="GlobalID" value="<%=GlobalID%>">
	<input type="hidden" name="LinkChannelID" value="<%=LinkChannelID%>">
	<input type="hidden" name="fieldgroup" value="<%=fieldgroup%>">
	</form></td>
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
                    <ul style="display:none;">
                    	<li><a href="recommend_content.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>">全部</a></li>
                    	<li><a href="recommend_content.jsp?id=<%=id%>&Status1=-1&rowsPerPage=<%=rowsPerPage%>">草稿 
</a></li>
                        <li><a href="recommend_content.jsp?id=<%=id%>&Status1=1&rowsPerPage=<%=rowsPerPage%>">已发</a></li>
                        <li><a href="recommend_content.jsp?id=<%=id%>&IsDelete=1&rowsPerPage=<%=rowsPerPage%>">已删除</a></li>
                    </ul>
                </li>
            </ul>
            <ul class="toolbar2">
            	<li class="first"><a href="recommend_content.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>">全部</a></li>
                <li><a href="recommend_content.jsp?id=<%=id%>&Status1=-1&rowsPerPage=<%=rowsPerPage%>">草稿</a></li>
                <li><a href="recommend_content.jsp?id=<%=id%>&Status1=1&rowsPerPage=<%=rowsPerPage%>">已发</a></li>
                <li class="last"><a href="recommend_content.jsp?id=<%=id%>&IsDelete=1&rowsPerPage=<%=rowsPerPage%>">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
                <li  class="first"><a href="javascript:recommend();">确定引用</a></li>
            </ul>
        </div>
        <ul class="toolbar_r">
        	<li class="<%=listType==1?"b1_cur":"b1"%>" title="文字列表" onClick="changeList(1);"></li>
            <li class="<%=listType==2?"b3_cur":"b3"%>" title="图片平铺" onClick="changeList(2);"></li>
        </ul>
    </div>
  	<div class="viewpane">
<%if(channel.hasRight(userinfo_session,1)){%>
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;">标题</th>
					<%if(IsWeight==1){%>
					<th class="v5" align="center" valign="middle">权重</th>
					<%}%>
    				<th class="v1"	align="center" valign="middle">状态</th>
    				<th class="v8"  align="center" valign="middle">日期</th>
    				<th class="v4"  align="left" valign="middle" style="padding-left:10px;">作者</th>
    				<th class="v9" width="100" align="center" valign="middle">>></th>
  				</tr>
</thead>
 <tbody> 
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
String ListSql = "select id,Title,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Category,User,Photo";

if(channel.getIsWeight()==1)
	ListSql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
ListSql += " from " + Table;
String CountSql = "select count(*) from "+Table;

//if(!S_User.equals(""))
	//CountSql = "select count(*) from "+Table+" ";
String WhereSql = "";
if(channel.getListSql().length()>0)
{
	ListSql += " where " + channel.getListSql() + " and Active=" + IsActive;
	CountSql += " where " + channel.getListSql() + " and Active=" + IsActive;
}
else
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

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
}
if(!S_CreateDate.equals("")){
	long fromTime=Util.getFromTime(S_CreateDate,"");
	if(S_CreateDate1.equals("=")){
		WhereSql += " and CreateDate>="+fromTime;
		WhereSql += " and CreateDate<"+(fromTime+86400);
	}else{
		WhereSql += " and CreateDate" + S_CreateDate1+fromTime;
	}
}

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
if(channel.getType()==Channel.Category_Type)
	WhereSql +=" and category="+channel.getId();
ListSql += WhereSql;
CountSql += WhereSql;

if(channel.getIsWeight()==1)
{
	ListSql += " order by newtime desc,id desc";
}
else
{
	ListSql += " order by OrderNumber desc";
}
//out.println(ListSql);

TableUtil tu = channel.getTableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;
int m = 0;

while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	int category = Rs.getInt("Category");
	int user = Rs.getInt("User");
	String Title	= convertNull(Rs.getString("Title"));
	if(listAll)
	{
		if(category>0)
			Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
	}
	int Weight=Rs.getInt("Weight");
	int GlobalID_=Rs.getInt("GlobalID");
	String ModifiedDate	= convertNull(Rs.getString("ModifiedDate"));
	ModifiedDate=Util.FormatDate("MM-dd HH:mm",ModifiedDate);
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
	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;
	
	if(listType==1)
	{
%>
  <tr class="tide_item" id="item_<%=id_%>" No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  GlobalID="<%=GlobalID_%>">
    <td class="v1" width="25" align="center" valign="middle"><input name="id" value="<%=id_%>" type="checkbox"/></td>
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png" ondragstart="Drag()"/><%=Title%></td>
    <%if(IsWeight==1){%><td class="v5" width="43" align="center" valign="middle"><span class="weightClass"  ItemID="<%=id_%>"><%=Weight%></span></td><%}%>
	<td class="v1" align="center" valign="middle"><%=StatusDesc%></td>
    <td class="v8" > <%=ModifiedDate%></td>
     <td class="v4"  style="color:#666666;"><%=UserName%></td>
	<td class="v9">
	<div class="v9_button" onclick="approve2(<%=id_%>);"><img src="../images/v9_button_1.gif" title="发布" /></div>
    <div class="v9_button" onclick="Preview2(<%=id_%>);"><img src="../images/v9_button_2.gif" title="预览" /></div>
	<div class="v9_button" onclick="Preview3(<%=id_%>);"><img src="../images/preview2.gif" title="正式地址预览" /></div>
	</td>
  </tr>
  <%}

	if(listType==2)
	{
		String Photo	= convertNull(Rs.getString("Photo"));
		String photoAddr = "";
		if(Photo.startsWith("http://"))
			photoAddr = Photo;
		else
			photoAddr = SiteAddress + Photo;
		if(m==0) out.println("<tr>");
		m++;
%>
<%
	}

	}
tu.closeRs(Rs);
%>
 </tbody> 
</table>
<div style="position:absolute;right:0;top:120px;display:none;"  id="jTipId">
        <ul class="toolbar2">
                <li  class="first"><a href="javascript:recommend();">确定引用</a></li>
            </ul>
    	</div>

        </div>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
</script>        
<%if(TotalPageNumber>0){%> 
        <div class="viewpane_pages">
        	<div class="select">选择：<span id="selectAll">全部</span><span id="selectNo">无</span>			</div>
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span onclick="goToPage();" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="select_child_content.jsp?currPage=1&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="select_child_content.jsp?currPage=<%=currPage-1%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="select_child_content.jsp?currPage=<%=currPage+1%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="select_child_content.jsp?currPage=<%=TotalPageNumber%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}%>
            <div class="right">
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
                    <ul style="display:none;">
                    	<li><a href="select_child_content.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>">全部</a></li>
                    	<li><a href="select_child_content.jsp?id=<%=id%>&Status1=-1&rowsPerPage=<%=rowsPerPage%>">草稿 
</a></li>
                        <li><a href="select_child_content.jsp?id=<%=id%>&Status1=1&rowsPerPage=<%=rowsPerPage%>">已发</a></li>
                        <li><a href="select_child_content.jsp?id=<%=id%>&IsDelete=1&rowsPerPage=<%=rowsPerPage%>">已删除</a></li>
                    </ul>
                </li>
            </ul>
            <ul class="toolbar2">
            	<li class="first"><a href="select_child_content.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>">全部</a></li>
                <li><a href="select_child_content.jsp?id=<%=id%>&Status1=-1&rowsPerPage=<%=rowsPerPage%>">草稿</a></li>
                <li><a href="select_child_content.jsp?id=<%=id%>&Status1=1&rowsPerPage=<%=rowsPerPage%>">已发</a></li>
                <li class="last"><a href="select_child_content.jsp?id=<%=id%>&IsDelete=1&rowsPerPage=<%=rowsPerPage%>">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
                <li  class="first"><a href="javascript:recommend();">确定引用</a></li>
            </ul>
        </div>
        <ul class="toolbar_r">
        	<li class="<%=listType==1?"b1_cur":"b1"%>" title="文字列表" onClick="changeList(1);"></li>
            <li class="<%=listType==2?"b3_cur":"b3"%>" title="图片平铺" onClick="changeList(2);"></li>
        </ul>
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
function goToPage(){
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

		if(num>page.TotalPageNumber)
			num=page.TotalPageNumber;
		if(num<1)
			num=1;
		var href="select_child_content.jsp?currPage="+num+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		document.location.href=href;
}

function change(s,id)
{
	var value=jQuery(s).val();
	var exp  = new Date();
	exp.setTime(exp.getTime() + 300*24*60*60*1000);
	document.cookie = "rowsPerPage="+value;
	document.location.href = "select_child_content.jsp?id="+id+"<%=querystring%>&rowsPerPage="+value;
}

jQuery(document).ready(function(){
<%if(S_OpenSearch!=1){%>
	sortable();
	sortableDisable();
	<%if(sortable.equals("enable")){%>
		sortableEnable();
	<%}%>
<%}%>

var beforeShowFunc = function() {}
var menu = [
  {'<img src="../images/inner_menu_release.gif" title="确定引用"/>确定引用':function(menuItem,menu) {recommend();} }];
 jQuery('#oTable tr:gt(0)').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
 <%if(IsWeight==1){%>WeightAddColor();<%}%>
});
</script>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
