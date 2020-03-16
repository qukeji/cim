<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.text.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!

	public static String formatDate(long time,String pattern) {
		// TODO Auto-generated method stub
		if(pattern.length()==0){
			pattern = "yyyy-MM-dd HH:mm:ss";
		}
		SimpleDateFormat df = new SimpleDateFormat(pattern);
		java.util.Date date = new java.util.Date(time*1000);
		String format = df.format(date);
		return format;
	}
 %>
<%
//String domainname = CmsCache.getParameterValue("sns_domainname_address");
//String tableprefix = CmsCache.getParameterValue("sns_tableprefix");
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
id = CmsCache.getParameter("sys_tidehome_config").getJson().getInt("user");
if(id==0) id=14189;
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
/*
if(channel.getListProgram().length()>0)
{response.sendRedirect(channel.getListProgram()+"?id="+id);return;}
*/
String S_Title			=	getParameter(request,"Title");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");
String S_email			=	getParameter(request,"S_email");
String S_Phone			=	getParameter(request,"S_Phone");
int Status1			=	getIntParameter(request,"Status1");

int listType = 1;

boolean listAll = false;


String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1+"&S_email="+S_email+"&S_mobile"+S_Phone;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);
	
	//out.println(pageName);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用户</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<link href="../style/tidecms7.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/content.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>


<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<script type="text/javascript" src="../common/ui.draggable.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script>
var listType = <%=listType%>;
var rows = <%=rows%>;
var cols = <%=cols%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var pageName = "<%=pageName%>";
var ChannelID="<%=id%>";
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;

$(function(){
tidecms.setDatePicker("#CreateDate1");
});

function gopage(currpage)
{
	//alert("<%=pageName%>");
	pageName="<%=pageName%>";
	var url = pageName + "?currPage="+currpage+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
	//alert(url);
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
<style type="text/css">
.viewpane_c1 .ui-datepicker-trigger {
    vertical-align: middle;
    margin: 0 5px 0 5px;
    margin-top: 0px;
    margin-right: 5px;
    margin-bottom: 0px;
    margin-left: 5px;
}
</style>


</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：用户</div>

</div>
<div class="viewpane_c1" id="SearchArea" >
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
<table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20"> </td>
    <td><form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：用户名
	<input name="Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
	手机
	<input name="S_Phone" type="text" size="18" class="textfield" value="<%=S_Phone%>">
	 邮箱
	<input name="S_email" type="text" size="18" class="textfield" value="<%=S_email%>">
	注册日期：
	<input id="CreateDate" name="CreateDate" type="text" size="10"  class="textfield" value="<%=S_CreateDate%>">
	至 
	<input  id="CreateDate1" name="CreateDate1" type="text" size="10"  class="textfield" value="<%=S_CreateDate1%>">
    <input type="submit" name="Submit" class="tidecms_btn3" value="查找"><input type="hidden" name="OpenSearch" id="OpenSearch" value="1"></form></td>
    <td width="20"> </td>
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

<div class="content_2012">
 	<div class="toolbar">
    	<div class="toolbar_l">
			<span class="toolbar1">显示：</span>
            <ul class="toolbar2">
            <li class="first"><a href="javascript:list();">全部</a></li>
            <li class="last"><a href="javascript:list('IsDelete=1');">已删除</a></li>	
			</ul>
			<span class="toolbar1">操作：</span>
            <ul class="toolbar2">
			<li class="first"><a href="javascript:editDocument1();">编辑</a></li>
			<li class="last"><a href="javascript:deleteFile();"><font style="color:red;">删除</font></a></li>
				
            </ul>
        </div>
    </div>
<div class="viewpane">
<%
String listcss = "viewpane_tbdoy";
	%>
        <div class="<%=listcss%>">
<table width="100%" border="0" id="oTable" class="view_table">
<%if(listType==1){%>
<thead>
		<tr id="oTable_th">
    				<th class="v1" width="25" align="center" valign="middle"><img src="" /></th>
                     
    				<th align="center" valign="middle">用户名</th>
					<th align="center" valign="middle">昵称</th>
    				<th align="center" valign="middle">手机</th>
          <!--           <th align="left" valign="middle">地区</th>--> 
          			<th align="center" valign="middle">邮箱</th>
					<th align="center" valign="middle">注册IP</th>
					<th align="center" valign="middle">注册时间</th>
					<th align="center" valign="middle">最后登录时间</th>
					<%if(IsDelete==1){ %>
					<th class="v9" width="75" align="center" valign="middle">>></th>
					<%} %>
	
  				</tr>
</thead>
<%}%>
 <tbody> 
<%
int S_UserID = 0;
long weightTime = 0;
int IsActive = 1;
if(IsDelete==1) IsActive=0;

Channel channel = CmsCache.getChannel(id);
String Table = channel.getTableName();
String ListSql = "select id,Active,Email,title,province,city,Truename,Phone,address,summary,FROM_UNIXTIME(CreateDate) as CreateDate,ModifiedDate, FROM_UNIXTIME(lastLogin) as lastLogin ,ip ,avatar from "+Table+" where  Active= "+IsActive;
String CountSql = "select count(*) from "+Table+" where  Active= "+IsActive;

String WhereSql = "";

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and title='" + Util.SQLQuote(tempTitle) + "'";
}

