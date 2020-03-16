<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
 *		修改人		日期		备注
 *		王海龙		20131111	修改排序功能 添加initSort SortDoc js方法
 *
 */
/*文档列表页*/
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");

int globalid = getIntParameter(request,"globalid");
int childid = getIntParameter(request,"childid");
String globalids="";
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
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();
String gids = "";
System.out.println(channel.getListProgram());
if(channel.getListProgram().length()>0)
{
	String pro = channel.getListProgram();
	System.out.println("pro2+++"+pro);
	if(pro.contains("&id=")||pro.contains("?id=")){
	}else if(pro.contains("?")){
		pro+="&id="+id;
	}else if(!pro.contains("?")){
		pro+="?id="+id;
	}
	//System.out.println("pro+++"+pro);
		
	//response.sendRedirect(channel.getListProgram()+"?id="+id);
	response.sendRedirect(pro);
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

int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list",request.getCookies()));
if(listType==0) listType = 1;
//if(listType==2)//图片列表形式
//	response.sendRedirect("content_image.jsp?id="+id);

boolean listAll = false;

if(channel.isTableChannel() && channel.getType2()==8) listAll = true;
if(channel.getIsListAll()==1) listAll = true;
if(S_IsIncludeSubChannel==1) listAll = true;

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

boolean canApprove = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);
boolean canDelete = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanDelete);
boolean canAdd = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanAdd);
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
<%if(IsWeight==1){%><script type="text/javascript" src="../common/jquery.jeditable.js"></script><%}%>
<script type="text/javascript" src="../common/ui.draggable.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/content.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script>
var listType = <%=listType%>;
var rows = <%=rows%>;
var cols = <%=cols%>;
var ChannelID = <%=childid%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var pageName = "<%=pageName%>";
var myObject = new Object();
if(pageName=="") pageName = "content.jsp";
function initSort(){
	$("#oTable tbody tr td img").mousedown(function(){
		sortableEnable();
	});
}
function SortDoc(){
	var size = $(".cur").length;
	if(size>1||size<=0){
		alert("请选择一个待排序的选项");
	}else{
    myObject.title="排序";
	myObject.ChannelID =ChannelID;
	myObject.ItemId =$(".cur").attr("ItemID");
	myObject.OrderNumber = $(".cur").attr("OrderNumber");
		
 
	var url= "content/document_sort.jsp?ChannelID="+ChannelID+"&ItemID="+myObject.ItemId+"&OrderNumber="+myObject.OrderNumber;
	var	dialog = new top.TideDialog();
		dialog.setWidth(250);
		dialog.setHeight(162);
		dialog.setUrl(url);
		dialog.setTitle(myObject.title);
		dialog.show();
	}
}
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
</script>
</head>
<body onload="initSort();">

