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
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
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


function approve_(id)
{
	 var url= "comment_action.jsp?id=" + id +"&action=2";
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.reload();}   
		}); 
}
function addTask()
{
	var url="system/job_add.jsp";
	var	dialog = new top.TideDialog();
		dialog.setWidth(450);
		dialog.setHeight(450);
		dialog.setUrl(url);
		dialog.setTitle("添加调度方案");
		dialog.show();
}
function editTask(id,type)
{
	var url="system/job_edit.jsp?id="+id+"&type="+type;
	var	dialog = new top.TideDialog();
		dialog.setWidth(450);
		dialog.setHeight(450);
		dialog.setUrl(url);
		dialog.setTitle("编辑调度方案");
		dialog.show();
}

function Publish_Enable(id)
{

	var url = "../system/job_action.jsp?Action=Enable&id="+id;
	this.location.href = url;
}

function Publish_Disable(id)
{
	var url = "../system/job_action.jsp?Action=Disable&id="+id;
	this.location.href = url;
}
function joblist(id)
{
	var url = "../system/quartz_to_publish.jsp";
	this.location.href = url;
}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">调度管理：</div>
    <div class="content_new_post">
 		<div class="tidecms_btn" onClick="joblist();">
			<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
			<div class="t_btn_txt">运行任务查看</div>
		</div>
		<div class="tidecms_btn" onClick="addTask();">
			<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
			<div class="t_btn_txt">新建</div>
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
	<!-- 图片新闻
		  <input type="checkbox" name="IsPhotoNews" value="1" <%=(S_IsPhotoNews==1?"checked":"")%>> -->	
		 <!--包含子频道
		  <input type="checkbox" name="IsIncludeSubChannel" value="1" <%=(S_IsIncludeSubChannel==1?"checked":"")%>> -->
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
 <div class="content_2012">
	<!--<div class="toolbar">
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
               <li><a href="#">归档</a></li>
                <li  class="first"><a href="javascript:approve();">审核通过</a></li>
            <li><a href="javascript:Publish();">发布</a></li>  
                <li><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:editDocument1();">编辑</a></li>
				 <li><a href="javascript:deleteFile2();">撤销审核</a></li>
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
         <ul class="toolbar_r">
        	<li class="<%=listType==1?"b1_cur":"b1"%>" title="文字列表" onClick="changeList(1);"></li>
            <li class="<%=listType==2?"b3_cur":"b3"%>" title="图片平铺" onClick="changeList(2);"></li>
        </ul> 
    </div>-->
<div class="viewpane">
<%if(channel.hasRight(userinfo_session,1)){%>
        <div class="<%=listType==2?"viewpane_pic_list":"viewpane_tbdoy"%>">
<table width="100%" border="0" id="oTable1" class="view_table comment_list">
<%if(listType==1){%>
<thead>
		<tr id="oTable1_th">
    				<th class="v1" width="15" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
					<th class="v1" align="center" valign="middle" width="50">编号</th>
    				<th class="v1" align="center" valign="middle" width="50">调度名称</th>
    				<th class="v1" align="center" valign="middle" width="100">调度程序</th>
					<th class="v1" align="center" valign="middle" width="100">调度机制</th>
					<th class="v1" align="center" valign="middle" width="100">创建时间</th>
					<th class="v1" align="center" valign="middle" width="50">状态</th>
    				<th class="v9" width="40" align="center" valign="middle">>></th>
  				</tr>
</thead>
<%}%>
 <tbody> 
<%
int S_UserID = 0;
long weightTime = 0;
int IsActive = 0;
if(IsDelete==1) IsActive=1;

if(!S_User.equals("")){
	String sql2="select * from quartz_manager";
	TableUtil tu2 = new TableUtil();
	ResultSet Rs2 = tu2.executeQuery(sql2);
	if(Rs2.next()){
		S_UserID=Rs2.getInt("authorid");
	}else{
		S_UserID=0;
	}
}

//System.out.println("time:"+weightTime);
String Table = channel.getTableName();
String ListSql = "select  id,Title,Jobtime,Program,CreateDate,"+
				"Status,Remark,Type from quartz_manager ";
String CountSql = "select count(*) from quartz_manager";

//if(!S_User.equals(""))
	//CountSql = "select count(*) from "+Table+" ";

ListSql += " where createdate!='0000-00-00 00:00:00' and 1=1 ";
CountSql += " where createdate!='0000-00-00 00:00:00' and 1=1 ";

String WhereSql = "";

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and Jobname like '%" + channel.SQLQuote(tempTitle) + "%'";
}

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


