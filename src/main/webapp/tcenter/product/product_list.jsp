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

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>

<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/content.js"></script>
<script>
var rows = <%=rows%>;
var cols = <%=cols%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var listType=1;


function editProduct(id)
{
	var url="product/product_edit.jsp?id="+id;
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(300);
		dialog.setUrl(url);
		dialog.setTitle("编辑产品信息");
		dialog.show();
}

function editLicense(id)
{
	var url="product/license_edit.jsp?id="+id;
	var	dialog = new top.TideDialog();
		dialog.setWidth(550);
		dialog.setHeight(380);
		dialog.setUrl(url);
		dialog.setTitle("更新许可证");
		dialog.show();
}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">产品管理：</div>
    <div class="content_new_post">
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
    <td><form name="search_form" action="<%=pageName%>?rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：评论内容
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
    <input type="submit" name="Submit" class="submit" value="查找"><input type="hidden" name="OpenSearch" id="OpenSearch" value="0"></form></td>
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
<div class="viewpane">
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable1" class="view_table comment_list">
<thead>
		<tr id="oTable1_th">
					<th class="v1" align="center" valign="middle" width="20">编号</th>
    				<th class="v1" align="center" valign="middle" width="50">产品名称</th>
    				<th class="v1" align="center" valign="middle" width="100">产品地址</th>
					<th class="v1" align="center" valign="middle" width="50">产品状态</th>
					<th class="v1" align="center" valign="middle" width="50">许可证</th>
    				<th class="v9" width="40" align="center" valign="middle">>></th>
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


ListSql += " order by id asc";

//out.println(ListSql);

int listnum = rowsPerPage;
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
	
	String createdate	= "";//convertNull(Rs.getString("CreateDate"));
	String StatusDesc = "";

	if(Status==0)
		StatusDesc = "<font color=red>关闭</font>";
	else if(Status==1)
		StatusDesc = "<font color=green>启用</font>";
	j++;

	String license = "";
	String company		= "授权客户："+convertNull(Rs.getString("company"));
	String licenseType	= convertNull(Rs.getString("licenseType"));
	long expiresDate	= Rs.getLong("expiresDate");

	if(licenseType.equals("Commercial"))
		license = "永久许可";
	else
	{
		if(expiresDate>0)
			license = "授权到期日："+Util.FormatDate("",expiresDate);
	}

	license = "<span title='"+company+"'>"+license+"</span>";
	if(Code.equals("TideHome")||Code.equals("TideAIR"))
		license = "";

	boolean btn_license = true;
	if(Code.equals("TideHome")||Code.equals("TideAIR")||Code.equals("TideVideoEditor"))
		btn_license = false;
%>
  <tr No="<%=j%>" ItemID="<%=id_%>" status="<%=Status%>" id="item_<%=id_%>" class="tide_item">
	<td class="v1" align="center" valign="middle"><%=id_%></td>
    <td class="v1" align="left" valign="middle">&nbsp;&nbsp;&nbsp;&nbsp;<%=Name%></td>
    <td class="v1" align="left" valign="middle">&nbsp;&nbsp;&nbsp;&nbsp;<%=Url%></td>
	<td class="v1" align="center" valign="middle"><%=StatusDesc%></td>
	<td class="v1" align="center" valign="middle"><%=license%></td>
	<td class="v9">
	<div class="tidecms_btn" onClick="editProduct(<%=id_%>)"><div class="t_btn_txt">编辑</div></div>
	<%if(Status==1 && btn_license){%><div class="tidecms_btn" onClick="editLicense(<%=id_%>)"><div class="t_btn_txt">更新许可证</div></div><%}%>
  </tr>
  <%

}


tu.closeRs(Rs);
%>
 </tbody> 
</table>
</div>
<script>
var page={currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
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
            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="rowsPerPage" onChange="change('#rowsPerPage','');" id="rowsPerPage">
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
  
</div>
 

<script type="text/javascript">
jQuery(document).ready(function(){

	$("img[type='tide']").each(function(i){
   autoLoadImage(true,120,120,"",$(this));
 });
$("#rows").val(rows);
$("#cols").val(cols);

});
//$("#img_1").draggable({ iframeFix: true } );
</script>
</body>
</html>
