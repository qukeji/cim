<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
//获取分组名称
public String getGroup(int groupid,JSONArray arr) throws SQLException,MessageException,JSONException{
	for(int i=0;i<arr.length();i++){
		JSONObject json1 = arr.getJSONObject(i);//一级分组
		JSONArray arr1 = json1.getJSONArray("module");
		for(int j=0;j<arr1.length();j++){
			JSONObject json2 = arr1.getJSONObject(j);
			String title = json2.getString("title");
			int id = json2.getInt("id");
			if(groupid==id){
				return title ;
			}
		}
	}
	return "";
}
%>
<%
/*
*	最后修改人		修改时间		备注
*/
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
long begin_time = System.currentTimeMillis();

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
String action = getParameter(request,"Action");
int GroupID = getIntParameter(request,"GroupID");

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

String gids = "";

boolean listAll = false;


String S_Title			=	getParameter(request,"Title");
//String S_Summary		=	getParameter(request,"Summary");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
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

//首页模块
TideJson json = CmsCache.getParameter("tcenter_main").getJson();
JSONArray arr = new JSONArray();
if(json!=null&&json.getInt("state")==1){
	arr = json.getJSONArray("main");
}

String parentChannelPath ="产品管理 / ";
if(GroupID==0){
	parentChannelPath += "所有产品";
}else if(GroupID==1){
	parentChannelPath += "运营支撑";
}else if(GroupID==2){
	parentChannelPath += "应用发布";
}else if(GroupID==3){
	parentChannelPath += "资源汇聚";
}else if(GroupID==4){
	parentChannelPath += "生产工具";
}else{
	parentChannelPath += getGroup(GroupID,arr);
}


%>
<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>TideCMS 7 列表</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/common.css">
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/theme/theme.css">

<style>
.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>

<script>
var rows = <%=rows%>;
var cols = <%=cols%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var listType=1;
var GroupID = <%=GroupID%>;
function add()
{
	var url="product_add.jsp?GroupID="+GroupID;
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle("新建产品");
		dialog.show();
}

function editProduct(id)
{
	var url="product_edit2018.jsp?id="+id;
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle("编辑产品");
		dialog.show();
}
function del(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(300);
	dialog.setHeight(260);
	dialog.setUrl("product_del.jsp?id="+id);
	dialog.setTitle("删除产品");
	dialog.show();
}
function editLicense(id)
{
	var url="license_edit2018.jsp?id="+id;
	var	dialog = new top.TideDialog();
		dialog.setWidth(550);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle("更新许可证");
		dialog.show();
}
function SortDoc(id){
	var OrderNumber = $("#item_"+id).attr("OrderNumber");		
	var url= "product_sort.jsp?ItemID="+id+"&OrderNumber="+OrderNumber+"&GroupID="+GroupID;
	var	dialog = new top.TideDialog();
	dialog.setWidth(300);
	dialog.setHeight(230);
	dialog.setUrl(url);
	dialog.setTitle("排序");
	dialog.show();
}
</script>
</head>
<body class="collapsed-menu email">
	<div class="br-mainpanel br-mainpanel-file" id="js-source"> 

		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
			  <span class="breadcrumb-item active"><%=parentChannelPath%></span>
			</nav>
		</div><!-- br-pageheader -->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
			<div class="btn-group hidden-xs-down mg-l-auto">
				<a href="javascript:add();" class="btn btn-outline-info" >新建产品</a>
			</div>
		</div>
		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0" id="content-table">
					<thead>
					  <tr>
						<th class="wd-5p">
						 编号
						</th>
						<th class="tx-12-force tx-mont tx-medium">分组</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">产品名称</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">图标</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">地址</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">授权到期时间</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">是否启用</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">是否弹出</th>
						<th class="tx-12-force wd-300 tx-mont tx-medium hidden-xs-down">操作</th>
					  </tr>
					</thead>
					<tbody>
<%
int S_UserID = 0;
long weightTime = 0;
int IsActive = 0;
if(IsDelete==1) IsActive=1;

String ListSql = "select  * from tide_products ";
String CountSql = "select count(*) from tide_products";

String WhereSql = "";

if(GroupID!=0){
	WhereSql += " where groupId=" + GroupID;
}else{
	if(arr.length()==0){
		WhereSql += " where groupId in(0,1,2,3,4) or groupId is null";
	}
}