ListSql += " order by id desc";

//out.println(ListSql);

int listnum = rowsPerPage;
if(listType==2) listnum = cols*rows;
//System.out.println("ListSql----"+ListSql);
//System.out.println("CountSql----"+CountSql);
TableUtil tu = new TableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);

int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;
int m = 0;

while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	int type = Rs.getInt("Type");
	String jobname  = "job_"+id_;
	String title	= convertNull(Rs.getString("Title"));
	String jobtime	= convertNull(Rs.getString("Jobtime"));
	String program	= convertNull(Rs.getString("Program"));
	String remark	= convertNull(Rs.getString("Remark"));
	
	String triggername = "trigger_"+id_;
	String createdate	= convertNull(Rs.getString("CreateDate"));
	//createdate=Util.FormatDate("MM-dd HH:mm",createdate);
	String StatusDesc = "";

	if(Status==1)
		StatusDesc = "<font color=green>开启</font>";
	else if(Status==0)
		StatusDesc = "<font color=red>关闭</font>";

	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;

	if(listType==1)
	{
%>
  <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  status="<%=Status%>" id="item_<%=id_%>" class="tide_item">
    <td class="v1" align="center" valign="middle"><input name="id" value="<%=id_%>" type="checkbox"/></td>
	<td class="v1" align="center" valign="middle"><%=id_%></td>
    <td class="v1" align="center" valign="middle"><%=title%></td>
    <td class="v1" align="center" valign="middle"><%=program%></td>
	<td class="v1" align="center" valign="middle"><%=jobtime%></td>
	<td class="v1" align="center" valign="middle"><%=createdate%></td>
	<td class="v1" align="center" valign="middle"><%=StatusDesc%></td>
	<td class="v9">
	
	<div class="tidecms_btn <%=Status==0?"":"disabled"%>"  onClick="Publish_Enable(<%=id_%>)"><div class="t_btn_txt">启动</div></div>
	<div class="tidecms_btn <%=Status==1?"":"disabled"%>"  onClick="Publish_Disable(<%=id_%>)"><div class="t_btn_txt">关闭</div></div>
	<%if(!userinfo_session.hasPermission("DisableEditPublishScheme")){%>
	<div class="tidecms_btn" onClick="editTask(<%=id_%>,<%=type%>)"><div class="t_btn_txt">编辑</div></div>
	<%}%>
	<%if(type!=1){%>
	<div class="tidecms_btn" onClick="if(confirm('你确认要删除吗?')) location='job_action.jsp?Action=Del&id=<%=id_%>'; else return false;"><div class="t_btn_txt">删除</div></div>
	<%}%>
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
  
	<!--<div class="toolbar" style="margin:14px 0 0;">
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
               <!--<li><a href="#">归档</a></li> 
                <li  class="first"><a href="javascript:approve();">审核通过</a></li>
            <!--   <li><a href="javascript:Publish();">发布</a></li> 
                <li><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:editDocument1();">编辑</a></li>
				<li><a href="javascript:deleteFile2();">撤销审核</a></li>
				<%if(!channel.getRecommendOut().equals("")){%>	
					<li><a href="javascript:recommendOut();">推荐</a></li>
				<%}%>
				<%if(!channel.getAttribute1().equals("")){%>
				<li><a href="javascript:recommendIn();">引用</a></li>
				<%}%>
					<!--<li><a href="javascript:RefreshItem();">刷新Cache</a></li>
					<li class="last"><a href="javascript:deleteFile();"><font style="color:red;">删除</font></a></li>
            </ul>
        </div>
        <!-- <ul class="toolbar_r">
        	<li class="<%=listType==1?"b1_cur":"b1"%>" title="文字列表" onClick="changeList(1);"></li>
            <li class="<%=listType==2?"b3_cur":"b3"%>" title="图片平铺" onClick="changeList(2);"></li>
        </ul>
    </div>-->

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

});
//$("#img_1").draggable({ iframeFix: true } );
</script>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
