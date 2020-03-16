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
/*
*	用途	CMS中显示视频地址
*	修改人		日期		备注
*	郭庆光		20130903	列表页里a标签 弹出视频地址修改，根据sys_video 里videourl判断。
*/
long begin_time = System.currentTimeMillis();
int id = 4;//固定频道编号//CmsCache.getParameter("sys_channelid_transcode").getIntValue();
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
	<!--<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">-->
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	<style>
		.collapsed-menu .br-mainpanel-file {
			margin-left: 0;
			margin-top: 0;
		}
	</style>

	<script src="../lib/2018/jquery/jquery.js"></script>
	<script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>
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

 
  

function Preview22(id)
{
	tidecms.dialog("../video/video_player.jsp?id="+id,640,510,"视频预览",2);
}

</script>
</head>

<body class="collapsed-menu email">

	<div class="br-mainpanel br-mainpanel-file" id="js-source">
		<!-- br-pageheader -->
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
String ListSql = "select id,Title,Photo,video_type,video_desc,Url,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category";

ListSql += " from " + Table;
String CountSql = "select count(*) from "+Table;

ListSql +=  " where Active=1 and Parent=" + globalid;
CountSql +=  "  where Active=1 and Parent=" + globalid;

ListSql += " order by OrderNumber desc";

int listnum = rowsPerPage;

TableUtil tu = channel.getTableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);

int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
%>

		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
			
				<!-- btn-group -->
				<div class="btn-group mg-l-10 hidden-sm-down">
					<%if(currPage>1){%>
					<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
					<%}%>
					<%if(currPage<TotalPageNumber){%>
					<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
					<%}%>
				</div>
				<!-- btn-group -->
		</div>
		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30 <%=listType==2?"viewpane_pic_list":"viewpane_tbdoy"%>">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0" id="content-table">
<%if(listType==1){%>
					<thead>
						<tr>
							<th class="tx-12-force tx-mont tx-medium">编号</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">代码</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">标题</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">日期</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">操作</th>
						</tr>
					</thead>
<%}%>					
					<tbody>
<%
int j = 0;
int m = 0;
 
while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	int user = Rs.getInt("User");
	int active = Rs.getInt("Active");
	int video_type = Rs.getInt("video_type");

	String Title	= Rs.getString("video_desc");
	String Url = convertNull(Rs.getString("Url"));
 
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
				<tr  No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  status="<%=Status%>" GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item">
					<td class="valign-middle">
						<label class="ckbox mg-b-0">
						<input type="checkbox" name="id" value="<%=id_%>"><span></span>
					  </label>
					</td>  
					<td ondragstart="OnDragStart(event)">
					  <i class="icon ion-clipboard tx-22 tx-warning lh-0 valign-middle" id="img_<%=j%>"></i>
					  <span class="pd-l-5 tx-black"><%=Title%></span>
					</td>
					<td class="hidden-xs-down">
						<a href="<%=Util.ClearPath(Url)%>">
							<%=Url%>
						</a>
					</td>
					<td class="hidden-xs-down">
					</td>
					<td class="hidden-xs-down">
						<%=ModifiedDate%>
					</td>			
					<td class="dropdown hidden-xs-down">
					<a href="javascript:Preview22(<%=id_%>);" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
				    </td>
				</tr>
<%
	}		
}
tu.closeRs(Rs);
%>
					</tbody>
                </table>
	           <script>
	   				var page = {
						id: '<%=id%>',
						currPage: '<%=currPage%>',
						rowsPerPage: '<%=rowsPerPage%>',
						querystring: '<%=querystring%>',
						TotalPageNumber: <%=TotalPageNumber%>
					};
				</script>				
			<%if(TotalPageNumber>0){%>
				<!--分页-->
				
				<div id="tide_content_tfoot">
				    <label class="ckbox mg-b-0 mg-r-30 ">
						<input type="checkbox" id="checkAll_1"><span></span>
			        </label>
					<span class="mg-r-20 ">共<%=TotalNumber%>条</span>
					<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

				<%if(TotalPageNumber>1){%>
	
					<div class="jump_page ">
						<span class="">跳至:</span>
						<label class="wd-60 mg-b-0">
							<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
						</label>
						<span class="">页</span>
						<a id="goToId" href="javascript:;" class="tx-14">Go</a>
                    </div>
				<%}%>
					<div class="each-page-num mg-l-auto">
						<span class="">每页显示:</span>
						<label class="wd-80 mg-b-0">
							<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="状态" onChange="change(this);" id="rowsPerPage">
								<option value="10" >10</option>
								<option value="15">15</option>
								<option value="20">20</option>
								<option value="25" >25</option>
								<option value="30" >30</option>
								<option value="50" >50</option>
								<option value="80" >80</option>
								<option value="100" >100</option>							
							</select>
                         </label> 条
					</div>
                </div>
                <!--分页-->
				<%}%>
			</div>
		</div>
		<!--列表-->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
				
				<!-- btn-group -->
				<div class="btn-group mg-l-10 hidden-sm-down">
					<%if(currPage>1){%>
					<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
					<%}%>
					<%if(currPage<TotalPageNumber){%>
					<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
					<%}%>
				</div>
				<!-- btn-group -->
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
			jQuery(document).ready(function() {
				jQuery("#rowsPerPage").val('<%=rowsPerPage%>');

				jQuery("#goToId").click(function() {
					var num = jQuery("#jumpNum").val();
					if (num == "") {
						var action="numberNull";
		                 alertDialog(action);	
						//alert("请输入数字!");
						jQuery("#jumpNum").focus();
						return;
					}
					var reg = /^[0-9]+$/;
					if (!reg.test(num)) {
						var action="numberNull";
		                 alertDialog(action);	
						//alert("请输入数字!");
						jQuery("#jumpNum").focus();
						return;
					}

					if (num < 1)
						num = 1;
					var href = "parameter2018.jsp?currPage=" + num + "&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
					document.location.href = href;
				});
			});
//alert改弹窗
function alertDialog(action)
{
	
		var	dialog = new top.TideDialog();
		dialog.setWidth(320);
		dialog.setHeight(240);
		dialog.setUrl("../explorer/alertDialog2018.jsp?action="+action);
		dialog.setTitle("提示");
		dialog.show();	
}
			function change(obj) {
				if (obj != null) this.location = "parameter2018.jsp?rowsPerPage=" + obj.value + "<%=querystring%>";
			}
		</script>
	</div>
</body>

</html>