<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content">
<div class="viewpane">
<%if(channel.hasRight(userinfo_session,1)){
String listcss = "";
if(listType==1) listcss = "viewpane_tbdoy";
if(listType==2) listcss = "viewpane_pic_txt";
if(listType==3) listcss = "viewpane_pic_list";
	%>
        <div class="<%=listcss%>">
<table width="100%" border="0" id="oTable" class="view_table">
<%if(listType==1){%>
<thead>
		<tr id="oTable_th">
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;">标题</th>
					<%if(IsWeight==1){%>
					<th class="v5" align="center" valign="middle">权重</th>
					<%}%>
    				<th class="v1"	align="center" valign="middle">状态</th>
    				<th class="v8"  align="center" valign="middle">日期</th>
    				<th class="v4"  align="left" valign="middle" style="padding-left:10px;">作者</th>
    				<%if(IsComment==1){%>
    				<th class="v7" align="center" valign="middle">评论</th>
    				<%}%>	
    				<%if(IsClick==1){%>
    				<th class="v6" align="center" valign="middle">点击量</th>
    				<%}%>
    				
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
Channel child = CmsCache.getChannel(childid);
String Table = child.getTableName();
String ListSql = "select id,Title,Photo,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,Parent";

if(listType==2)
{
	ListSql += ",Summary,Content,Keyword";
}
if(channel.getIsWeight()==1)
	ListSql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
ListSql += " from " + Table;
String CountSql = "select count(*) from "+Table;

//if(!S_User.equals(""))
	//CountSql = "select count(*) from "+Table+" ";

if(!listAll)
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
else
{
	ListSql += " where ChannelCode like '"+channel.getChannelCode()+"%' and Active=" + IsActive;
	CountSql += " where ChannelCode like '"+channel.getChannelCode()+"%' and Active=" + IsActive;
}

String WhereSql = "";

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

/*
if(S_IsIncludeSubChannel==1)
{
	WhereSql += " and ChannelCode like '"+channel.getChannelCode() + "%'";
}*/

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
WhereSql = WhereSql+" and Parent="+globalid;
ListSql += WhereSql;
CountSql += WhereSql;
//System.out.println("listSql="+ListSql);
//System.out.println("CountSql="+CountSql);
if(channel.getIsWeight()==1)
{
	ListSql += " order by newtime desc,id desc";
}
else
{
	ListSql += " order by OrderNumber desc";
}

//out.println(ListSql);

int listnum = rowsPerPage;
if(listType==3) listnum = cols*rows;

TableUtil tu = channel.getTableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;
int m = 0;
int temp_gid=0;
while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	int category = Rs.getInt("Category");
	int user = Rs.getInt("User");
	int active = Rs.getInt("Active");
	String Title	= convertNull(Rs.getString("Title"));
	if(listAll)
	{
		if(category>0)
			Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
	}
	int Weight=Rs.getInt("Weight");
	int GlobalID=Rs.getInt("GlobalID");


	if(temp_gid!=0){
		globalids+=",";
	}
	temp_gid++;
	globalids+=GlobalID+"";


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

	if(gids.length()>0){gids+=","+GlobalID+"";}else{gids=GlobalID+"";}

	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;

	if(listType==1)
	{
%>
  <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  status="<%=Status%>" GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item">
    <td class="v1 checkbox" width="25" align="center" valign="middle"><input name="id" value="<%=id_%>" type="checkbox"/></td>
    <td class="v3" style="font-weight:700;" ondragstart="OnDragStart (event)">
	<img id="img_<%=j%>" src="../images/tree6.png"/><%=Title%></td>
    <%if(IsWeight==1){%><td class="v5" width="43" align="center" valign="middle"><span class="weightClass"  ItemID="<%=id_%>"><%=Weight%></span></td><%}%>
	<td class="v1" align="center" valign="middle"><%=StatusDesc%></td>
    <td class="v8" > <%=ModifiedDate%></td>
     <td class="v4" style="color:#666666;"><%=UserName%></td>
	 <%if(IsComment==1){%><td class="v7"><span id="comment_<%=GlobalID%>"></span></td><%}%>
	<%if(IsClick==1){%><td class="v6" ><span id="click_<%=GlobalID%>"></span></td><%}%>

  </tr>
  <%}
	

}

if(listType==3 && m<cols) out.println("</tr>");

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
        	
        	<div class="left">共<%=TotalNumber%>条</div>

            <div class="right">
            </div>
        </div>
  <%}%>      
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

<%if(listType==2 || listType==3){%>
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
  <%if(canApprove){%>{'<img src="../images/inner_menu_release.gif" title="发布"/>发布':function(menuItem,menu) {approve();} },<%}%>
  {'<img src="../images/inner_menu_preview.gif" title="预览"/>预览':function(menuItem,menu) {Preview(); }},
  {'<img src="../images/inner_menu_edit.gif" title="编辑"/>编辑':function(menuItem,menu) {editDocument1(); }},
  {'<img src="../images/inner_menu_recall.gif" title="撤稿"/>撤稿':function(menuItem,menu) {deleteFile2(); }},
	<%if(!channel.getRecommendOut().equals("")){%>{'<img src="../images/inner_menu_recommend.gif" title="推荐"/>推荐':function(menuItem,menu) {recommendOut();}},<%}%>
	<%if(!channel.getAttribute1().equals("")){%>{'<img src="../images/inner_menu_quote.gif" title="引用"/>引用':function(menuItem,menu) {recommendIn();}},<%}%>
	<%if(IsWeight!=1){%>{'<img src="../images/inner_menu_taxis.gif" title="排序"/>排序':function(menuItem,menu) {SortDoc(); }},<%}%>
  {'<img src="../images/inner_menu_cache.gif" title="刷新Cache"/>刷新Cache':function(menuItem,menu) {RefreshItem(); }}
 <%if(canDelete){%>
	 ,{'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile();}}
<%}%>
];
//$(document).bind("contextmenu",function(){return false;});
$('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
 <%if(IsWeight==1){%>WeightAddColor();<%} if(IsComment==1) out.println("showCommentCount('"+gids+"');");%>
});
//$("#img_1").draggable({ iframeFix: true } );
</script>
<script type="text/javascript">
//alert("<%=globalids%>");
<%if(IsClick==1&&listType==1){%>
	
	$.ajax({
			type : "POST",
			url : "../ums/get_clicknum.jsp",
			data: "globalids=<%=globalids%>",
			async:false,
			dataType:"json",
            success : function(msg){
				//alert(msg);
				for(var tempi=0;tempi<msg.length;tempi++){
					//alert(msg[tempi].id+","+msg[tempi].clicknum);
					$("#click_"+msg[tempi].id).html(msg[tempi].clicknum);
				}
            }
    });
	<%}%>
</script>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