if(!S_CreateDate.equals("")){
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	java.util.Date date = df.parse(S_CreateDate+" 00:00:00");
	long sdate = date.getTime()/1000;
	WhereSql += " and CreateDate >= " +sdate;
	
}

if(!S_CreateDate1.equals("")){
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	java.util.Date date = df.parse(S_CreateDate1+" 23:59:59");
	long sdate = date.getTime()/1000;
	WhereSql += " and CreateDate < " +sdate;
	
}

if(!S_email.equals("")){
	WhereSql += " and Email like '%" +S_email+"%'";
}

if(!S_Phone.equals("")){
	WhereSql += " and Phone like '%" +S_Phone+"%'";
}
ListSql += WhereSql;
CountSql += WhereSql;
ListSql += " order by createdate desc";
int listnum = rowsPerPage;
if(listType==3) listnum = cols*rows;
 //out.println("List="+ListSql);
//System.out.println("CountSql="+CountSql);
TableUtil tu = new TableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;
int m = 0;

while(Rs.next())
{
	int		id_		= Rs.getInt("id");
	String	avatar	= convertNull(Rs.getString("avatar"));
	String	title	= convertNull(Rs.getString("title"));
	String	email	= convertNull(Rs.getString("email"));
	String	name	= convertNull(Rs.getString("Truename"));
	//int 	sex		= Rs.getInt("sex");
	//String supper	= convertNull(Rs.getString("supper"));
	String province	= convertNull(Rs.getString("province"));
	String city		= convertNull(Rs.getString("city"));
	String phone	= convertNull(Rs.getString("phone"));
	 String CreateDate	= convertNull(Rs.getString("CreateDate"));
	CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm",CreateDate);
	 String lastLogin =  convertNull(Rs.getString("lastLogin"));
	lastLogin=Util.FormatDate("yyyy-MM-dd HH:mm",lastLogin);

	String ip = convertNull(Rs.getString("ip"));
	int active = Rs.getInt("Active");

//	String sexDesc = "";
//	if(sex==1){
//		sexDesc="男";
//	}else if(sex==2){
//		sexDesc="女";
//	}
	j++;
%>
  <tr No="<%=j%>" ItemID="<%=id_%>"  id="item_<%=id_%>" id_="<%=id_%>" class="tide_item">
    <td class="v1 checkbox" width="25" align="center" valign="middle"><input name="id" value="<%=id_%>" type="checkbox"/></td>
   
    <td align="center" valign="middle"><%=title%><p style="color:red;"></p></td>
	<td align="center" valign="middle"><%=name%></td>
    <td align="center" valign="middle"><%=phone%></td>
    <td align="center" valign="middle"><%=email%></td>
	 <td align="center" valign="middle"><%=ip%></td>
    <td align="center" valign="middle"><%=CreateDate%></td>
	 <td align="center" valign="middle"><%=lastLogin%></td>
    
	<%if(IsActive==0){%><td><div class="v9_button" onclick="resume(<%=id_%>);"><img src="../images/icon/16.png" title="恢复" /></div></td><%}%>
	
	
	<!--  
	<td align="center" valign="middle">
	<span style="cursor:pointer;" onclick="Preview22(<%=id_%>);"><img src="../images/preview2.gif" title="正式地址预览"/></span>
	</td>
	-->
  </tr>
  <%
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
<%}%>
            </div>
        </div>
  <%}%>      
  </div>
    <div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
  
   	<div class="toolbar">
    	<div class="toolbar_l">
		<span class="toolbar1">显示：</span>
            <ul class="toolbar2">
            <li class="first"><a href="javascript:list();">全部</a></li>
            <li class="last"><a href="javascript:list('IsDelete=1');">已删除</a></li>	
			</ul>
			<span class="toolbar1">操作：</span>
            <ul class ="toolbar2" >
			<li class="first"><a href="javascript:editDocument1();">编辑</a></li>
			<li class="last"><a href="javascript:deleteFile();"><font style="color:red;">删除</font></a></li>
				
            </ul>
        </div>
    </div>
</div>
</body>
</html>

