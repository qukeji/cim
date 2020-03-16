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
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
int userid=userinfo_session.getId();
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
if(channel.getIsListAll()==1) listAll = true;

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

int Status1			=	getIntParameter(request,"Status1");

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

function Preview22(id)
{
	tidecms.dialog("content/video_player3.jsp?id="+id,640,510,"视频预览");
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

function deleteFile(){
	var obj=getCheckbox();
	var message = "确实要删除这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要删除的文件！");
	}else{
		 if(confirm(message)){
			 var url="comment_action_blog.jsp?id=" + obj.id+"&action=1";
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
	var message = "确实要撤稿这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要撤稿的文档！");
	}else{
		 if(confirm(message)){
			 var url="comment_action_blog.jsp?id=" + obj.id+"&action=3";
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
	 var url= "comment_action_blog.jsp?id=" + id +"&action=2";
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.href=document.location.href;}   
		}); 
}
function Preview22(id, uid){
	window.open("http://sns.tidedemo.com/space.php?uid="+uid+"&do=blog&id="+id);
}

function Preview()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要预览的文件！");
		}else if(obj.length>1){
		alert("请选择一个要预览的文件！");
		}else{
		var uid = $("#item_" + obj.id).attr("uid");
		Preview22(obj.id,uid);
		}
} 
function recommendOut()
{
	var id="";
	var approved = true;
	var fromchannelid=0;
	$("#oTable input:checked").each(function(i){
		if(i==0)
			id+=$(this).val();
		else
			id+=","+$(this).val();

	});

	var obj=getCheckbox();
	if(id==""){
		alert("请选择要被采用的文档！");
		return;
	}

	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(450);
	dialog.setUrl("sns/sns_recommend_out_index.jsp?ChannelID="+13962+"&ids="+id+"&sns_tablename=uchome_blog&userid="+<%=userid%>);
	dialog.setTitle("推荐");
	dialog.show();	
}

function double_click()
{
	jQuery("#oTable .tide_item").dblclick(function(){
		var obj=jQuery(":checkbox",jQuery(this));
		var id = $(this).attr("id_");
		obj.trigger("click");
		window.open("http://sns.tidedemo.com/cp.php?ac=blog&blogid=" + id + "&op=edit");
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
		<div class="top_button button_inline_block" onClick="addDocument();">
				<div class="top_button_outer button_inline_block">
					<div class="top_button_inner button_inline_block">
						<span class="img"><img src="../images/icon/add.png" /></span>
						<span class="txt">新建</span>
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
    <td><form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：标题
		  <input name="Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
		  
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
			<!--<span class="toolbar1">显示：</span>
			<ul class="toolbar2">
                <li class="first"><a href="javascript:list();">全部</a></li>
                <li><a href="javascript:list('Status1=-1');">未审核</a></li>
                <li class="last"><a href="javascript:list('Status1=1');">已审核</a></li>
            </ul> -->
			<span class="toolbar1">操作：</span>
            <ul class="toolbar2">
                <li class="first"><a href="javascript:Preview();">预览</a></li>
				<li><a href="javascript:recommendOut();">推荐</a></li>
				<!--<li><a href="javascript:approve();">审核</a></li>
				<li><a href="javascript:deleteFile2();">撤销审核</a></li>-->
				<li class="last"><a href="javascript:deleteFile();"><font style="color:red;">删除</font></a></li>
            </ul>
        </div> 
    </div>
<div class="viewpane">
<%if(channel.hasRight(userinfo_session,1)){%>
        <div class="<%=listType==2?"viewpane_pic_list":"viewpane_tbdoy"%>">
<table width="100%" border="0" id="oTable" class="view_table">
<%if(listType==1){%>
<thead>
		<tr id="oTable_th">
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;">话题名称</th>
					<th class="v1"	style="text-align:left;" align="" valign="middle">创建日期</th>
					<th class="v1"	style="text-align:left;" align="" valign="middle">作者</th>
    				<th class="v9" width="20" align="center" valign="middle">>></th>
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

String Table = channel.getTableName();
String ListSql = "select FROM_UNIXTIME(dateline) as dateline,blogid,username,uid,subject from uchome_blog";
String CountSql = "select count(*) from uchome_blog";

String WhereSql = " where 1=1 ";
if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and subject like '%" + channel.SQLQuote(tempTitle) + "%'";
}

ListSql += WhereSql;
CountSql += WhereSql;
ListSql += " order by dateline desc";

int listnum = rowsPerPage;
if(listType==2) listnum = cols*rows;

TableUtil tu = new TableUtil("sns");
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);

int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;
int m = 0;

while(Rs.next())
{
	int id_ = Rs.getInt("blogid");
	int uid = Rs.getInt("uid");
	TableUtil tu2 = new TableUtil("sns");
	String sql2 = "select username from uchome_usermagic where uid="+uid;
	ResultSet rs2 = tu2.executeQuery(sql2);
	tu2.closeRs(rs2);
	String dateline	= convertNull(Rs.getString("dateline"));
	dateline=Util.FormatDate("yyyy-MM-dd HH:mm:ss",dateline);
	String username	= convertNull(Rs.getString("username"));
	String title = Rs.getString("subject");
	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;
	if(listType==1)
	{
%>
  <tr No="<%=j%>"  id="item_<%=id_%>" id_="<%=id_%>"  uid="<%=uid%>" username="<%=username%>"  class="tide_item">
    <td class="v1 checkbox" width="25" align="center" valign="middle"><input name="id" value="<%=id_%>" type="checkbox"/></td>
    <td class="v3" style="font-weight:700;" ondragstart="OnDragStart (event)">
	<img id="img_<%=j%>" src="../images/tree6.png"/><%=title%></td>
	<td class="v1" align="" valign="middle"><%=dateline%></td>
	<td class="v1" align="" valign="middle"><%=username%></td>
	<td class="v9">
    <div class="v9_button" onclick="Preview22(<%=id_%>,<%=uid%>);"><img src="../images/preview2.gif" title="正式地址预览"  /></div>
	</td>
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
        	
             <ul class="toolbar2">
			 <!--<span class="toolbar1">显示：</span>
                <li class="first"><a href="javascript:list();">全部</a></li>
                <li><a href="javascript:list('Status1=-1');">未审核</a></li>
                <li class="last"><a href="javascript:list('Status1=1');">已审核</a></li>
            </ul> -->
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
                <li class="first"><a href="javascript:Preview();">预览</a></li>
				<li><a href="javascript:recommendOut();">推荐</a></li>
				<!--<li><a href="javascript:approve();">审核</a></li>
				<li><a href="javascript:deleteFile2();">撤销审核</a></li>-->
				<li class="last"><a href="javascript:deleteFile();"><font style="color:red;">删除</font></a></li>
            </ul>
        </div>
        
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
  {'<img src="../images/inner_menu_preview.gif" title="预览"/>预览':function(menuItem,menu) {Preview(); }},
  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile();}}
];
$('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
});
</script>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
</body>
</html>
