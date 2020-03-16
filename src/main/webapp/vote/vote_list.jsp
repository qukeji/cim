<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
int id = CmsCache.getParameter("sys_channelid_vote_option").getIntValue();
if(id==0) id = 4;//如果没有定义投票选项频道编号，则编号为4

int video_channelid = getIntParameter(request,"channelid");
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

int listType = 1;

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
int itemid = getIntParameter(request,"itemid");
int globalid = getIntParameter(request,"globalid");
Document item = new Document();
if(globalid>0) 
	item = new Document(globalid);
else
{
	item = new Document(itemid,video_channelid);
	globalid = item.getGlobalID();
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms7.css" type="text/css" rel="stylesheet" />
<link href="../style/9/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<style> 
body{background:none;} 
</style>
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
var itemid = <%=itemid%>;
var globalid = <%=globalid%>;
var rows = <%=rows%>;
var cols = <%=cols%>;
var ChannelID = channelid = <%=ChannelID%>;
var video_channelid = <%=video_channelid%>;
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

function addOption()
{
	if(itemid==0)
	{
		$.getJSON("../content/document_getnew.jsp?id="+parent.channelid, function(o){
			itemid = o.itemid;
			globalid = o.globalid;
			parent.document.form.GlobalID.value = o.globalid;
			parent.document.form.ItemID.value = o.itemid;
			parent.document.form.Action.value = "Update";
			tidecms.dialog("../vote/vote_add.jsp?itemid="+itemid+"&globalid="+globalid,500,300,"添加调查选项",2);
		}); 
	}
	else
	{
		tidecms.dialog("../vote/vote_add.jsp?itemid="+itemid+"&globalid="+globalid,500,300,"添加调查选项",2);
	}
}

function Preview22(id)
{
	tidecms.dialog("../video/video_player.jsp?id="+id,640,510,"视频预览",2);
}

var progress_ids = "";
var timer = null;

function showProgress()
{
	$.getJSON("video_progress.jsp?id=" + progress_ids, function(j){
		//tidecms.log(j.length);
		for(var i = 0;i<j.length;i++)
		{
			var o = j[i];
			//tidecms.log("progress:"+o.progress);
			$("#item_"+o.id+" .upload_jdt_box").css("width",o.progress+"%");
			if(o.progress==100)
			{
				$("#item_"+o.id+" .progress_desc").html("<font color=blue>转码完成</font>");
				$("#item_"+o.id+" .video_preview").show();
				document.location = document.location;
			}
			else if(o.progress>0)
			{
				$("#item_"+o.id+" .progress_desc").html("<font color=blue>正在转码</font>");
			}
		}
	}); 

	if(progress_ids=="")
		clearInterval(timer);
}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav"></div>
    <div class="content_new_post">
		<div class="top_button button_inline_block" onClick="addOption();">
				<div class="top_button_outer button_inline_block">
					<div class="top_button_inner button_inline_block">
						<span class="img"><img src="../images/icon/add.png" /></span>
						<span class="txt">添加选项</span>
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
    <td></td>
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
                <li><a href="javascript:list('Status1=-1');">草稿</a></li>
                <li><a href="javascript:list('Status1=1');">已发</a></li>
                <li class="last"><a href="javascript:list('IsDelete=1');">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
               <!--<li><a href="#">归档</a></li> -->
                <li  class="first"><a href="javascript:approve();">发布</a></li>
            <!--   <li><a href="javascript:Publish();">发布</a></li> -->  
                <li><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:editDocument1();">编辑</a></li>
				 <li><a href="javascript:deleteFile2();">撤稿</a></li>
				<%if(!channel.getRecommendOut().equals("")){%>	
					<li><a href="javascript:recommendOut();">推荐</a></li>
				<%}%>
				<%if(!channel.getAttribute1().equals("")){%>
				<li><a href="javascript:recommendIn();">引用</a></li>
				<%}%>

					<li><a href="javascript:RefreshItem();">刷新Cache</a></li>
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
    				<th class="v3" style="padding-left:10px;text-align:left;">标题</th>
    				<th class="v8"  align="center" valign="middle">日期</th>
    				<th class="v4"  align="left" valign="middle" style="padding-left:10px;">作者</th>
    				<th class="v9" width="75" align="center" valign="middle">>></th>
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
String ListSql = "select id,Title,Photo,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category";

ListSql += " from " + Table;
String CountSql = "select count(*) from "+Table;

//if(!S_User.equals(""))
	//CountSql = "select count(*) from "+Table+" ";

if(channel.getType()==Channel.Category_Type)
{
	ListSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
	CountSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
}
else if(channel.getType()==Channel.MirrorChannel_Type)
{
}
else
{
	ListSql += " where "+ (!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
	CountSql += " where "+(!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
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

if(S_UserID>0)
{
	WhereSql += " and User="+S_UserID;
}

if(globalid==0) globalid = -1;

WhereSql += " and Parent=" + globalid;

if(S_Status!=0)
	WhereSql += " and Status=" + (S_Status-1);

if(Status1!=0)
{
	if(Status1==-1)
		WhereSql += " and Status=0";
	else
		WhereSql += " and Status=" + Status1;
}

ListSql += WhereSql;
CountSql += WhereSql;


ListSql += " order by OrderNumber desc";

//out.println(ListSql);

int listnum = rowsPerPage;
if(listType==2) listnum = cols*rows;

TableUtil tu = channel.getTableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);

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
	int active = Rs.getInt("Active");
	String Title	= convertNull(Rs.getString("Title"));

	if(listAll)
	{
		if(category>0)
			Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
	}
	int GlobalID=Rs.getInt("GlobalID");
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
  <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  status="<%=Status%>"  GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item">
    <td class="v1" width="25" align="center" valign="middle"><input name="id" value="<%=id_%>" type="checkbox"/></td>
    <td class="v3" style="font-weight:700;" ondragstart="OnDragStart (event)">
	<img id="img_<%=j%>" src="../images/tree6.png"/><%=Title%></td>
    <td class="v8" > <%=ModifiedDate%></td>
     <td class="v4" style="color:#666666;"><%=UserName%></td>
	<td class="v9">
	<%if(active==1){%><div class="v9_button" onclick="approve2(<%=id_%>);"><img src="../images/v9_button_1.gif" title="发布" /></div><%}%>
	<%if(active==0){%><div class="v9_button" onclick="resume(<%=id_%>);"><img src="../images/icon/16.png" title="恢复" /></div><%}else{%>
    <div class="v9_button video_preview" style="display:" onclick="Preview22(<%=id_%>);"><img src="../images/v9_button_2.gif" title="预览" /></div>
	<%}%>
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
                <li><a href="javascript:list('Status1=-1');">草稿</a></li>
                <li><a href="javascript:list('Status1=1');">已发</a></li>
                <li class="last"><a href="javascript:list('IsDelete=1');">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
               <!--<li><a href="#">归档</a></li> -->
                <li  class="first"><a href="javascript:approve();">发布</a></li>
            <!--   <li><a href="javascript:Publish();">发布</a></li> -->  
                <li><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:editDocument1();">编辑</a></li>
				<li><a href="javascript:deleteFile2();">撤稿</a></li>
				<%if(!channel.getRecommendOut().equals("")){%>	
					<li><a href="javascript:recommendOut();">推荐</a></li>
				<%}%>
				<%if(!channel.getAttribute1().equals("")){%>
				<li><a href="javascript:recommendIn();">引用</a></li>
				<%}%>
					<li><a href="javascript:RefreshItem();">刷新Cache</a></li>
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
  {'<img src="../images/inner_menu_release.gif" title="发布"/>发布':function(menuItem,menu) {approve();} },
  {'<img src="../images/inner_menu_preview.gif" title="预览"/>预览':function(menuItem,menu) {Preview(); }},
  {'<img src="../images/inner_menu_edit.gif" title="编辑"/>编辑':function(menuItem,menu) {editDocument1(); }},
  {'<img src="../images/inner_menu_recall.gif" title="撤稿"/>撤稿':function(menuItem,menu) {deleteFile2(); }},
	<%if(!channel.getRecommendOut().equals("")){%>{'<img src="../images/inner_menu_recommend.gif" title="推荐"/>推荐':function(menuItem,menu) {recommendOut();}},<%}%>
	<%if(!channel.getAttribute1().equals("")){%>{'<img src="../images/inner_menu_quote.gif" title="引用"/>引用':function(menuItem,menu) {recommendIn();}},<%}%>

  {'<img src="../images/inner_menu_cache.gif" title="刷新Cache"/>刷新Cache':function(menuItem,menu) {RefreshItem(); }},
  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile(); }}
];
 jQuery('#oTable tr:gt(0)').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
});
//$("#img_1").draggable({ iframeFix: true } );
</script>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
