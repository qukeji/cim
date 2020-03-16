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
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">
<style>
.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
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
	var url="job_add2018.jsp";
	var	dialog = new top.TideDialog();
		dialog.setWidth(550);
		dialog.setHeight(550);
		dialog.setUrl(url);
		dialog.setTitle("添加调度方案");
		dialog.show();
}
function editTask(id,type)
{
	var url="job_edit2018.jsp?id="+id+"&type="+type;
	var	dialog = new top.TideDialog();
		dialog.setWidth(550);
		dialog.setHeight(450);
		dialog.setUrl(url);
		dialog.setTitle("编辑调度方案");
		dialog.show();
}

function Publish_Enable(id)
{

	var url = "../system/job_action2018.jsp?Action=Enable&id="+id;
	this.location.href = url;
}

function Publish_Disable(id)
{
	var url = "../system/job_action2018.jsp?Action=Disable&id="+id;
	this.location.href = url;
}
function joblist(id)
{
	var url = "../system/quartz_to_publish2018.jsp";
	this.location.href = url;
}
function del(id)
{
	
	var url="job_action_del2018.jsp?id="+id;
	var	dialog = new top.TideDialog();
	dialog.setWidth(320);
	dialog.setHeight(260);
	//dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("删除调度任务");
	dialog.show();	
}
</script>
</head>
<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">  
        <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">系统调度管理 / 内容调度管理</span>
        </nav>
        <div class="btn-group mg-l-auto hidden-xs-down">
            <a href="javascript:;" class="btn btn-info list_draft" onClick="joblist();">运行时任务查看</a>&nbsp;
            <a href="javascript:;" class="btn btn-info list_draft" onClick="addTask();">新建</a>
        </div><!-- btn-group -->
        </div><!-- br-pageheader --> 
	 <%if(channel.hasRight(userinfo_session,1)){%>
   <div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">
			<%if(listType==1){%>
			 <thead>
				  <tr id="oTable1_th">											
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">编号</th>                    					
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">调度名称</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">调度程序</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">调度机制</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">创建时间</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">状态</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">操作</th>					
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
		<tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  status="<%=Status%>" id="item_<%=id_%>">		
			<td class="hidden-xs-down"><%=id_%></td>	
			<td class="hidden-xs-down"><%=title%></td>
			<td class="hidden-xs-down"><%=program%></td>						
		    <td class="hidden-xs-down"><%=jobtime%></td>
			<td class="hidden-xs-down"><%=createdate%></td>
			<td class="hidden-xs-down"><%=StatusDesc%></td>
			<td class="dropdown hidden-xs-down">
				<button type="button" onclick="Publish_Enable(<%=id_%>);" class="btn btn-info btn-sm mg-r-8 mg-b-8 tx-13 <%=Status==0?"":"disabled"%>">启动</button>
				<button type="button" onclick="Publish_Disable(<%=id_%>);" class="btn btn-info btn-sm mg-r-8 mg-b-8 tx-13 <%=Status==1?"":"disabled"%>">关闭</button>
				<%if(!userinfo_session.hasPermission("DisableEditPublishScheme")){%>
				<button type="button" onclick="editTask(<%=id_%>,<%=type%>);" class="btn btn-info btn-sm mg-r-8 mg-b-8 tx-13" >编辑</button>
				<%}%>
				<%if(type!=1){%>
				<button type="button" onClick="del('<%=id_%>')" class="btn btn-info btn-sm mg-r-8 mg-b-8 tx-13">删除</button>
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
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
</script>   
<%if(TotalPageNumber>0){%> 
<!--分页-->
			<div id="tide_content_tfoot">	
			   <div class="btn-group mg-l-10 hidden-xs-down">选择：<span id="selectAll">全部</span><span id="selectNo">无</span></div>
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
				
          		<div class="each-page-num mg-l-auto">
<%if(listType==1){%>
          		<span class="">每页显示:</span>
                     <label class="wd-80 mg-b-0">
          			<select name="rowsPerPage" class="form-control select2 wd-80"  onChange="change('#rowsPerPage','<%=id%>');" id="rowsPerPage">
						<option value="10" >10</option>
						<option value="15" >15</option>
						<option value="20" >20</option>
						<option value="25" >25</option>
						<option value="30" >30</option>
						<option value="50" >50</option>
						<option value="80" >80</option>
						<option value="100">100</option>						
					</select>
                    </label> 条
<%}
if(listType==2){%>
				<span class="">每页显示:</span>
                     <label class="wd-80 mg-b-0">
          			<select name="rows" class="form-control select2 wd-80"  onChange="changeRowsCols();" id="rows">
						<option value="3" >10</option>
						<option value="5" >15</option>
						<option value="8" >20</option>
						<option value="10" >25</option>
						<option value="20" >30</option>
						<option value="50" >50</option>						
						<option value="100" <%=rows==100?"selected":""%>>100</option>  
					</select>
                    </label> 行
                     <label class="wd-80 mg-b-0">
          			<select name="cols" class="form-control select2 wd-80"  onChange="changeRowsCols();" id="cols">
						<option value="3" >10</option>
						<option value="4" >15</option>
						<option value="5" >20</option>
						<option value="6" >25</option>
						<option value="7" >30</option>
						<option value="8" >50</option>
						<option value="10" >80</option>
						<option value="16" <%=cols==16?"selected":""%>>100</option>					
					</select>
                    </label> 列
<%}%>					
          		</div>
			</div><!--分页-->
<%}%>    
</div>
</div><!--列表-->
</div>
<%}else{%>

<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:0};
</script> 
<%}%>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script src="../common/2018/content.js"></script>
<script type="text/javascript">
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
                        <!-- 原jsp地址是parameter.jsp  记录在此以防改回-->
		var href="content_quartz2018.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%>&id=<%=id%>";
		document.location.href=href;
	});

<%if(listType==2){%>
	$("img[type='tide']").each(function(i){
   autoLoadImage(true,120,120,"",$(this));
 });
$("#rows").val(rows);
$("#cols").val(cols);
<%}%>

/*  <%if(S_OpenSearch!=1){%>
	sortable();
	sortableDisable();
	<%if(sortable==1){%>
		sortableEnable();
	<%}%>
<%}%>
*/
});
//$("#img_1").draggable({ iframeFix: true } );
</script>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