ListSql += WhereSql;
CountSql += WhereSql;


ListSql += " order by OrderNumber asc,id asc";

int listnum = 1000;
//System.out.println("ListSql----"+ListSql);
//System.out.println("CountSql----"+CountSql);
TableUtil tu = new TableUtil("user");
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);

int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;
int m = 0;

while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	String number = "";
	int split_number = 0;
	String Name	= convertNull(Rs.getString("Name"));
	String Url	= convertNull(Rs.getString("Url"));
	String Code	= convertNull(Rs.getString("Code"));
	String logo = convertNull(Rs.getString("logo"));
	String code = convertNull(Rs.getString("code"));
	int groupId = Rs.getInt("groupId");
	String group = "";
	if(groupId==1){
		group = "运营支撑";
	}else if(groupId==2){
		group = "应用发布";
	}else if(groupId==3){
		group = "资源汇聚";
	}else if(groupId==4){
		group = "生产工具";
	}else{
		group = getGroup(groupId,arr);
	}

	int type = Rs.getInt("Type");
	
	String createdate	= "";//convertNull(Rs.getString("CreateDate"));
	String StatusDesc = "false";
	if(Status==1)
		StatusDesc = "true";

	int newpage = Rs.getInt("newpage");
	String newpage_ = "false";
	if(newpage==1)
		newpage_ = "true";


	j++;

	String company		= "授权客户："+convertNull(Rs.getString("company"));
	String licenseType	= convertNull(Rs.getString("licenseType"));
	long expiresDate	= Rs.getLong("expiresDate");
	String expiresDate_ = "";
	if(expiresDate>0){
		expiresDate_ = Util.FormatDate("",expiresDate);
	}

	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);

	boolean btn_license = true;
	if(Code.equals("TideHome")||Code.equals("TideAIR")||Code.equals("TideVideoEditor"))
		btn_license = false;
%>
	<tr No="<%=j%>" ItemID="<%=id_%>" status="<%=Status%>" code="<%=code%>" id="item_<%=id_%>" OrderNumber="<%=OrderNumber%>" groupId="<%=groupId%>">
			<td class="hidden-xs-down"><%=j%></td>
			<td class="hidden-xs-down"><%=group%></td>
			<td class="hidden-xs-down"><%=Name%></td>
			<td class="hidden-xs-down" style="font-size: 20px;"><%=logo%></td>
			<td class="hidden-xs-down"><%=Url%></td>
			<td class="hidden-xs-down"><%=expiresDate_%></td>
			<td class="hidden-xs-down">
				<div class='toggle-wrapper'>
					<div class='toggle toggle-light primary' data-toggle-on='<%=StatusDesc%>' product='<%=id_%>' field='Status'></div>
				</div>
			</td>
			<td class="hidden-xs-down">
				<div class='toggle-wrapper'>
					<div class='toggle toggle-light primary' data-toggle-on='<%=newpage_%>' product='<%=id_%>' field='newpage'></div>
				</div>
			</td>
			<td class="dropdown hidden-xs-down">
				<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="SortDoc(<%=id_%>);">排序</button>
				<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="editProduct(<%=id_%>);">编辑</button>
				<%if(type==1){%><button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="del(<%=id_%>);">删除</button><%}%>
				<%if(Status==1 && btn_license){%>
					<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="editLicense(<%=id_%>)">更新许可证</button>
				<%}%>
			</td>
		</tr>
<%
}
tu.closeRs(Rs);
%>
					</tbody> 
				</table>
			</div>
		</div>
		<!--列表-->

	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/peity/jquery.peity.js"></script>
	<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
	<script src="../lib/2018/medium-editor/medium-editor.js"></script>
	<script src="../lib/2018/select2/js/select2.min.js"></script>
	<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
	<script>
	//开关相关
	//初始化
	$('.toggle').toggles({        
	  height: 25
	});
	//获取是否开或关
	$(".toggle").click(function(){
		var myToggle = $(this).data('toggle-active');
		var id = $(this).attr('product');	
		var field = $(this).attr('field');

		var url = "product_action.jsp?Action="+myToggle+"&id="+id+"&field="+field;
		$.ajax({
			type:"GET",
			url:url, 
			success: function(msg){
				alert(msg.trim());
			}
		});
	})
	</script>
</body>
</html>
